@echo off
REM
REM Cmder
REM
set cmder_version=v1.3.15
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
set cmder_user_profile_install_path=Cmder\config\user_profile.cmd
set cmder_user_profile=Installer\win32_cmder_user_profile.cmd
echo - Copy %cmder_user_profile% to %cmder_user_profile_install_path%
copy /Y %cmder_user_profile% %cmder_user_profile_install_path% > NUL

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
set gvim_fullscreen_dll_install_path=GVim\App\vim\vim80\gvimfullscreen.dll
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
REM Ag
REM
echo - Copy Installer\win32_ag.exe to %cmder_install_path%\bin\ag.exe
copy /Y Installer\win32_ag.exe %cmder_install_path%\bin\ag.exe
