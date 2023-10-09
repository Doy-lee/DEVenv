#!/usr/bin/env python3

# DEVenver
# ------------------------------------------------------------------------------
# A simple python script to download portable applications and install them by
# unzipping them to a structured directory tree.

import urllib.request
import urllib.parse
import pathlib
import os
import tempfile
import hashlib
import shutil
import subprocess
import pprint
import argparse
import json
import importlib

from string import Template
from enum import Enum

# Internal
# ------------------------------------------------------------------------------
DOWNLOAD_CHUNK_SIZE = 1 * 1024 * 1024 # 1 megabyte

# ------------------------------------------------------------------------------

# These variables are set once they are downloaded dynamically and installed
# from the internal app listing!
zstd_exe           = ""
zip7_exe           = ""
zip7_bootstrap_exe = ""

# Functions
# ------------------------------------------------------------------------------
def print_header(title):
    line = f'> ' + title + ' ';
    print(line.ljust(100, '-'))

def lprint(*args, level=0, **kwargs):
    print(' ' + (' ' * 2 * level), *args, **kwargs)

def lexit(*args, level=0, **kwargs):
    print(' ' + (' ' * 2 * level), *args, **kwargs)
    exit()

def verify_file_sha256(file_path, checksum, label):
    if os.path.isfile(file_path) == False:
        exit(f'Cannot verify SHA256, path is not a file [path={file_path}]')

    result = False
    try:
        file = open(file_path, 'r+b')
        hasher = hashlib.sha256()
        hasher.update(file.read())
        derived_checksum = hasher.hexdigest()
        result = derived_checksum == checksum
        if result:
            lprint(f'- {label} SHA256 is good: {checksum}', level=1)
        else:
            lprint(f'- {label} SHA256 mismatch', level=1)
            lprint(f'  Expect: {checksum}', level=1)
            lprint(f'  Actual: {derived_checksum}', level=1)
    except PermissionError as exception:
        lprint(f"- {label} cannot verify SHA256 due to permission error, skipping", level=1)
        result = True
    else:
        file.close()

    return result

def download_file_at_url(url, download_path, download_checksum, label):
    # Check if file already downloaded and hashes match
    # --------------------------------------------------------------------------
    file_already_downloaded = False
    if os.path.isfile(download_path):
        lprint(f'- Cached archive found: {download_path}', level=1)
        file_already_downloaded = verify_file_sha256(download_path, download_checksum, 'Cached archive')
    else:
        lprint(f'- Download to disk: {download_path}', level=1)
        lprint(f'  URL: {url}', level=1)

    # Download the file from URL
    # --------------------------------------------------------------------------
    if file_already_downloaded == False:
        lprint('Initiating download request ...', level=2)
        with urllib.request.urlopen(url) as response:
            temp_file        = tempfile.mkstemp(text=False)
            temp_file_handle = temp_file[0]
            temp_file_path   = temp_file[1]
            temp_file_io     = os.fdopen(temp_file_handle, mode='w+b')

            download_failed = False
            try:
                line = ''
                total_download_size = int(response.getheader('Content-Length'))
                bytes_downloaded    = 0
                while chunk := response.read(DOWNLOAD_CHUNK_SIZE):
                    bytes_written      = temp_file_io.write(chunk)
                    bytes_downloaded  += bytes_written
                    percent_downloaded = int(bytes_downloaded / total_download_size * 100)

                    lprint(' ' * len(line), end='\r', level=2)
                    line = f'Downloading {percent_downloaded:.2f}% ({bytes_downloaded}/{total_download_size})'
                    lprint(line, end='\r', level=2)
            except Exception as exception:
                download_failed = True
                lprint(f'Download {label} from {url} failed, {exception}', level=2)
            finally:
                temp_file_io.close()
                print()

            if download_failed == True:
                os.remove(temp_file_path)
                exit()

            # If file already exists then we have a hash mismatch, delete it
            # then rename the new item ontop of it
            if os.path.isfile(download_path):
                os.unlink(download_path)

            shutil.move(temp_file_path, download_path)

    if file_already_downloaded == False:
        if verify_file_sha256(download_path, download_checksum, 'Downloaded archive') == False:
            exit()

class UnzipMethod(Enum):
    SHUTILS = 0
    ZIP7_BOOTSTRAP = 1
    DEFAULT = 2
    ZIP7 = 3
    NO_UNZIP = 4

def get_exe_install_dir(install_dir, label, version_label):
    result = pathlib.Path(install_dir, label.replace(' ', '_'), version_label)
    return result

def get_exe_install_path(install_dir, label, version_label, exe_rel_path):
    install_dir = get_exe_install_dir(install_dir, label, version_label)
    result      = pathlib.Path(install_dir, exe_rel_path)
    return result

def get_exe_symlink_dir(install_dir):
    result = pathlib.Path(install_dir, "Symlinks")
    return result

def download_and_install_archive(download_url,
                                 download_checksum,
                                 exe_list,
                                 version_label,
                                 label,
                                 unzip_method,
                                 download_dir,
                                 install_dir,
                                 is_windows):

    exe_install_dir  = get_exe_install_dir(install_dir=install_dir,
                                           label=label,
                                           version_label=version_label)

    # Evaluate if we have already installed the requested archive
    # --------------------------------------------------------------------------
    exes_are_not_a_file = []
    exes_missing = []
    exes_present = []
    for exe_dict in exe_list:
        exe_path = get_exe_install_path(install_dir=install_dir,
                                        label=label,
                                        version_label=version_label,
                                        exe_rel_path=exe_dict['path'])

        if os.path.exists(exe_path) == True:
            if os.path.isfile(exe_path) == True:
                exes_present.append(exe_dict)
            else:
                exes_are_not_a_file.append(exe_dict)
        else:
            exes_missing.append(exe_dict)

    # Executables not install yet, verify, download and install if possible
    # --------------------------------------------------------------------------
    if len(exes_present) != len(exe_list):

        # Check if any of the manifest files are not files
        # ----------------------------------------------------------------------
        if len(exes_are_not_a_file) > 0: # Some item exists at the path but they are not files
            lprint(f'- {label} is installed but some of the expected executables are not a file!', level=1)
            for exe_dict in exes_are_not_a_file:
                lprint(f'    {exe_dict["path"]}', level=1)
            lprint(f'    Installation cannot proceed as unpacking would overwrite these paths', level=1)
            exit()

        # Check if any files are missing
        # ----------------------------------------------------------------------
        # Some executables are missing, some are available, installation will
        # trample over existing files, its not safe to unzip the archive as we may
        # overwrite config files or some other files that have been modified by the
        # program.
        #
        # Note that all files missing means we can assume that we haven't installed
        # yet ..
        if len(exes_missing) > 0 and len(exes_missing) != len(exe_list):
            lprint(f'- {label} is installed but some of the expected executables are missing from the installation!', level=1)
            for exe_dict in exes_are_not_a_file:
                lprint(f'    {exe_dict["path"]}', level=1)
            exit()

        assert(len(exes_missing) == len(exe_list))
        assert(len(exes_present) == 0)

        # Not installed yet, download and install
        # ----------------------------------------------------------------------
        # Determine the file name we are downloading from the URL
        download_url_parts = urllib.parse.urlparse(download_url)
        download_name      = pathlib.Path(urllib.parse.unquote(download_url_parts.path))

        # The path to move the temp file to after successful download, e.g.
        # download_dir  = C:/Dev/Downloads/Wezterm-windows-{version}.zip
        # download_name = Wezterm-windows-{version}.zip
        download_path = pathlib.Path(download_dir, download_name.name)

        # Download the archive at the URL
        download_file_at_url(download_url, download_path, download_checksum, label)

        # Install the archive by unpacking it
        # ----------------------------------------------------------------------
        archive_path = download_path
        os.makedirs(exe_install_dir, exist_ok=True)

        if unzip_method == UnzipMethod.DEFAULT:
            if archive_path.suffix == '.exe' or archive_path.suffix.lower() == '.appimage' or len(archive_path.suffix) == 0:
                unzip_method = UnzipMethod.NO_UNZIP

        if unzip_method == UnzipMethod.NO_UNZIP:
            shutil.copy(archive_path, exe_install_dir)
        elif unzip_method == UnzipMethod.SHUTILS:
            lprint(f'- SHUtils unzip install {label} to: {exe_install_dir}', level=1)
            shutil.unpack_archive(download_path, exe_install_dir)
        elif unzip_method == UnzipMethod.ZIP7_BOOTSTRAP:
            command = [str(zip7_bootstrap_exe), "x", "-bd", str(download_path), f"-o{exe_install_dir}"]
            lprint(f'- 7z (bootstrap) unzip {label} to: {exe_install_dir}', level=1)
            lprint(f'  Command: {command}', level=1)
            subprocess.run(command)
        else: # Default or 7ZIP
            intermediate_zip_file_extracted = False

            # We could have a "app.zst" situation or an "app.tar.zst" situation
            #
            # "app.zst" only needs 1 extraction from the zstd tool
            # "app.tar.zst" needs 1 zstd extract and then 1 7zip extract
            #
            # When we have "app.tar.zst" we extract to the install folder, e.g.
            #
            # "app/1.0/app.tar"
            #
            # We call this an intermediate zip file, we will extract that file
            # with 7zip. After we're done, we will delete that _intermediate_
            # file to cleanup our install directory.
            unzip_command = [str(zip7_exe), "x", "-aoa", "-spe", "-bso0", str(archive_path), f"-o{exe_install_dir}"]

            linux_used_tar = False
            if archive_path.suffix == '.zst' or archive_path.suffix == '.xz' or archive_path.suffix == '.gz' or archive_path.suffix == '.bz2':
                archive_without_suffix = pathlib.Path(str(archive_path)[:-len(archive_path.suffix)]).name
                next_archive_path      = pathlib.Path(exe_install_dir, archive_without_suffix)

                if os.path.exists(next_archive_path) == False:
                    command = ""
                    if archive_path.suffix == '.zst':
                        command = [str(zstd_exe), "--output-dir-flat", str(exe_install_dir), "-d", str(archive_path)]
                        lprint(f'- zstd unzip {label} to: {exe_install_dir}', level=1)
                    else:
                        if not is_windows:
                            linux_used_tar = True
                            unzip_command  = ["tar", "xf", str(archive_path), "--directory", str(exe_install_dir)]

                        command = unzip_command
                        for item in command:
                            item = item.replace('\\', '/')
                        lprint(f'- Unzip nested install {label} to: {exe_install_dir}', level=1)

                    lprint(f'  Command: {command}', level=1)
                    subprocess.run(args=command)

                # Remove the extension from the file, we just extracted it
                archive_path = next_archive_path

                # If there's still a suffix after we removed the ".zst" we got
                # an additional archive to unzip, e.g. "app.tar" remaining.
                if not linux_used_tar:
                    intermediate_zip_file_extracted = len(archive_path.suffix) > 0

            # \note On Linux using tar xf will unpack the archive entirely, e.g.
            # unpack tar.gz both in one shot. So we do not need a further
            # extract step.
            if not linux_used_tar and len(archive_path.suffix) > 0:
                unzip_command = [str(zip7_exe), "x", "-aoa", "-spe", "-bso0", str(archive_path), f"-o{exe_install_dir}"]
                command = unzip_command
                for item in command:
                    item = item.replace('\\', '/')

                lprint(f'- Unzip install {label} to: {exe_install_dir}', level=1)
                lprint(f'  Command: {command}', level=1)
                subprocess.run(command)

            if intermediate_zip_file_extracted:
                lprint(f'- Detected intermediate zip file in install root, removing: {archive_path}', level=1)
                os.remove(archive_path)

        # Remove duplicate root folder if detected
        # ----------------------------------------------------------------------
        # If after unpacking, there's only 1 directory in the install direction, we
        # assume that the zip contains a root folder. We will automatically merge
        # the root folder to the parent.
        has_files_in_install_dir = False
        dir_count                = 0
        dupe_root_folder_name    = ''
        with os.scandir(exe_install_dir) as scan_handle:
            for it in list(scan_handle):
                if it.is_file():
                    has_files_in_install_dir = True
                    break
                elif it.is_dir():
                    dupe_root_folder_name = it.name
                    dir_count            += 1
                if dir_count > 1:
                    break

        if dir_count == 1 and not has_files_in_install_dir:
            # There is only one folder after we unzipped, what happened here is
            # that the archive we unzipped had its contents within a root
            # folder. We will pull those files out because we already unzipped
            # into an isolated location for the application, e.g.
            #
            # Our install location C:/Dev/Install/7zip/920
            # After unzip C:/Dev/Install/7zip/920/7zip-920-x64
            #
            # We have an duplicate '7zip-920-x64' directory in our
            # installation. Move all the files in the duplicate directory up to
            # our '920' folder then remove the duplicate folder.
            dupe_root_folder_path = pathlib.Path(exe_install_dir, dupe_root_folder_name)
            lprint(f'- Detected duplicate root folder after unzip: {dupe_root_folder_path}', level=1)
            lprint(f'  Merging duplicate root folder to parent:    {exe_install_dir}', level=1)
            for file_name in os.listdir(dupe_root_folder_path):
                src = pathlib.Path(dupe_root_folder_path, file_name)
                dest = pathlib.Path(exe_install_dir, file_name)
                shutil.move(src, dest)

            os.rmdir(dupe_root_folder_path)

    # Verify the installation by checking the SHA256 of the executables
    # --------------------------------------------------------------------------
    exes_with_bad_hashes = []
    for exe_dict in exe_list:
        exe_rel_path = exe_dict['path']
        exe_path = get_exe_install_path(install_dir=install_dir,
                                        label=label,
                                        version_label=version_label,
                                        exe_rel_path=exe_rel_path)
        if os.path.isfile(exe_path) == False:
            lexit(f'- Installed {label} but could not find expected file for validating install: {exe_path}', level=1)

        if verify_file_sha256(file_path=exe_path, checksum=exe_dict['checksum'], label=exe_rel_path) == False:
            exes_with_bad_hashes.append(exe_dict)

    if len(exes_with_bad_hashes) > 0:
        lprint(f'- {label} is installed but executable SHA256 does not match!', level=1)
        lprint(f'  See hashes above, executable path(s):', level=1)
        for exe_dict in exes_with_bad_hashes:
            lprint(f'    {exe_dict["path"]}', level=1)
        lprint(f'  Something has modified the executable, this may be malicious or not!', level=1)
        lprint(f'  Manually uninstall the existing installation or amend the binary to be', level=1)
        lprint(f'  able to continue. Exiting.', level=1)
        exit()
    else:
        lprint(f'- {label} installed and valid: {exe_install_dir}', level=1)

    # Do the symlinks
    # --------------------------------------------------------------------------
    symlink_dir                   = get_exe_symlink_dir(install_dir)
    paths_to_add_to_devenv_script = set()
    for exe_dict in exe_list:
        exe_rel_path = exe_dict['path']
        exe_path = get_exe_install_path(install_dir=install_dir,
                                        label=label,
                                        version_label=version_label,
                                        exe_rel_path=exe_rel_path)
        # Make them executable
        # ----------------------------------------------------------------------
        if not is_windows:
            subprocess.run(args=["chmod", "+x", exe_path])

        # If you install the Linux manifest on Windows then we ensure we
        # still call link (e.g. hardlink) because symlinks need special
        # Windows 10 permissions to be set...
        #
        # It's weird that we install Linux manifest on Windows, yes, but
        # I use it for testing without having to boot up a whole nother
        # OS.
        use_hardlink = is_windows or os.name == 'nt'
        for symlink_entry in exe_dict["symlink"]:
            symlink_dest = symlink_dir / symlink_entry
            symlink_src = exe_path
            skip_link = False;
            if os.path.exists(symlink_dest):
                # Windows uses hardlinks because symlinks require you to enable "developer" mode
                # Everyone else uses symlinks
                if (use_hardlink and not os.path.isfile(symlink_dest)) or (not use_hardlink and not os.path.islink(symlink_dest)):
                    lprint( "- Cannot create symlink! The destination file to create the symlink at.", level=1)
                    lprint( "  already exists and is *not* a link. We cannot remove this safely as we", level=1)
                    lprint( "  don't know what it is, exiting.", level=1)
                    lprint(f"  Symlink Source: {symlink_src}", level=1)
                    lexit (f"  Symlink Dest: {symlink_dest}", level=1)

                if os.path.samefile(symlink_dest, symlink_src):
                    skip_link = True
                else:
                    os.unlink(symlink_dest)

            if not skip_link:
                if use_hardlink:
                    os.link(src=symlink_src, dst=symlink_dest)
                else:
                    os.symlink(src=symlink_src, dst=symlink_dest)

        # Collect paths to add to the devenv script
        # ----------------------------------------------------------------------
        if exe_dict['add_to_devenv_path'] == True:
            path = exe_path.parent.relative_to(install_dir)
            paths_to_add_to_devenv_script.add(path)

    global devenv_script_buffer
    for path in paths_to_add_to_devenv_script:
        if is_windows:
            devenv_script_buffer += f"set PATH=%~dp0{path};%PATH%\n"
        else:
            devenv_script_buffer += f"PATH=\"$( cd -- $( dirname -- \"${{BASH_SOURCE[0]}}\" ) &> /dev/null && pwd )/{path}\":$PATH\n"

# Search the 2 dictionarries, 'first' and 'second' for the key. A matching key
# in 'first' taking precedence over the 'second' dictionary. If no key is
# found in either dictionaries then this function
# returns an empty string.
class ValidateAppListResult:
    def __init__(self):
        self.app_count = 0

def validate_app_list(app_list):
    result = ValidateAppListResult()
    manifest_rule_table = {
        'download_checksum':         'manifest must specify the SHA256 checksum for the downloaded file',
        'version':                   'manifest must specify the app version that is to be installed',
        'executables':               'manifest must specify an array of executable(s) for verifying installation',
        'download_url':              'manifest must specify the URL to download the app from',
        'add_to_devenv_script':      'manifest must specify an array of strings to inject into the portable development environment setup script',
    }

    executable_rule_table = {
        'path':               'executables must specify a path to a file from the installation to verify its checksum',
        'symlink':            'executables must specify an array of symlink names that will target the path',
        'add_to_devenv_path': 'executables must specify an boolean to indicate if the executable path should be added to the environment path',
        'checksum':           'executables must specify a string with the checksum of the executable',
    }

    for app in app_list:
        manifest_list = app['manifests']
        result.app_count += len(manifest_list)

        # Verify the label
        # ----------------------------------------------------------------------
        label = app.get('label', '')
        if 'label' not in app:
            exit('Label missing from application list, app must have a label specified, e.g. { "label": "App Name", "manifests": [] }')

        # Verify that the mandatory keys are in the manifest
        # ----------------------------------------------------------------------
        for manifest in manifest_list:
            for key in manifest_rule_table:
                value = manifest.get(key, "")

                if key.startswith("add_to_devenv"):
                    if not isinstance(value, list):
                        exit(f'{label} error: {key} in manifest must be an array to proceed\n{pprint.pformat(app)}')

                elif key == "executables":
                    for executable in value:
                        for executable_key in executable_rule_table:
                            executable_value = executable.get(executable_key, "")

                            if executable_key == "path":
                                if not isinstance(executable_value, str) or len(executable_value) == 0:
                                    exit(f'{label} error: required key "{executable_key}" is invalid, {executable_rule_table[executable_key]}\n{pprint.pformat(app)}')

                            elif executable_key == "symlink":
                                if not isinstance(executable_value, list):
                                    exit(f'{label} error: required key "{executable_key}" is invalid, {executable_rule_table[executable_key]}\n{pprint.pformat(app)}')

                            elif executable_key == "add_to_devenv_path":
                                if not isinstance(executable_value, bool):
                                    exit(f'{label} error: required key "{executable_key}" is invalid, {executable_rule_table[executable_key]}\n{pprint.pformat(app)}')

                            elif executable_key == "checksum":
                                if not isinstance(executable_value, str):
                                    exit(f'{label} error: required key "{executable_key}" is invalid, {executable_rule_table[executable_key]}\n{pprint.pformat(app)}')

                elif len(value) == 0:
                    exit(f'{label} error: required key "{key}" is missing/empty, {manifest_rule_table[key]}\n{pprint.pformat(app)}')

    return result

internal_app_list = []
devenv_script_buffer = ""

def install_app_list(app_list, download_dir, install_dir, is_windows):
    title = "Internal Apps" if app_list is internal_app_list else "User Apps"
    print_header(title)
    result = {}

    validate_app_list_result = validate_app_list(app_list)
    app_index = 0

    for app in app_list:
        manifest_list = app['manifests']
        for manifest in manifest_list:
            app_index += 1

            # Extract variables from manifest
            # ------------------------------------------------------------------
            label             = app["label"]
            download_checksum = manifest['download_checksum']
            version           = manifest["version"]
            download_url      = manifest["download_url"]
            exe_list          = manifest['executables']

            unzip_method        = UnzipMethod.DEFAULT
            unzip_method_string = manifest.get("unzip_method", "").lower()
            if unzip_method_string == 'shutils':
                unzip_method    = UnzipMethod.SHUTILS
            elif unzip_method_string == '7zip bootstrap':
                unzip_method    = UnzipMethod.ZIP7_BOOTSTRAP
            elif unzip_method_string == 'default':
                unzip_method    = UnzipMethod.DEFAULT
            elif unzip_method_string == '7zip':
                unzip_method    = UnzipMethod.ZIP7
            elif unzip_method_string == 'no unzip':
                unzip_method    = UnzipMethod.NO_UNZIP

            # Bootstrapping code, when installing the internal app list, we will
            # assign the variables to point to our unarchiving tools.
            # ------------------------------------------------------------------
            if app_list is internal_app_list:
                global zip7_exe
                global zip7_bootstrap_exe
                global zstd_exe
                exe_path = get_exe_install_path(install_dir, label, version, manifest['executables'][0]['path'])
                if label == '7zip':
                    if is_windows or os.name == 'nt':
                        if version == '920':
                            unzip_method       = UnzipMethod.SHUTILS
                            zip7_bootstrap_exe = exe_path
                        else:
                            unzip_method = UnzipMethod.ZIP7_BOOTSTRAP
                            zip7_exe     = exe_path
                    else:
                        unzip_method       = UnzipMethod.SHUTILS
                        zip7_exe           = exe_path
                        zip7_bootstrap_exe = exe_path
                elif label == 'zstd':
                    zstd_exe = exe_path

            # Download and install
            # ------------------------------------------------------------------
            lprint(f'[{app_index:03}/{validate_app_list_result.app_count:03}] Setup {label} v{version}', level=0)
            download_and_install_archive(download_url=download_url,
                                         download_checksum=download_checksum,
                                         exe_list=exe_list,
                                         version_label=version,
                                         label=label,
                                         unzip_method=unzip_method,
                                         download_dir=download_dir,
                                         install_dir=install_dir,
                                         is_windows=is_windows)

            # Post-installation
            # ------------------------------------------------------------------

            # Collate results into results
            if label not in result:
                result.update({label: []})

            for item in exe_list:
                app_install_dir = get_exe_install_dir(install_dir, label, version)
                app_exe_path    = get_exe_install_path(install_dir, label, version, item['path'])
                app_exe_dir     = pathlib.Path(app_exe_path).parent

                # Add executable into the result list
                result[label].append({
                    'version':     version,
                    'install_dir': app_install_dir,
                    'exe_path':    app_exe_path,
                })

            # Add the snippets verbatim specified in the manifest
            global devenv_script_buffer
            for line in manifest['add_to_devenv_script']:
                devenv_script_buffer += (line + '\n')

    if (is_windows or os.name == 'nt') and app_list is internal_app_list:
        if len(str(zip7_exe)) == 0 or len(str(zip7_bootstrap_exe)) == 0 or len(str(zstd_exe)) == 0:
            exit("Internal app list did not install 7zip bootstrap, 7zip or zstd, we are unable to install archives\n"
                 f" - zip7_bootstrap_exe: {zip7_bootstrap_exe}\n"
                 f" - zip7_exe: {zip7_exe}\n"
                 f" - zstd_exe: {zstd_exe}\n")

    return result

script_dir                 = pathlib.Path(os.path.dirname(os.path.abspath(__file__)))
default_base_dir           = script_dir
default_base_downloads_dir = default_base_dir / 'Downloads'
default_base_install_dir   = default_base_dir / 'Install'

base_downloads_dir = default_base_downloads_dir
base_install_dir   = default_base_install_dir

def run(user_app_list,
        devenv_script_name,
        is_windows,
        download_dir=base_downloads_dir,
        install_dir=base_install_dir):
    """ Download and install the given user app list at the specified
    directories. The apps given must be archives that can be unpacked for
    installation (e.g. portable distributions).

    Parameters:
        user_app_list (list): A list of dictionaries that contain app and
        manifest information dictating what is to be installed via this
        function.
        download_dir (string): The path that intermediate downloaded files will
        be kept at.
        install_dir (string): The path that installed applications will be
        unpacked to

    Returns:
        result (list): A list of dictionaries containing the install locations
        of each app, e.g.
    """

    base_downloads_dir = download_dir
    base_install_dir = install_dir

    # --------------------------------------------------------------------------
    # This app list must always be installed, they provide the tools to install all
    # other archives. Upon installation, we will collect the installation executable
    # path and store them in global variables for the rest of the progam to use to
    # unzip the files.
    global internal_app_list
    internal_app_list = []

    internal_app_list.append({
        "label": "7zip",
        "manifests": [],
    })

    if is_windows or os.name == "nt":
        version = "920"
        internal_app_list[-1]["manifests"].append({ # Download the bootstrap 7zip, this can be unzipped using shutils
            "download_checksum": "2a3afe19c180f8373fa02ff00254d5394fec0349f5804e0ad2f6067854ff28ac",
            "download_url": f"https://www.7-zip.org/a/7za{version}.zip",
            "version": version,
            "executables": [
                {
                    "path": "7za.exe",
                    "symlink": [],
                    "add_to_devenv_path": False,
                    "checksum": "c136b1467d669a725478a6110ebaaab3cb88a3d389dfa688e06173c066b76fcf"
                }
            ],
            "add_to_devenv_script": [],
        })

    version           = "2301"
    download_url      = ""
    download_checksum = ""
    checksum          = ""
    exe_path          = ""

    if is_windows or os.name == "nt":
        download_url      = f"https://www.7-zip.org/a/7z{version}-x64.exe"
        download_checksum = "26cb6e9f56333682122fafe79dbcdfd51e9f47cc7217dccd29ac6fc33b5598cd"
        checksum          = "8cebb25e240db3b6986fcaed6bc0b900fa09dad763a56fb71273529266c5c525"
        exe_path          = "7z.exe"

    else:
        download_url      = f"https://www.7-zip.org/a/7z{version}-linux-x64.tar.xz"
        download_checksum = "23babcab045b78016e443f862363e4ab63c77d75bc715c0b3463f6134cbcf318"
        checksum          = "c7f8769e2bc8df6bcbfba34571ee0340670a52dec824dbac844dd3b5bd1a69e1"
        exe_path          = "7zz"

    internal_app_list[-1]["manifests"].append({ # Download proper 7zip, extract this exe with the bootstrap 7zip
        "download_checksum": download_checksum,
        "download_url":      download_url,
        "version":           version,
        "executables": [
            {
                "path": exe_path,
                "symlink": [],
                "add_to_devenv_path": True,
                "checksum": checksum,
            }
        ],
        "add_to_devenv_script":  [],
    })

    # ------------------------------------------------------------------------------

    version           = "1.5.2"
    download_url      = ""
    download_checksum = ""
    checksum          = ""
    exe_path          = ""

    if is_windows or os.name == 'nt':
        download_url      = f"https://github.com/facebook/zstd/releases/download/v{version}/zstd-v{version}-win64.zip"
        download_checksum = "68897cd037ee5e44c6d36b4dbbd04f1cc4202f9037415a3251951b953a257a09"
        checksum          = "f14e78c0651851a670f508561d2c5d647da0ba08e6b73231f2e7539812bae311"
        exe_path          = "zstd.exe"

        internal_app_list.append({
            "label": "zstd",
            "manifests": [
                {
                    "download_checksum": download_checksum,
                    "download_url": download_url,
                    "version": version,
                    "executables": [
                        {
                            "path": exe_path,
                            "symlink": [],
                            "add_to_devenv_path": True,
                            "checksum": checksum,
                        },
                    ],
                    "add_to_devenv_script": [],
                },
            ],
        })

    # Run
    # --------------------------------------------------------------------------
    # Create the starting directories and install the internal app list (e.g.
    # 7zip) which will be used to unzip-install the rest of the apps in the user
    # app list.
    #
    # To do this without dependencies, we first download an old version of 7zip,
    # version 9.20 which is distributed as a .zip file which Python can natively
    # unzip.
    #
    # We then use the old version of 7zip and download a newer version of 7zip
    # and extract it using the bootstrap-ed version. As of writing this, 7zip
    # does not release a portable distribution of itself yet, instead what we do
    # is download the installer and extract it ourselves using the bootstrap
    # 7zip.

    # Create the paths requested by the user
    os.makedirs(download_dir, exist_ok=True)
    os.makedirs(install_dir, exist_ok=True)
    os.makedirs(pathlib.Path(install_dir, "Symlinks"), exist_ok=True)

    for path in [download_dir, install_dir]:
        if not os.path.isdir(path):
            exit(f'Path "{path}" is not a directory, script can not proceed. Exiting.')

    global devenv_script_buffer
    if is_windows:
        devenv_script_buffer = """@echo off

"""

    # Validate all the manifests before starting
    internal_app_validate_result = validate_app_list(internal_app_list)
    user_app_validate_result     = validate_app_list(user_app_list)

    # Install apps
    internal_apps = install_app_list(app_list=internal_app_list,
                                     download_dir=download_dir,
                                     install_dir=install_dir,
                                     is_windows=is_windows)

    user_apps     = install_app_list(app_list=user_app_list,
                                     download_dir=download_dir,
                                     install_dir=install_dir,
                                     is_windows=is_windows)

    # Write the devenv script with environment variables
    if is_windows:
        devenv_script_buffer += "set devenver_root_backslash=%~dp0\n"
        devenv_script_buffer += "set devenver_root=%devenver_root_backslash:~0,-1%\n"
        devenv_script_buffer += "set devenver_root_backslash=\n"

        devenv_script_buffer += "set path=%~dp0Symlinks;%PATH%\n"
        devenv_script_buffer += "set path=%~dp0Scripts;%PATH%\n"
    else:
        devenv_script_buffer += f"export devenver_root=\"$( cd -- $( dirname -- \"${{BASH_SOURCE[0]}}\" ) &> /dev/null && pwd )\"\n"
        devenv_script_buffer += f"PATH=\"$( cd -- $( dirname -- \"${{BASH_SOURCE[0]}}\" ) &> /dev/null && pwd )/Scripts\":$PATH\n"
        devenv_script_buffer += f"PATH=\"$( cd -- $( dirname -- \"${{BASH_SOURCE[0]}}\" ) &> /dev/null && pwd )/Symlinks\":$PATH\n"

    devenv_script_name = f"{devenv_script_name}.bat" if is_windows else f"{devenv_script_name}.sh"
    devenv_script_path = pathlib.Path(install_dir, devenv_script_name)

    lprint(f"Writing script to augment the environment with installed applications: {devenv_script_path}")
    devenv_script_path.write_text(devenv_script_buffer)

    if not is_windows:
        subprocess.run(args=["chmod", "+x", devenv_script_path])

    # Merge the install dictionaries, this dictionary contains
    # (app label) -> [array of installed versions]
    result = internal_apps
    for key, value in user_apps.items():
        if key not in result:
            result.update({key: value})
        else:
            result[key] += value

    return result
