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
set cmder_zip=%installer_root%\win32_cmder_%cmder_version%.7z
if exist "%cmder_root%" (
    echo - [Cache] Cmder already installed at %cmder_root%
) else (
    call :DownloadFile https://github.com/cmderdev/cmder/releases/download/%cmder_version%/cmder.7z "%cmder_zip%" || exit /b
    call :Unzip "%cmder_zip%" "%cmder_root%" || exit /b
)

REM
REM Misc Tools
REM clang-format: C/C++ formatting tool
REM ctags: C/C++ code annotation generator
REM scanmapset: Bind capslock to escape via registry
REM uncap: Bind capslock to escape via run-time program
call :CopyFile "%installer_root%\win32_clang_format.exe" "%cmder_root%\bin\clang-format.exe" || exit /b
call :CopyFile "%installer_root%\win32_ctags.exe" "%cmder_root%\bin\ctags.exe" || exit /b
call :CopyFile "%installer_root%\win32_scanmapset.exe" "%cmder_root%\bin\scanmapset.exe" || exit /b
call :CopyFile "%installer_root%\win32_uncap.exe" "%cmder_root%\bin\uncap.exe" || exit /b

REM
REM GVim, Vim Plug, Vim Config
REM
set gvim_zip=%installer_root%\win32_gvim_x64.7z
set gvim_path=%tools_root%\GVim
if exist "%gvim_path%" (
    echo - [Cache] GVim already installed at %gvim_path%
) else (
    call :DownloadFile https://tuxproject.de/projects/vim/complete-x64.7z %gvim_zip% || exit /b
    call :Unzip "%gvim_zip%" "%gvim_path%" || exit /b
)

call :CopyFile "%installer_root%\_vimrc" "%home%" || exit /b
call :CopyFile "%installer_root%\win32_gvim_fullscreen.dll" "%gvim_path%\gvim_fullscreen.dll" || exit /b

set vim_plug_path=%vim_root%\autoload
set vim_plug=%vim_plug_path%\plug.vim
if exist "%vim_plug%" (
    echo - [Cache] Vim Plug already installed at %vim_plug%
) else (
    if not exist "%vim_plug_path%" mkdir "%vim_plug_path%"
    call :DownloadFile https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim "%vim_plug%" || exit /b
)

REM
REM ripgrep
REM
set rg_zip=%installer_root%\win32_rg_v12.1.1.7z
set rg_exe=%cmder_root%\bin\rg.exe
if exist "%rg_exe%" (
    echo - [Cache] rg already installed at %rg_exe%
) else (
    call :Unzip "%rg_zip%" "%cmder_root%\bin" || exit /b
)

REM
REM Zig
REM
set zig_version=0.7.0
set zig_file=zig-windows-x86_64-%zig_version%.zip
set zig_zip=%installer_root%\win32_%zig_file%
set zig_path=%compiler_root%\zig-windows-x86_64-%zig_version%
if exist "%zig_path%" (
    echo - [Cache] Zig already installed at %zig_path%
) else (
    call :DownloadFile https://ziglang.org/download/%zig_version%/%zig_file% %zig_zip% || exit /b
    call :Unzip "%zig_zip%" "%compiler_root%" || exit /b
)

REM
REM Python
REM
set python_version=3.9.0.2dot
set python_version_nodot=3902
set python_url=https://github.com/winpython/winpython/releases/download/3.0.20201028/Winpython64-%python_version%.exe
set python_zip=%installer_root%\win32_Winpython64-%python_version%.exe
set python_path=%tools_root%\WPy64-%python_version_nodot%
if exist "%python_path%" (
    echo - [Cache] Python already installed at %python_path%
) else (
    call :DownloadFile %python_url% "%python_zip%" || exit /b
    call :Unzip "%python_zip%" "%tools_root%" || exit /b
)

REM
REM Generate Cmder Startup Config File
REM
set cmder_config_file=%cmder_root%\config\user_profile.cmd
echo - Generate cmder config at %cmder_config_file%
echo @echo off> %cmder_config_file%
echo set PATH=%zig_path%;%python_path%\python-3.9.0.amd64;%%PATH%%>> "%cmder_config_file%"
echo set PYTHONHOME=%python_path%\python-3.9.0.amd64>> "%cmder_config_file%"
echo set HOME=%cmder_root%\..\Home>> "%cmder_config_file%"
echo set HOMEPATH=%cmder_root%\..\Home>> "%cmder_config_file%"
echo set USERPROFILE=%cmder_root%\..\Home>> "%cmder_config_file%"
echo alias gvim=%cmder_root%\..\Tools\GVim\gvim.exe $*>> "%cmder_config_file%"

REM
REM CTags Helper Script
REM
set ctags_file=%cmder_root%\bin\ctags_cpp.bat
echo @echo off> %ctags_file%
echo ctags --c++-kinds=+p --fields=+iaS --extras=+q --language-force=C++ %%*>> %ctags_file%

echo - Setup complete! Launch %cmder_root%\cmder.exe [or restart Cmder instance if you're updating an existing installation]
exit /b

REM
REM Functions
REM
:DownloadFile
set url=%~1
set dest_file=%~2

echo - [Download File] %url% to %dest_file%
if not exist %dest_file% powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest %url% -OutFile %dest_file%"
if not exist %dest_file% echo Failed to download file from %url%
exit /b %ERRORLEVEL%

:CopyFile
set src_file=%~1
set dest_file=%~2

copy /Y %src_file% %dest_file% > nul
if exist "%dest_file%" echo - [Copy File] %src_file% to %dest_file%
if not exist "%dest_file%" echo - [Copy File] Failed to copy file from %src_file% to %dest_file%
exit /b %ERRORLEVEL%

:Unzip
set zip_file=%~1
set dest=%~2

echo - [Unzip] %zip_file% to %dest%
%installer_root%\win32_7za.exe x -y -o%dest% %zip_file%
if not exist %dest% echo - [Unzip] Failed to unzip %zip_file% to %dest%
exit /b %ERRORLEVEL%
