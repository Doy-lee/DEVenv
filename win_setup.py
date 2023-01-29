import devenver
import pprint
import subprocess
import sys
import pathlib
import os
import shutil
import tempfile
import devenver_manifest
import urllib.request

def git_clone(install_dir, git_exe, url, commit_hash):
    devenver.lprint(f"Git clone {url} to {install_dir}", level=0)
    # Clone repository if it does not exist
    if not os.path.exists(install_dir):
        devenver.lprint(f"Cloning to {install_dir}")
        subprocess.run(f"{git_exe} clone {url} {install_dir}")

    # Determine current git hash
    result = subprocess.run(f"{git_exe} rev-parse --short HEAD",
                            cwd=install_dir,
                            capture_output=True)
    curr_commit_hash = result.stdout.decode("utf-8").strip()

    # Checkout correct target of Odin
    if not curr_commit_hash.startswith(commit_hash):
        subprocess.run(f"{git_exe} checkout master", cwd=install_dir)
        subprocess.run(f"{git_exe} pull origin master", cwd=install_dir)
        subprocess.run(f"{git_exe} checkout {commit_hash}", cwd=install_dir)

# Run DEVenver, installing the portable apps
# ------------------------------------------------------------------------------
user_app_list  = devenver_manifest.get_manifest()
installed_apps = devenver.run(user_app_list)

# Install MSVC
# ------------------------------------------------------------------------------
devenver.print_header("Install MSVC & Windows 10 SDK")
msvc_script       = pathlib.Path(devenver.script_dir, "win_portable_msvc.py")
msvc_version      = "14.34"
win10_sdk_version = "22621"

msvc_install_dir = devenver.base_install_dir / "msvc"

# Basic heuristic to see if we"ve already installed the MSVC/SDK version
msvc_installed      = False
win10_sdk_installed = False

msvc_find_test_dir      = msvc_install_dir / "VC/Tools/MSVC"
win10_sdk_find_test_dir = msvc_install_dir / "Windows Kits/10"

if os.path.exists(msvc_find_test_dir):
    for file_name in os.listdir(msvc_find_test_dir):
        msvc_installed = file_name.startswith(msvc_version)
        if msvc_installed == True:
            devenver.lprint(f"MSVC {msvc_version} install detected (skip download) in {msvc_find_test_dir}\\{file_name}")
            break
if not msvc_installed:
    devenver.lprint(f"MSVC {msvc_version} install not detected (need to download) in {msvc_find_test_dir}")

if os.path.exists(win10_sdk_find_test_dir):
    for file_name in os.listdir(win10_sdk_find_test_dir / "bin"):
        # Check if directory contains version substring, 22621, e.g. "10.0.22621.0"
        win10_sdk_installed = file_name.count(win10_sdk_version) > 0
        if win10_sdk_installed == True:
            install_locations = f"{win10_sdk_find_test_dir}\\*\\{file_name}"
            devenver.lprint(f"Windows 10 SDK {win10_sdk_version} install detected (skip download) in {install_locations}")
            break
if not win10_sdk_installed:
    devenver.lprint(f"Windows 10 SDK {win10_sdk_version} not detected (need to download) in {win10_sdk_find_test_dir}")

# Install MSVC
if msvc_installed == False or win10_sdk_installed == False:
    with tempfile.TemporaryDirectory() as temp_dir:

        # Invoke the MSVC script to download MSVC to disk
        command = f"'{sys.executable}' '{msvc_script}' --accept-license"
        line    = "Invoking MSVC script to install"
        if msvc_installed:
            command += " --no-msvc"
        else:
            command += f" --msvc-version {msvc_version}"
            line    += f" MSVC {msvc_version}"

        if win10_sdk_installed:
            command += " --no-sdk"
        else:
            command += f" --sdk-version {win10_sdk_version}"
            line    += f" Windows 10 SDK {win10_sdk_version}"

        devenver.lprint(line)
        devenver.lprint(f"Command: {command}")
        subprocess.run(command, cwd=temp_dir)

        # Merge the download MSVC installation to our unified install dir
        temp_msvc_dir = pathlib.Path(temp_dir, "msvc")
        for src_dir, dirs, files in os.walk(temp_msvc_dir):
            install_dir = src_dir.replace(str(temp_msvc_dir), str(msvc_install_dir), 1)
            if not os.path.exists(install_dir):
                os.makedirs(install_dir)
            for file_ in files:
                src  = os.path.join(src_dir, file_)
                dest = os.path.join(install_dir, file_)
                if os.path.exists(dest):
                    if os.path.samefile(src, dest):
                        continue
                    os.remove(dest)
                shutil.move(src, install_dir)

        devenver.lprint(f"MSVC {msvc_version} Windows 10 SDK {win10_sdk_version} installed: {msvc_install_dir}")

# Install apps dependent on Git
# ------------------------------------------------------------------------------
devenver.print_header("Install apps that rely on Git")
git_exe = installed_apps["Git"][0]['exe_path']

# Clink
# ------------------------------------------------------------------------------
clink_install_dir = installed_apps["clink"][0]['install_dir']
clink_base_dir    = clink_install_dir.parent

# Gizmos
clink_gizmo_git_hash   = "fb2edd9"
clink_gizmo_install_dir = clink_base_dir / "clink-gizmos"
git_clone(install_dir=clink_gizmo_install_dir,
          git_exe=git_exe,
          url="https://github.com/chrisant996/clink-gizmos",
          commit_hash=clink_gizmo_git_hash)

# Completions
clink_completions_git_hash   = "86b6f07"
clink_completions_install_dir = clink_base_dir / "clink-completions"
git_clone(install_dir=clink_completions_install_dir,
          git_exe=git_exe,
          url="https://github.com/vladimir-kotikov/clink-completions",
          commit_hash=clink_completions_git_hash)

# Odin
# ------------------------------------------------------------------------------
odin_git_hash    = "9ae1bfb6"
odin_install_dir = pathlib.Path(devenver.base_install_dir, "Odin")
git_clone(install_dir=odin_install_dir,
          git_exe=git_exe,
          url="https://github.com/odin-lang/odin.git",
          commit_hash=odin_git_hash)

# TODO: We can't do this yet because the odin build requires a registry hack so
# that it knows where to find MSVC.

# Build Odin
# subprocess.run(f"{git_exe} checkout {odin_git_hash}",
#                cwd=odin_install_dir)

# Install left-overs
# ------------------------------------------------------------------------------
devenver.print_header("Install configuration files")

# Copy init.vim to NVIM directory
internal_dir          = pathlib.Path(os.path.dirname(os.path.abspath(__file__)), "Internal")
nvim_init_dir         = pathlib.Path(os.path.expanduser("~"), "AppData", "Local", "nvim")
nvim_config_dest_path = nvim_init_dir / "init.vim"
nvim_config_src_path  = internal_dir  / "os_nvim_init.vim"

devenver.lprint(f"Installing NVIM config to {nvim_config_dest_path}")
nvim_init_dir.mkdir(parents=True, exist_ok=True)
shutil.copy(nvim_config_src_path, nvim_config_dest_path)

# Download vim.plug to NVIM init directory
nvim_plug_vim_dir  = nvim_init_dir / "autoload"
nvim_plug_vim_path = nvim_plug_vim_dir / "plug.vim"
nvim_plug_vim_dir.mkdir(parents=True, exist_ok=True)
if not os.path.exists(nvim_plug_vim_path):
    devenver.lprint(f"Installing NVIM plugin manager to {nvim_plug_vim_path}")
    urllib.request.urlretrieve("https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim",
                               nvim_plug_vim_path)

# Install clink configuration
# ------------------------------------------------------------------------------
clink_profile_dir                         = clink_base_dir / "profile"

clink_settings_path = clink_profile_dir / "clink_settings"
clink_settings = f"""
# When this file is named "default_settings" and is in the binaries
# directory or profile directory, it provides enhanced default settings.

# Override built-in default settings with ones that provide a more
# enhanced Clink experience.

autosuggest.enable                = True
clink.default_bindings            = windows
cmd.ctrld_exits                   = False
color.arginfo                     = sgr 38;5;172
color.argmatcher                  = sgr 1;38;5;40
color.cmd                         = sgr 1;38;5;231
color.cmdredir                    = sgr 38;5;172
color.cmdsep                      = sgr 38;5;214
color.comment_row                 = sgr 38;5;87;48;5;18
color.description                 = sgr 38;5;39
color.doskey                      = sgr 1;38;5;75
color.executable                  = sgr 1;38;5;33
color.filtered                    = sgr 38;5;231
color.flag                        = sgr 38;5;117
color.hidden                      = sgr 38;5;160
color.histexpand                  = sgr 97;48;5;55
color.horizscroll                 = sgr 38;5;16;48;5;30
color.input                       = sgr 38;5;222
color.readonly                    = sgr 38;5;28
color.selected_completion         = sgr 38;5;16;48;5;254
color.selection                   = sgr 38;5;16;48;5;179
color.suggestion                  = sgr 38;5;239
color.unrecognized                = sgr 38;5;203
history.max_lines                 = 25000
history.time_stamp                = show
match.expand_envvars              = True
match.substring                   = True

clink.path                        = {clink_completions_install_dir};{clink_gizmo_install_dir}
fzf.default_bindings              = True
"""

devenver.lprint("Installing clink_settings to: {clink_settings_path}")
with open(clink_settings_path, "w+") as file:
    file.write(clink_settings)

# Install wezterm configuration
# ------------------------------------------------------------------------------
wezterm_install_dir      = installed_apps["WezTerm"][0]["install_dir"]
wezterm_exe_path         = installed_apps["WezTerm"][0]["exe_path"]
wezterm_config_dest_path = wezterm_install_dir / "wezterm.lua"

devenver.lprint(f"Installing WezTerm config to {wezterm_config_dest_path}")

clink_exe_path             = clink_install_dir.relative_to(devenver.base_install_dir) / "clink_x64.exe"
clink_exe_path_for_wezterm = str(clink_exe_path).replace("\\", "\\\\")
clink_profile_path_for_wezterm = str(clink_profile_dir.relative_to(devenver.base_install_dir)).replace("\\", "\\\\")

wezterm_lua_buffer = f"""local wezterm = require 'wezterm';

local default_prog
local set_environment_variables = {{}}

if wezterm.target_triple == "x86_64-pc-windows-msvc" then

  clink_exe     = string.format("%s\\\\..\\\\..\\\\{clink_exe_path_for_wezterm}", wezterm.executable_dir)
  devenv_bat    = string.format("%s\\\\..\\\\..\\\\devenv.bat", wezterm.executable_dir)
  msvc_bat      = string.format("%s\\\\..\\\\..\\\\msvc\\\\setup.bat", wezterm.executable_dir)
  clink_profile = string.format("%s\\\\..\\\\..\\\\{clink_profile_path_for_wezterm}", wezterm.executable_dir)

  -- Taken from: https://wezfurlong.org/wezterm/shell-integration.html
  -- Use OSC 7 as per the above example
  set_environment_variables['prompt'] =
    '$E]7;file://localhost/$P$E\\\\$E[32m$T$E[0m $E[35m$P$E[36m$_$G$E[0m '

  default_prog = {{"cmd.exe", "/s", "/k",
                  clink_exe, "inject", "--profile", clink_profile, "-q",
                  "&&", "call", devenv_bat,
                  "&&", "call", msvc_bat}}
end

return {{
  font_size = 10.0,
  color_scheme = "Peppermint",
  default_prog = default_prog,
  set_environment_variables = set_environment_variables,
}}
"""

with open(wezterm_config_dest_path, "w") as file:
    file.write(wezterm_lua_buffer)

# Wezterm super terminal
wezterm_exe_rel_path         = pathlib.Path(wezterm_exe_path).relative_to(devenver.base_install_dir)
wezterm_terminal_script_path = pathlib.Path(devenver.base_install_dir, "win_terminal.bat")
wezterm_terminal_script      = f"""@echo off
setlocal EnableDelayedExpansion

set working_dir=
if "%~1" neq "" (
    set working_dir=start --cwd "%~1"
    set working_dir=!working_dir:\=/!
)

if exist "%~dp0win_terminal_user_config.bat" call "%~dp0win_terminal_user_config.bat"
start "" /MAX "%~dp0{wezterm_exe_rel_path}" !working_dir!
"""

devenver.lprint(f"Installing WezTerm terminal script to {wezterm_terminal_script_path}")
with open(wezterm_terminal_script_path, "w") as file:
    file.write(wezterm_terminal_script)

# Create Odin work-around scripts
# ------------------------------------------------------------------------------
# Odin uses J. Blow's Microsoft craziness SDK locator which relies on the
# registry. Here we inject the registry entry that the SDK locator checks for
# finding our portable MSVC installation.
win10_sdk_find_test_dir_reg_path = str(win10_sdk_find_test_dir).replace("\\", "\\\\")
odin_msvc_install_script = f"""Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows Kits\Installed Roots]
"KitsRoot10"="{win10_sdk_find_test_dir_reg_path}"
"""

odin_msvc_uninstall_script = f"""Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows Kits\Installed Roots]
"KitsRoot10"=-
"""

odin_msvc_install_script_path   = devenver.base_install_dir / "odin_msvc_install_workaround.reg"
odin_msvc_uninstall_script_path = devenver.base_install_dir / "odin_msvc_uninstall_workaround.reg"

devenver.lprint(f"Installing Odin MSVC workaround scripts", level=0)
devenver.lprint(f" - {odin_msvc_install_script_path}", level=1)
devenver.lprint(f" - {odin_msvc_uninstall_script_path}", level=1)

with open(odin_msvc_install_script_path, "w") as file:
    file.write(odin_msvc_install_script)

with open(odin_msvc_uninstall_script_path, "w") as file:
    file.write(odin_msvc_uninstall_script)

# Add python-update bootstrap script
# ------------------------------------------------------------------------------
# TODO: If I'm using the terminal that this script generates it will lock the
# executable and Python cannot open the file for verifying the SHA256.

python_exe            = pathlib.Path(installed_apps["Python"][0]['exe_path']).relative_to(devenver.base_install_dir)
python_install_dir    = pathlib.Path(installed_apps["Python"][0]['exe_path']).parent.relative_to(devenver.base_install_dir)
win_setup_script_path = pathlib.Path(devenver.script_dir, "win_setup.py")
manifest_script_path  = pathlib.Path(devenver.script_dir, "devenver_manifest.py")

bootstrap_setup_script = f"""@echo off
setlocal EnableDelayedExpansion
set PYTHONHOME=%~dp0{python_install_dir}
%~dp0{python_exe} {win_setup_script_path} --manifest-file {manifest_script_path}
pause
"""

with open(devenver.base_install_dir / "upgrade_bootstrap.bat", "w") as file:
    file.write(bootstrap_setup_script)
