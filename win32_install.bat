@echo off
setlocal

set root=%~dp0
set home=%root%\home
set cmder_root=%root%\Cmder
set installer_root=%root%\Installer
set vim_root=%home%\vimfiles
set tools_root=%root%\Tools
set compiler_root=%tools_root%\Compiler

if not exist %home% mkdir %home%
if not exist %installer_root% mkdir %installer_root%
if not exist %tools_root% mkdir %tools_root%
if not exist %compiler_root% mkdir %compiler_root%

REM
REM Cmder
REM
set cmder_version=v1.3.16
set cmder_url=https://github.com/cmderdev/cmder/releases/download/%cmder_version%/cmder.7z
set cmder_zip=%installer_root%\win32_cmder_%cmder_version%.7z

echo - Downloading from %cmder_url% to %cmder_zip%
if not exist "%cmder_zip%" powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest %cmder_url% -OutFile %cmder_zip%"
if not exist "%cmder_zip%" echo Failed to download cmder, exiting.
if not exist "%cmder_zip%" goto :eof

echo - Extracting %cmder_zip% to %cmder_root%
if not exist "%cmder_root%" %installer_root%\win32_7za.exe x -y -o%cmder_root% %cmder_zip% > NUL

REM
REM GVim
REM
set gvim_url=https://tuxproject.de/projects/vim/complete-x64.7z
set gvim_zip=%installer_root%\win32_gvim_x64.7z
set gvim_dir=%tools_root%\GVim

echo - Downloading from %gvim_url% to %gvim_zip%
if not exist "%gvim_zip%" powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest %gvim_url% -OutFile %gvim_zip%"
if not exist "%gvim_zip%" echo Failed to download GVim, exiting.
if not exist "%gvim_zip%" goto :eof

if not exist %gvim_dir% %installer_root%\win32_7za.exe x -y -o%gvim_dir% %gvim_zip% > NUL

REM
REM Vim Plug
REM
set vim_plug_url=https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
set vim_plug_install_dir=%vim_root%\autoload
set vim_plug_file=%vim_plug_install_dir%\plug.vim
if not exist "%vim_plug_install_dir%" mkdir "%vim_plug_install_dir%"

echo - Downloading from %vim_plug_url% to %vim_plug_install_dir%
if not exist "%vim_plug_file%" powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest %vim_plug_url% -OutFile %vim_plug_file%"
if not exist "%vim_plug_file%" echo Failed to download Vim Plug, exiting.
if not exist "%vim_plug_file%" goto :eof

REM
REM GVim Fullscreen DLL
REM
set gvim_fullscreen_dll=%installer_root%\win32_gvim_fullscreen.dll
set gvim_fullscreen_dll_install=%gvim_dir%\gvim_fullscreen.dll
echo - Copy %gvim_fullscreen_dll% to %gvim_fullscreen_dll_install%
copy /Y %gvim_fullscreen_dll% %gvim_fullscreen_dll_install%

REM
REM vimrc
REM
echo - Copy %installer_root%\_vimrc to %home%
copy /Y %installer_root%\_vimrc %home% > NUL

REM
REM Clang Format
REM
set clang_format_url=https://raw.githubusercontent.com/llvm/llvm-project/master/clang/tools/clang-format/clang-format.py
set clang_format_file=%vim_root%\clang-format.py
echo - Downloading from %clang_format_url% to %vim_root%
if not exist "%clang_format_file%" powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest %clang_format_url% -OutFile %clang_format_file%"
if not exist "%clang_format_file%" echo Failed to download Clang-Format, exiting.
if not exist "%clang_format_file%" goto :eof

echo - Copy Installer\win32_clang_format.exe to %cmder_root%\bin\clang-format.exe
copy /Y %installer_root%\win32_clang_format.exe %cmder_root%\bin\clang-format.exe

REM
REM ctags, scanmapset (bind capslock to escape via registry), uncap (bind capslock to escape whilst program running shim)
REM
set ctags_dir=%cmder_root%\bin\ctags.exe
set scanmapset_dir=%cmder_root%\bin\scanmapset.exe
set uncap_dir=%cmder_root%\bin\uncap.exe

set ctags_file=%installer_root%\win32_ctags.exe
set scanmapset_file=%installer_root%\win32_scanmapset.exe
set uncap_file=%installer_root%\win32_uncap.exe

echo - Copy %ctags_file% to %ctags_dir%
echo - Copy %scanmapset_file% to %scanmapset_dir%
echo - Copy %uncap_file% to %uncap_dir%

copy /Y %ctags_file% %ctags_dir%
copy /Y %scanmapset_file% %scanmapset_dir%
copy /Y %uncap_file% %uncap_dir%

REM
REM ripgrep
REM
set rg_dir=%cmder_root%\bin
set rg_zip=%installer_root%\win32_rg_v12.1.1.7z
echo - Extracting %rg_zip% to %rg_dir%
if not exist "%rg_dir%\rg.exe" %installer_root%\win32_7za.exe x -y -o%rg_dir% %rg_zip% > NUL

if not exist %cmder_root%\..\Home mkdir %cmder_root%\..\Home

REM
REM Zig
REM
set zig_version=0.6.0
set zig_zip=zig-windows-x86_64-%zig_version%.zip
set zig_url=https://ziglang.org/download/%zig_version%/%zig_zip%
set zig_zip_installer=%installer_root%\win32_%zig_zip%
set zig_zip_install_path=%compiler_root%\zig-windows-x86_64-%zig_version%

echo - Downloading from %zig_url% to %zig_zip_installer%
if not exist "%zig_zip_installer%" powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest %zig_url% -OutFile %zig_zip_installer%"
if not exist "%zig_zip_installer%" echo Failed to download Zig, exiting.
if not exist "%zig_zip_installer%" goto :eof

echo - Unzip %zig_zip_installer% to %zig_zip_install_path%
if not exist %zig_zip_install_path% %installer_root%\win32_7za.exe x -y -o%compiler_root% %zig_zip_installer% > NUL

REM
REM Python
REM
set python_url=https://github.com/winpython/winpython/releases/download/3.0.20201028/Winpython64-3.9.0.2dot.exe
set python_zip_installer=%installer_root%\win32_Winpython64dot.exe
set python_zip_install_path=%tools_root%\WPy64-3902

echo - Downloading from %python_url% to %python_zip_installer%
if not exist "%python_zip_installer%" powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest %python_url% -OutFile %python_zip_installer%"
if not exist "%python_zip_installer%" echo Failed to download Python, exiting.
if not exist "%python_zip_installer%" goto :eof

echo - Unzip %python_zip_installer% to %python_zip_install_path%
if not exist %python_zip_install_path% %installer_root%\win32_7za.exe x -y -o%tools_root% %python_zip_installer% > NUL

set cmder_config_file=%cmder_root%\config\user_profile.cmd
echo @echo off> %cmder_config_file%
echo set PATH=%zig_zip_install_path%;%python_zip_install_path%\python-3.9.0.amd64;%%PATH%%>> %cmder_config_file%
echo set HOME=%cmder_root%\..\Home>> %cmder_config_file%
echo set HOMEPATH=%cmder_root%\..\Home>> %cmder_config_file%
echo set USERPROFILE=%cmder_root%\..\Home>> %cmder_config_file%
echo alias gvim=%cmder_root%\..\Tools\GVim\gvim_noOLE.exe $*>> %cmder_config_file%
