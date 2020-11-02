@echo off
setlocal

REM
REM Cmder
REM
set cmder_version=v1.3.16
set cmder_url=https://github.com/cmderdev/cmder/releases/download/%cmder_version%/cmder.7z
set cmder_zip=Installer\win32_cmder_%cmder_version%.7z
set cmder_install_path=Cmder

echo - Downloading from %cmder_url% to %cmder_zip%
if not exist "%cmder_zip%" powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest %cmder_url% -OutFile %cmder_zip%"
if not exist "%cmder_zip%" echo Failed to download cmder, exiting.
if not exist "%cmder_zip%" goto :eof

echo - Extracting %cmder_zip% to %cmder_install_path%
if not exist "%cmder_install_path%" Installer\win32_7za.exe x -y -o%cmder_install_path% %cmder_zip% > NUL

REM
REM Cmder User Profile
REM
set cmder_user_profile=Installer\win32_cmder_user_profile.cmd
set cmder_user_profile_install_path=%cmder_root%\config
set cmder_user_profile_install_dest=%cmder_user_profile_install_path%\user_profile.cmd

echo - Copy %cmder_user_profile% to %cmder_user_profile_install_path%
if not exist "%cmder_user_profile_install_path%" mkdir "%cmder_user_profile_install_path%"
copy /Y %cmder_user_profile% %cmder_user_profile_install_dest% > NUL

REM
REM GVim
REM
set vim_install_path=GVim
set vim_zip=Installer\win32_GVim_v8.2.paf.7z

echo - Extracting %vim_zip% to %vim_install_path%
if not exist "%vim_install_path%" Installer\win32_7za.exe x -y -o%vim_install_path% %vim_zip% > NUL

REM
REM Vim Plug
REM
set vim_root=GVim\Data\settings
set vim_plug_url=https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
set vim_plug_install_path=%vim_root%\vimfiles\autoload
set vim_plug_file=%vim_plug_install_path%\plug.vim

echo - Downloading from %vim_plug_url% to %vim_plug_install_path%
if not exist "%vim_plug_install_path%" mkdir "%vim_plug_install_path%"
if not exist "%vim_plug_file%" powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest %vim_plug_url% -OutFile %vim_plug_file%"

REM
REM GVim Fullscreen DLL
REM
set gvim_fullscreen_dll=Installer\win32_gvim_fullscreen.dll
set gvim_fullscreen_dll_install_path=GVim\App\vim\vim80\gvim_fullscreen.dll
echo - Copy %gvim_fullscreen_dll% to %gvim_fullscreen_dll_install_path%
copy /Y %gvim_fullscreen_dll% %gvim_fullscreen_dll_install_path%

REM
REM vimrc
REM
echo - Copy Installer\_vimrc to %vim_root%
copy /Y Installer\_vimrc %vim_root% > NUL

REM
REM Clang Format
REM
set clang_format_url=https://raw.githubusercontent.com/llvm-mirror/clang/master/tools/clang-format/clang-format.py
set clang_format_path=%vim_root%\.vim
set clang_format_file=%clang_format_path%\clang-format.py
echo - Downloading from %clang_format_url% to %clang_format_path%
if not exist "%clang_format_path%" mkdir "%clang_format_path%"
if not exist "%clang_format_file%" powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest %clang_format_url% -OutFile %clang_format_file%"

echo - Copy Installer\win32_clang_format.exe to %cmder_install_path%\bin\clang-format.exe
copy /Y Installer\win32_clang_format.exe %cmder_install_path%\bin\clang-format.exe

REM
REM Python
REM
set python_version=3.6.5
set python_zip=python-%python_version%-embed-win32.zip
set python_url=https://www.python.org/ftp/python/%python_version%/%python_zip%
set python_zip_dest=Installer\%python_zip%
set python_dest=%cmder_root%\bin\python

echo - Downloading from %python_url% to %python_zip_dest%
if not exist "%python_zip_dest%" powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest %python_url% -OutFile %python_zip_dest%"

echo - Unzip %python_zip_dest% to %python_dest%
if not exist "%python_dest%" Installer\win32_7za.exe x -y -o%python_dest% %python_zip_dest% > NUL

REM Python Pip Setup
set python_pth_file=Installer\win32_python36._pth
set python_pth_dest_file=%python_dest%\python36._pth
echo - Copy %python_pth_file% to %python_pth_dest_file%
copy /Y %python_pth_file% %python_pth_dest_file% > NUL

REM Python Pip
set python_pip_url=https://bootstrap.pypa.io/get-pip.py
set python_pip_file=%python_dest%\get-pip.py
echo - Downloading from %python_pip_url% to %python_pip_file%
if not exist "%python_pip_file%" powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest %python_pip_url% -OutFile %python_pip_file%"
if not exist "%python_dest%\Scripts\pip.exe" %python_dest%\python %python_pip_file%

REM
REM ctags, scanmapset (bind capslock to escape via registry), uncap (bind capslock to escape whilst program running shim)
REM
set ctags_path=%cmder_install_path%\bin\ctags.exe
set scanmapset_path=%cmder_install_path%\bin\scanmapset.exe
set uncap_path=%cmder_install_path%\bin\uncap.exe

set ctags_file=Installer\win32_ctags.exe
set scanmapset_file=Installer\win32_scanmapset.exe
set uncap_file=Installer\win32_uncap.exe

echo - Copy %ctags_file% to %ctags_path%
echo - Copy %scanmapset_file% to %scanmapset_path%
echo - Copy %uncap_file% to %uncap_path%

copy /Y %ctags_file% %ctags_path%
copy /Y %scanmapset_file% %scanmapset_path%
copy /Y %uncap_file% %uncap_path%

REM
REM ripgrep
REM
set rg_path=%cmder_install_path%\bin
set rg_zip=Installer\win32_rg_v12.1.1.7z
echo - Extracting %rg_zip% to %rg_path%
if not exist "%rg_path%\rg.exe" Installer\win32_7za.exe x -y -o%rg_path% %rg_zip% > NUL

if not exist %cmder_root%\..\Home mkdir %cmder_root%\..\Home
