@echo off
setlocal EnableDelayedExpansion

set root=%~dp0
set home=!root!\home
set cmder_root=!root!\Cmder
set installer_root=!root!\Installer
set downloads_root=!installer_root!\Downloads
set vim_root=!home!\vimfiles
set tools_root=!root!\Tools
set compiler_root=!tools_root!\Compiler

if not exist !home! mkdir !home!
if not exist !installer_root! mkdir !installer_root!
if not exist !downloads_root! mkdir !downloads_root!
if not exist !tools_root! mkdir !tools_root!
if not exist !compiler_root! mkdir !compiler_root!

REM ----------------------------------------------------------------------------
REM Cmder
REM ----------------------------------------------------------------------------
set cmder_version=v1.3.16
set cmder_zip=!downloads_root!\win32_cmder_!cmder_version!.7z
call :DownloadFile https://github.com/cmderdev/cmder/releases/download/!cmder_version!/cmder.7z "!cmder_zip!" || exit /b
call :Unzip "!cmder_zip!" "!cmder_root!" || exit /b

REM ----------------------------------------------------------------------------
REM Misc Tools
REM ----------------------------------------------------------------------------
REM clang-format: C/C++ formatting tool
REM ctags: C/C++ code annotation generator
REM scanmapset: Bind capslock to escape via registry
REM uncap: Bind capslock to escape via run-time program
REM clang-format: Default clang-format style
call :CopyFile "!installer_root!\win32_clang_format.exe" "!cmder_root!\bin\clang-format.exe" || exit /b
call :CopyFile "!installer_root!\win32_ctags.exe" "!cmder_root!\bin\ctags.exe" || exit /b
call :CopyFile "!installer_root!\win32_scanmapset.exe" "!cmder_root!\bin\scanmapset.exe" || exit /b
call :CopyFile "!installer_root!\win32_uncap.exe" "!cmder_root!\bin\uncap.exe" || exit /b
call :CopyFile "!installer_root!\clang-format-style-file" "!home!\_clang-format" || exit /b

REM ----------------------------------------------------------------------------
REM GVim, Vim Plug, Vim Config
REM ----------------------------------------------------------------------------
set gvim_zip=!downloads_root!\win32_gvim_x64.7z
set gvim_path=!tools_root!\GVim
call :DownloadFile https://tuxproject.de/projects/vim/complete-x64.7z !gvim_zip! || exit /b
call :Unzip "!gvim_zip!" "!gvim_path!" || exit /b

call :CopyFile "!installer_root!\_vimrc" "!home!" || exit /b
call :CopyFile "!installer_root!\win32_gvim_fullscreen.dll" "!gvim_path!\gvim_fullscreen.dll" || exit /b

set vim_plug_path=!vim_root!\autoload
set vim_plug=!vim_plug_path!\plug.vim
if not exist "!vim_plug_path!" mkdir "!vim_plug_path!"
call :DownloadFile https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim "!vim_plug!" || exit /b

set vim_clang_format=!vim_root!\clang-format.py
call :DownloadFile https://raw.githubusercontent.com/llvm/llvm-project/main/clang/tools/clang-format/clang-format.py "!vim_clang_format!" || exit /b

REM ----------------------------------------------------------------------------
REM ripgrep
REM ----------------------------------------------------------------------------
set rg_sha256=a47ace6f654c5ffa236792fc3ee3fefd9c7e88e026928b44da801acb72124aa8
set rg_version=13.0.0
set rg_zip=!downloads_root!\win32_rg_v!rg_version!.7z
set rg_exe=!cmder_root!\bin\rg.exe
call :DownloadFile https://github.com/BurntSushi/ripgrep/releases/download/!rg_version!/ripgrep-!rg_version!-x86_64-pc-windows-msvc.zip !rg_zip! || exit /b
call :VerifyFile !rg_zip! !rg_sha256!
call :Unzip "!rg_zip!" "!rg_exe!" || exit /b

REM ----------------------------------------------------------------------------
REM everything (void tools search program)
REM ----------------------------------------------------------------------------
set everything_sha256=f61b601acba59d61fb0631a654e48a564db34e279b6f2cc45e20a42ce9d9c466
set everything_version=1.4.1.1009
set everything_zip=!downloads_root!\win32_everything_v!everything_version!.7z
set everything_exe=!cmder_root!\bin\everything.exe
call :DownloadFile https://www.voidtools.com/Everything-!everything_version!.x64.zip !everything_zip! || exit /B
call :VerifyFile !everything_zip! !everything_sha256! || exit /B
REM TODO(doyle): Doesn't work because the cache is not smart
call :Unzip "!everything_zip!" "!tools_root!" || exit /B

REM ----------------------------------------------------------------------------
REM Zig
REM ----------------------------------------------------------------------------
set zig_sha256=8580fbbf3afb72e9b495c7f8aeac752a03475ae0bbcf5d787f3775c7e1f4f807
set zig_version=0.8.0
set zig_file=zig-windows-x86_64-!zig_version!.zip
set zig_zip=!downloads_root!\win32_!zig_file!
set zig_path=!compiler_root!\zig-windows-x86_64-!zig_version!
call :DownloadFile https://ziglang.org/download/!zig_version!/!zig_file! !zig_zip! || exit /b
call :VerifyFile !zig_zip! !zig_sha256!
call :Unzip "!zig_zip!" "!compiler_root!" || exit /b

REM ----------------------------------------------------------------------------
REM Python
REM ----------------------------------------------------------------------------
set python_version=3.9.0.2dot
set python_version_nodot=3902
set python_url=https://github.com/winpython/winpython/releases/download/3.0.20201028/Winpython64-!python_version!.exe
set python_zip=!downloads_root!\win32_Winpython64-!python_version!.exe
set python_path=!tools_root!\WPy64-!python_version_nodot!
call :DownloadFile !python_url! "!python_zip!" || exit /b
call :Unzip "!python_zip!" "!tools_root!" || exit /b

REM ----------------------------------------------------------------------------
REM Generate Cmder Startup Config File
REM ----------------------------------------------------------------------------
set cmder_config_file=!cmder_root!\config\user_profile.cmd
echo - Generate cmder config at !cmder_config_file!
echo @echo off> !cmder_config_file!
echo set PATH=!zig_path!;%%PATH%%>> "!cmder_config_file!"
echo set PATH=!python_path!\python-3.9.0.amd64;%%PATH%%>> "!cmder_config_file!"
echo set PATH=!python_path!\python-3.9.0.amd64\Scripts;%%PATH%%>> "!cmder_config_file!"
echo set PYTHONHOME=!python_path!\python-3.9.0.amd64>> "!cmder_config_file!"
echo set HOME=!cmder_root!\..\Home>> "!cmder_config_file!"
echo set HOMEPATH=!cmder_root!\..\Home>> "!cmder_config_file!"
echo set USERPROFILE=!cmder_root!\..\Home>> "!cmder_config_file!"
echo alias gvim=!cmder_root!\..\Tools\GVim\gvim.exe $*>> "!cmder_config_file!"

REM ----------------------------------------------------------------------------
REM CTags Helper Script
REM ----------------------------------------------------------------------------
set ctags_file=!cmder_root!\bin\ctags_cpp.bat
echo @echo off> !ctags_file!
echo ctags --c++-kinds=+p --fields=+iaS --extras=+q !!*>> !ctags_file!

echo - Setup complete. Launch !cmder_root!\cmder.exe [or restart Cmder instance if you're updating an existing installation]
exit /b

REM ------------------------------------------------------------------------------------------------
REM Functions
REM ------------------------------------------------------------------------------------------------
:DownloadFile
set url=%~1
set dest_file=%~2
set msg=[Download File] !url! to !dest_file!

if exist !dest_file! (
    echo - [Cached] !msg!
) else (
    echo - !msg!
    call powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest !url! -OutFile !dest_file! -UserAgent [Microsoft.PowerShell.Commands.PSUserAgent]::FireFox"
)

if not exist !dest_file! echo [Download File] Failed to download file from !url!
exit /B !ERRORLEVEL!

REM ------------------------------------------------------------------------------------------------
:CopyFile
set src_file=%~1
set dest_file=%~2

call copy /Y !src_file! !dest_file! > nul
if     exist "!dest_file!" echo - [Copy] !src_file! to !dest_file!
if not exist "!dest_file!" echo - [Copy] Failed to copy file from !src_file! to !dest_file!
exit /B !ERRORLEVEL!

REM ------------------------------------------------------------------------------------------------
:Unzip
set zip_file=%~1
set dest=%~2
set msg=[Unzip] !zip_file! to !dest!

if exist !dest! (
    echo - [Cached] !msg!
) else (
    echo - !msg!
    call !installer_root!\win32_7za.exe x -y -o!dest! !zip_file!
)
exit /B

REM ------------------------------------------------------------------------------------------------
:VerifyFile
set file=%~1
set expected_sha256=%~2

REM Calculate hash
set calculated_sha256_file=!file!.sha256.txt
call powershell "$FileHash = Get-FileHash -algorithm sha256 !file!; $FileHash.Hash.ToLower()" > !calculated_sha256_file!

REM Verify Hash
set /p actual_sha256=< !calculated_sha256_file!
if "!expected_sha256!" neq "!actual_sha256!" (
    echo - [Verify] Hash BAD: Expected:   !expected_sha256!
    echo                      Calculated: !actual_sha256!
    exit /B -1
) else (
    echo - [Verify] Hash OK: !expected_sha256!
    exit /B 0
)
