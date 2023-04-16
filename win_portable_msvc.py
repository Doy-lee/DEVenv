#!/usr/bin/env python3

# This script has been gratefully sourced from Martins Mozeiko of HMN
# https://gist.github.com/mmozeiko/7f3162ec2988e81e56d5c4e22cde9977
#
# Further modifications by https://github.com/doy-lee with the primary purpose
# of facilitating multiple versions to be stored in the same root directory
# ('Redist' in the SDK was unversioned, store it versioned like all other
# folders, skip the downloading of MSVC or the SDK if we only need one of them).
#
# Changelog
# 2023-04-15
# - Fix "msvc-{version}.bat" script generating trailing "\;" on
#   VCToolsInstallDir environment variable. clang-cl relies on this variable to
#   identify the location of the Visual Studio toolchain or otherwise reports a
#   program invocation error during the linking stage.
#
# 2023-01-30
# - Generate the short-hand version of the msvc-{version}.bat and
#   win-sdk-{version}.bat using the versions passed as the argument parameter.
# - Fix win-sdk-{version}.bat overwriting the INCLUDE and LIB environment
#   variables instead of appending.
#
# 2023-01-28
# - Inital revision from mmozeiko
#   https://gist.github.com/mmozeiko/7f3162ec2988e81e56d5c4e22cde9977/6863f19cb98b933c7535acf3d59ac64268c6bd1b
# - Add individual scripts to source variables for MSVC and Windows 10
#   separately "msvc-{version}.bat" and "win-sdk-{version}.bat"
# - Add '--no-sdk' and '--no-msvc' to prevent the download and installation of
#   the Windows SDK and MSVC respectively.
# - Installation used to create 'Windows Kit/10/Redist' and unpack a D3D and MBN
#   folder without being versioned. These folders are now placed under
#   a versioned sub-directory to preserve the binaries and allow subsequent
#   side-by-side installation of other versions of the SDK.

import io
import os
import sys
import json
import shutil
import hashlib
import zipfile
import tempfile
import argparse
import subprocess
import urllib.request
from pathlib import Path

OUTPUT = Path("msvc") # output folder

# other architectures may work or may not - not really tested
HOST   = "x64" # or x86
TARGET = "x64" # or x86, arm, arm64

MANIFEST_URL = "https://aka.ms/vs/17/release/channel"


def download(url):
  with urllib.request.urlopen(url) as res:
    return res.read()

def download_progress(url, check, name, f):
  data = io.BytesIO()
  with urllib.request.urlopen(url) as res:
    total = int(res.headers["Content-Length"])
    size = 0
    while True:
      block = res.read(1<<20)
      if not block:
        break
      f.write(block)
      data.write(block)
      size += len(block)
      perc = size * 100 // total
      print(f"\r{name} ... {perc}%", end="")
  print()
  data = data.getvalue()
  digest = hashlib.sha256(data).hexdigest()
  if check.lower() != digest:
    exit(f"Hash mismatch for f{pkg}")
  return data

# super crappy msi format parser just to find required .cab files
def get_msi_cabs(msi):
  index = 0
  while True:
    index = msi.find(b".cab", index+4)
    if index < 0:
      return
    yield msi[index-32:index+4].decode("ascii")

def first(items, cond):
  return next(item for item in items if cond(item))
  

### parse command-line arguments

ap = argparse.ArgumentParser()
ap.add_argument("--show-versions", const=True, action="store_const", help="Show available MSVC and Windows SDK versions")
ap.add_argument("--accept-license", const=True, action="store_const", help="Automatically accept license")
ap.add_argument("--msvc-version", help="Get specific MSVC version")
ap.add_argument("--sdk-version", help="Get specific Windows SDK version")
ap.add_argument("--no-msvc", const=True, action="store_const", help="Skip download and installing of msvc")
ap.add_argument("--no-sdk", const=True, action="store_const", help="Skip download and installing of Windows SDK")
args = ap.parse_args()

### get main manifest

manifest = json.loads(download(MANIFEST_URL))


### download VS manifest

vs = first(manifest["channelItems"], lambda x: x["id"] == "Microsoft.VisualStudio.Manifests.VisualStudio")
payload = vs["payloads"][0]["url"]

vsmanifest = json.loads(download(payload))


### find MSVC & WinSDK versions

packages = {}
for p in vsmanifest["packages"]:
  packages.setdefault(p["id"].lower(), []).append(p)

msvc = {}
sdk = {}

for pid,p in packages.items():
  if pid.startswith("Microsoft.VisualStudio.Component.VC.".lower()) and pid.endswith(".x86.x64".lower()):
    pver = ".".join(pid.split(".")[4:6])
    if pver[0].isnumeric():
      msvc[pver] = pid
  elif pid.startswith("Microsoft.VisualStudio.Component.Windows10SDK.".lower()) or \
       pid.startswith("Microsoft.VisualStudio.Component.Windows11SDK.".lower()):
    pver = pid.split(".")[-1]
    if pver.isnumeric():
      sdk[pver] = pid

if args.show_versions:
  print("MSVC versions:", " ".join(sorted(msvc.keys())))
  print("Windows SDK versions:", " ".join(sorted(sdk.keys())))
  exit(0)

install_sdk  = not args.no_sdk
install_msvc = not args.no_msvc
if args.no_sdk and args.no_msvc:
    exit()

msvc_ver = args.msvc_version or max(sorted(msvc.keys()))
sdk_ver = args.sdk_version or max(sorted(sdk.keys()))

info_line = "Downloading"
if install_msvc:
    if msvc_ver in msvc:
      msvc_pid = msvc[msvc_ver]
      msvc_ver = ".".join(msvc_pid.split(".")[4:-2])
    else:
      exit(f"Unknown MSVC version: f{args.msvc_version}")
    info_line += f" MSVC v{msvc_ver}"

if install_sdk:
    if sdk_ver in sdk:
      sdk_pid = sdk[sdk_ver]
    else:
      exit(f"Unknown Windows SDK version: f{args.sdk_version}")
    info_line += f" Windows SDK v{sdk_ver}"

print(info_line)


### agree to license

tools = first(manifest["channelItems"], lambda x: x["id"] == "Microsoft.VisualStudio.Product.BuildTools")
resource = first(tools["localizedResources"], lambda x: x["language"] == "en-us")
license = resource["license"]

if not args.accept_license:
  accept = input(f"Do you accept Visual Studio license at {license} [Y/N] ? ")
  if not accept or accept[0].lower() != "y":
    exit(0)

OUTPUT.mkdir(exist_ok=True)
total_download = 0

### download MSVC

if install_msvc:
    msvc_packages = [
      # MSVC binaries
      f"microsoft.vc.{msvc_ver}.tools.host{HOST}.target{TARGET}.base",
      f"microsoft.vc.{msvc_ver}.tools.host{HOST}.target{TARGET}.res.base",
      # MSVC headers
      f"microsoft.vc.{msvc_ver}.crt.headers.base",
      # MSVC libs
      f"microsoft.vc.{msvc_ver}.crt.{TARGET}.desktop.base",
      f"microsoft.vc.{msvc_ver}.crt.{TARGET}.store.base",
      # MSVC runtime source
      f"microsoft.vc.{msvc_ver}.crt.source.base",
      # ASAN
      f"microsoft.vc.{msvc_ver}.asan.headers.base",
      f"microsoft.vc.{msvc_ver}.asan.{TARGET}.base",
      # MSVC redist
      #f"microsoft.vc.{msvc_ver}.crt.redist.x64.base",
    ]

    for pkg in msvc_packages:
      p = first(packages[pkg], lambda p: p.get("language") in (None, "en-US"))
      for payload in p["payloads"]:
        with tempfile.TemporaryFile() as f:
          data = download_progress(payload["url"], payload["sha256"], pkg, f)
          total_download += len(data)
          with zipfile.ZipFile(f) as z:
            for name in z.namelist():
              if name.startswith("Contents/"):
                out = OUTPUT / Path(name).relative_to("Contents")
                out.parent.mkdir(parents=True, exist_ok=True)
                out.write_bytes(z.read(name))


### download Windows SDK

if install_sdk:
    sdk_packages = [
      # Windows SDK tools (like rc.exe & mt.exe)
      f"Windows SDK for Windows Store Apps Tools-x86_en-us.msi",
      # Windows SDK headers
      f"Windows SDK for Windows Store Apps Headers-x86_en-us.msi",
      f"Windows SDK Desktop Headers x86-x86_en-us.msi",
      # Windows SDK libs
      f"Windows SDK for Windows Store Apps Libs-x86_en-us.msi",
      f"Windows SDK Desktop Libs {TARGET}-x86_en-us.msi",
      # CRT headers & libs
      f"Universal CRT Headers Libraries and Sources-x86_en-us.msi",
      # CRT redist
      #"Universal CRT Redistributable-x86_en-us.msi",
    ]

    with tempfile.TemporaryDirectory() as d:
      dst = Path(d)

      sdk_pkg = packages[sdk_pid][0]
      sdk_pkg = packages[first(sdk_pkg["dependencies"], lambda x: True).lower()][0]

      msi = []
      cabs = []

      # download msi files
      for pkg in sdk_packages:
        payload = first(sdk_pkg["payloads"], lambda p: p["fileName"] == f"Installers\\{pkg}")
        msi.append(dst / pkg)
        with open(dst / pkg, "wb") as f:
          data = download_progress(payload["url"], payload["sha256"], pkg, f)
          total_download += len(data)
          cabs += list(get_msi_cabs(data))

      # download .cab files
      for pkg in cabs:
        payload = first(sdk_pkg["payloads"], lambda p: p["fileName"] == f"Installers\\{pkg}")
        with open(dst / pkg, "wb") as f:
          download_progress(payload["url"], payload["sha256"], pkg, f)

      print("Unpacking msi files...")

      # run msi installers
      for m in msi:
        subprocess.check_call(["msiexec.exe", "/a", m, "/quiet", "/qn", f"TARGETDIR={OUTPUT.resolve()}"])


### versions

msvcv = ""
sdkv  = ""

if install_msvc:
    msvcv = list((OUTPUT / "VC/Tools/MSVC").glob("*"))[0].name

if install_sdk:
    sdkv = list((OUTPUT / "Windows Kits/10/bin").glob("*"))[0].name

# place debug CRT runtime into MSVC folder (not what real Visual Studio installer does... but is reasonable)

if install_msvc:
    dst = str(OUTPUT / "VC/Tools/MSVC" / msvcv / f"bin/Host{HOST}/{TARGET}")

    pkg = "microsoft.visualcpp.runtimedebug.14"
    dbg = packages[pkg][0]
    payload = first(dbg["payloads"], lambda p: p["fileName"] == "cab1.cab")
    try:
      with tempfile.TemporaryFile(suffix=".cab", delete=False) as f:
        data = download_progress(payload["url"], payload["sha256"], pkg, f)
        total_download += len(data)
      subprocess.check_call(["expand.exe", f.name, "-F:*", dst], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    finally:
      os.unlink(f.name)

# place the folders under the Redist folder in the SDK under a versioned folder to allow other versions to be installed

if install_sdk:
    redist_dir           = OUTPUT / "Windows Kits/10/Redist"
    redist_versioned_dir = redist_dir / f'{sdkv}'

    if not os.path.exists(redist_versioned_dir):
        os.makedirs(redist_versioned_dir)

    for file_name in os.listdir(redist_dir):
        if not file_name.startswith('10.0.'): # Simple heuristic
            shutil.move((redist_dir / file_name), redist_versioned_dir)

### cleanup

shutil.rmtree(OUTPUT / "Common7", ignore_errors=True)
if install_msvc:
    for f in ["Auxiliary", f"lib/{TARGET}/store", f"lib/{TARGET}/uwp"]:
      shutil.rmtree(OUTPUT / "VC/Tools/MSVC" / msvcv / f)
for f in OUTPUT.glob("*.msi"):
  f.unlink()
if install_sdk:
    for f in ["Catalogs", "DesignTime", f"bin/{sdkv}/chpe", f"Lib/{sdkv}/ucrt_enclave"]:
      shutil.rmtree(OUTPUT / "Windows Kits/10" / f, ignore_errors=True)
for arch in ["x86", "x64", "arm", "arm64"]:
  if arch != TARGET:
    if install_msvc:
        shutil.rmtree(OUTPUT / "VC/Tools/MSVC" / msvcv / f"bin/Host{arch}", ignore_errors=True)
    if install_sdk:
        shutil.rmtree(OUTPUT / "Windows Kits/10/bin" / sdkv / arch)
        shutil.rmtree(OUTPUT / "Windows Kits/10/Lib" / sdkv / "ucrt" / arch)
        shutil.rmtree(OUTPUT / "Windows Kits/10/Lib" / sdkv / "um" / arch)


### setup.bat

if install_msvc and install_sdk:
    SETUP = f"""@echo off

set MSVC_VERSION={msvcv}
set MSVC_HOST=Host{HOST}
set MSVC_ARCH={TARGET}
set SDK_VERSION={sdkv}
set SDK_ARCH={TARGET}

set MSVC_ROOT=%~dp0VC\\Tools\\MSVC\\%MSVC_VERSION%
set SDK_INCLUDE=%~dp0Windows Kits\\10\\Include\\%SDK_VERSION%
set SDK_LIBS=%~dp0Windows Kits\\10\\Lib\\%SDK_VERSION%

set VCToolsInstallDir=%MSVC_ROOT%\\
set PATH=%MSVC_ROOT%\\bin\\%MSVC_HOST%\\%MSVC_ARCH%;%~dp0Windows Kits\\10\\bin\\%SDK_VERSION%\\%SDK_ARCH%;%~dp0Windows Kits\\10\\bin\\%SDK_VERSION%\\%SDK_ARCH%\\ucrt;%PATH%
set INCLUDE=%MSVC_ROOT%\\include;%SDK_INCLUDE%\\ucrt;%SDK_INCLUDE%\\shared;%SDK_INCLUDE%\\um;%SDK_INCLUDE%\\winrt;%SDK_INCLUDE%\\cppwinrt
set LIB=%MSVC_ROOT%\\lib\\%MSVC_ARCH%;%SDK_LIBS%\\ucrt\\%SDK_ARCH%;%SDK_LIBS%\\um\\%SDK_ARCH%
    """
    (OUTPUT / "setup.bat").write_text(SETUP)

if install_msvc:
    MSVC_SCRIPT = f"""@echo off

set MSVC_VERSION={msvcv}
set MSVC_HOST=Host{HOST}
set MSVC_ARCH={TARGET}
set MSVC_ROOT=%~dp0VC\\Tools\\MSVC\\%MSVC_VERSION%

set VCToolsInstallDir=%MSVC_ROOT%
set PATH=%MSVC_ROOT%\\bin\\%MSVC_HOST%\\%MSVC_ARCH%;%PATH%
set INCLUDE=%MSVC_ROOT%\\include;%INCLUDE%
set LIB=%MSVC_ROOT%\\lib\\%MSVC_ARCH%;%LIB%
"""
    (OUTPUT / f"msvc-{msvcv}.bat").write_text(MSVC_SCRIPT)
    (OUTPUT / f"msvc-{args.msvc_version}.bat").write_text(MSVC_SCRIPT)

if install_sdk:
    WIN10_SDK_SCRIPT = f"""@echo off

set SDK_VERSION={sdkv}
set SDK_ARCH={TARGET}
set SDK_INCLUDE=%~dp0Windows Kits\\10\\Include\\%SDK_VERSION%
set SDK_LIBS=%~dp0Windows Kits\\10\\Lib\\%SDK_VERSION%

set PATH=%~dp0Windows Kits\\10\\bin\\%SDK_VERSION%\\%SDK_ARCH%;%~dp0Windows Kits\\10\\bin\\%SDK_VERSION%\\%SDK_ARCH%\\ucrt;%PATH%
set INCLUDE=%SDK_INCLUDE%\\ucrt;%SDK_INCLUDE%\\shared;%SDK_INCLUDE%\\um;%SDK_INCLUDE%\\winrt;%SDK_INCLUDE%\\cppwinrt;%INCLUDE%
set LIB=%SDK_LIBS%\\ucrt\\%SDK_ARCH%;%SDK_LIBS%\\um\\%SDK_ARCH%;%LIB%
"""
    (OUTPUT / f"win-sdk-{sdkv}.bat").write_text(WIN10_SDK_SCRIPT)
    (OUTPUT / f"win-sdk-{args.sdk_version}.bat").write_text(WIN10_SDK_SCRIPT)

print(f"Total downloaded: {total_download>>20} MB")
print("Done!")
