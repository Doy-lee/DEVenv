@echo off
setlocal EnableDelayedExpansion

REM ----------------------------------------------------------------------------
REM Setup Folder Locations
REM ----------------------------------------------------------------------------
set root_dir=!CD!
set home_dir=Home
set cmder_dir=Cmder
set install_dir=Installer
set downloads_dir=!install_dir!\Downloads
set vim_dir=!home_dir!\vimfiles
set tools_dir=Tools

if not exist !home_dir! mkdir !home_dir!
if not exist !install_dir! mkdir !install_dir!
if not exist !downloads_dir! mkdir !downloads_dir!
if not exist !tools_dir! mkdir !tools_dir!

REM ----------------------------------------------------------------------------
REM Setup tools for setting up the development environment
REM ----------------------------------------------------------------------------

REM ----------------------------------------------------------------------------
REM Bootstrap 7zip
REM ----------------------------------------------------------------------------
REM We get an old version of 7z that is available as a .zip file which we can
REM extract on Windows with just PowerShell (i.e. no dependency).
set zip7_bootstrap_sha256=2a3afe19c180f8373fa02ff00254d5394fec0349f5804e0ad2f6067854ff28ac
set zip7_bootstrap_version=920
set zip7_bootstrap_zip=!downloads_dir!\win32_7zip_bootstrap_v!zip7_bootstrap_version!.zip
set zip7_bootstrap_dir=!tools_dir!\7zip_bootstrap-!zip7_bootstrap_version!
if not exist !zip7_bootstrap_dir! (
    call :DownloadFile "https://www.7-zip.org/a/7za!zip7_bootstrap_version!.zip" "!zip7_bootstrap_zip!" || exit /B
    call :VerifyFileSHA256 "!zip7_bootstrap_zip!" "!zip7_bootstrap_sha256!" || exit /B
)
if not exist "!zip7_bootstrap_dir!" powershell "Expand-Archive !zip7_bootstrap_zip! -DestinationPath !zip7_bootstrap_dir!" || exit /B

REM ----------------------------------------------------------------------------
REM 7zip
REM ----------------------------------------------------------------------------
REM Use our bootstrap 7z from above to download the latest 7zip version
REM NOTE: We do not use 7za because it can not unzip a NSIS installer. The full
REM version however can.
set zip7_sha256=0f5d4dbbe5e55b7aa31b91e5925ed901fdf46a367491d81381846f05ad54c45e
set zip7_version=1900
set zip7_zip=!downloads_dir!\win32_7zip_v!zip7_version!.exe
set zip7_dir=!tools_dir!\7zip-!zip7_version!
if not exist !zip7_dir! (
    call :DownloadFile "https://www.7-zip.org/a/7z!zip7_version!-x64.exe" "!zip7_zip!" || exit /B
    call :VerifyFileSHA256 "!zip7_zip!" "!zip7_sha256!" || exit /B
)
if not exist "!zip7_dir!" "!zip7_bootstrap_dir!\7za.exe" x -y -o"!zip7_dir!" !zip7_zip! || exit /B

REM ----------------------------------------------------------------------------
REM GPG Signature Verification
REM ----------------------------------------------------------------------------
set gpg_w32_sha256=77cec7f274ee6347642a488efdfa324e8c3ab577286e611c397e69b1b396ab16
set gpg_w32_version=2.3.1
set gpg_w32_date=20210420
set gpg_w32_zip=!downloads_dir!\win32_gpg_w32_v!gpg_w32_version!.exe
set gpg_w32_dir=!tools_dir!\gpg_w32-!gpg_w32_version!
if not exist "!gpg_w32_dir!\bin\gpg.exe" (
    call :DownloadFile "https://gnupg.org/ftp/gcrypt/binary/gnupg-w32-!gpg_w32_version!_!gpg_w32_date!.exe" "!gpg_w32_zip!" || exit /B
    call :VerifyFileSHA256 "!gpg_w32_zip!" "!gpg_w32_sha256!" || exit /B
    call :Unzip "!gpg_w32_zip!" "!gpg_w32_dir!" || exit /B
)

set gpg_w32_bin_dir=!gpg_w32_dir!\bin
set PATH="!gpg_w32_bin_dir!";!PATH!

REM ----------------------------------------------------------------------------
REM Application Setup
REM ----------------------------------------------------------------------------
REM Download & verify the tools we want for development

REM ----------------------------------------------------------------------------
REM Cmder
REM ----------------------------------------------------------------------------
set cmder_version=v1.3.16
set cmder_zip=!downloads_dir!\win32_cmder_!cmder_version!.7z
if not exist !cmder_dir! (
    call :DownloadFile https://github.com/cmderdev/cmder/releases/download/!cmder_version!/cmder.7z "!cmder_zip!" || exit /B
    call :Unzip "!cmder_zip!" "!cmder_dir!" || exit /B
)

REM ----------------------------------------------------------------------------
REM Dependencies (Walker) - For DLL dependency management
REM ----------------------------------------------------------------------------
set dependencies_sha256=44df956dbe267e0a705224c3b85d515fee2adc87509861e24fb6c6b0ea1b86d6
set dependencies_version=v1.10
set dependencies_zip=!downloads_dir!\win32_dependencies_!dependencies_version!.zip
set dependencies_dir=!tools_dir!\dependencies-!dependencies_version!
if not exist "!dependencies_dir!\DependenciesGui.exe" (
    call :DownloadFile "https://github.com/lucasg/Dependencies/releases/download/!dependencies_version!/Dependencies_x64_Release.zip" "!dependencies_zip!" || exit /B
    call :VerifyFileSHA256 "!dependencies_zip!" "!dependencies_sha256!" || exit /B
    call :Unzip "!dependencies_zip!" "!dependencies_dir!" || exit /B
)

REM ----------------------------------------------------------------------------
REM everything (void tools search program)
REM ----------------------------------------------------------------------------
set everything_sha256=f61b601acba59d61fb0631a654e48a564db34e279b6f2cc45e20a42ce9d9c466
set everything_version=1.4.1.1009
set everything_zip=!downloads_dir!\win32_everything_v!everything_version!.7z
set everything_dir=!tools_dir!\everything-!everything_version!
if not exist "!everything_dir!\everything.exe" (
    call :DownloadFile "https://www.voidtools.com/Everything-!everything_version!.x64.zip" "!everything_zip!" || exit /B
    call :VerifyFileSHA256 "!everything_zip!" "!everything_sha256!" || exit /B
    call :Unzip "!everything_zip!" "!everything_dir!" || exit /B
)

REM ----------------------------------------------------------------------------
REM GVim, Vim Plug, Vim Config
REM ----------------------------------------------------------------------------
set gvim_zip=!downloads_dir!\win32_gvim_x64.7z
set gvim_dir=!tools_dir!\GVim
if not exist "!gvim_dir!\gvim.exe" (
    call :DownloadFile https://tuxproject.de/projects/vim/complete-x64.7z !gvim_zip! || exit /B
    call :Unzip "!gvim_zip!" "!gvim_dir!" || exit /B
)

call :CopyFile "!install_dir!\_vimrc" "!home_dir!" || exit /B
call :CopyFile "!install_dir!\win32_gvim_fullscreen.dll" "!gvim_dir!\gvim_fullscreen.dll" || exit /B

set vim_plug_dir=!vim_dir!\autoload
set vim_plug=!vim_plug_dir!\plug.vim
if not exist "!vim_plug_dir!" mkdir "!vim_plug_dir!"
call :DownloadFile "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" "!vim_plug!" || exit /B

set vim_clang_format=!vim_dir!\clang-format.py
call :DownloadFile "https://raw.githubusercontent.com/llvm/llvm-project/main/clang/tools/clang-format/clang-format.py" "!vim_clang_format!" || exit /B

REM ----------------------------------------------------------------------------
REM Keypirinha
REM ----------------------------------------------------------------------------
set keypirinha_sha256=d109a16e6a5cf311abf6d06bbe5b1be3b9ba323b79c32a168628189e10f102a5
set keypirinha_version=2.26
set keypirinha_zip=!downloads_dir!\win32_keypirinha-x64-!keypirinha_version!.7z
set keypirinha_dir=!tools_dir!\keypirinha-x64-!keypirinha_version!
if not exist "!keypirinha_dir!\keypirinha.exe" (
    call :DownloadFile "https://github.com/Keypirinha/Keypirinha/releases/download/v!keypirinha_version!/keypirinha-!keypirinha_version!-x64-portable.7z" "!keypirinha_zip!" || exit /B
    call :VerifyFileSHA256 "!keypirinha_zip!" "!keypirinha_sha256!" || exit /B
    call :Unzip "!keypirinha_zip!" "!keypirinha_dir!" || exit /B
    call :Move "!keypirinha_dir!\keypirinha" "!keypirinha_dir!" || exit /B
)

REM ----------------------------------------------------------------------------
REM LLVM/Clang
REM ----------------------------------------------------------------------------
set llvm_version=12.0.1
set llvm_zip=!downloads_dir!\win32_llvm_x64_v!llvm_version!.exe
set llvm_dir=!tools_dir!\llvm-!llvm_version!
set llvm_gpg_key=!downloads_dir!\llvm-tstellar-gpg-key.asc
set llvm_gpg_sig=!llvm_zip!.sig
if not exist "!llvm_dir!\bin\clang.exe" (
    call :DownloadFile "https://github.com/llvm/llvm-project/releases/download/llvmorg-9.0.1/tstellar-gpg-key.asc" "!llvm_gpg_key!" || exit /B
    call :DownloadFile "https://github.com/llvm/llvm-project/releases/download/llvmorg-!llvm_version!/LLVM-!llvm_version!-win64.exe.sig" "!llvm_gpg_sig!" || exit /B
    call :DownloadFile "https://github.com/llvm/llvm-project/releases/download/llvmorg-!llvm_version!/LLVM-!llvm_version!-win64.exe" "!llvm_zip!" || exit /B

    gpg --import "!llvm_gpg_key!" || exit /B
    gpg --verify "!llvm_gpg_sig!" "!llvm_zip!" || exit /B
    call :Unzip "!llvm_zip!" "!llvm_dir!" || exit /B
)

set llvm_bin_dir=!llvm_dir!\bin

REM ----------------------------------------------------------------------------
REM Misc Tools
REM ----------------------------------------------------------------------------
REM ctags: C/C++ code annotation generator
REM scanmapset: Bind capslock to escape via registry
REM uncap: Bind capslock to escape via run-time program
call :CopyFile "!install_dir!\win32_ctags.exe" "!cmder_dir!\bin\ctags.exe" || exit /B
call :CopyFile "!install_dir!\win32_scanmapset.exe" "!cmder_dir!\bin\scanmapset.exe" || exit /B
call :CopyFile "!install_dir!\win32_uncap.exe" "!cmder_dir!\bin\uncap.exe" || exit /B
call :CopyFile "!install_dir!\clang-format-style-file" "!home_dir!\_clang-format" || exit /B

REM ------------------------------------------------------------------------
REM MinGW64
REM ------------------------------------------------------------------------
set mingw_sha256=853970527b5de4a55ec8ca4d3fd732c00ae1c69974cc930c82604396d43e79f8
set mingw_version=8.1.0
set mingw_zip=!downloads_dir!\mingw64-posix-seg-rt_v6-rev0!mingw_version!.7z
set mingw_dir=!tools_dir!\mingw64-posix-seh-rt_v6-rev0-!mingw_version!
set mingw_bin_dir=!mingw_dir!\bin
if not exist "!mingw_bin_dir!\gcc.exe" (
    call :DownloadFile \"https://sourceforge.net/projects/mingw-w64/files/Toolchains targetting Win64/Personal Builds/mingw-builds/%mingw_version%/threads-posix/seh/x86_64-!mingw_version!-release-posix-seh-rt_v6-rev0.7z\" !mingw_zip! || exit /B
    call :VerifyFileSHA256 !mingw_zip! !mingw_sha256! || exit /B
    call :Unzip !mingw_zip! !mingw_dir! || exit /B
    call :Move !mingw_dir!\mingw64 !mingw_dir! || exit /B
)
set PATH=!working_dir!\!mingw_bin_dir!;!PATH!

REM ----------------------------------------------------------------------------
REM ProcessHacker
REM ----------------------------------------------------------------------------
set process_hacker_sha256=e8836365abab7478d8e4c2d3fb3bb1fce82048cd4da54bab41cacbae1f45b1ff
set process_hacker_version=3.0.4212
set process_hacker_zip=!downloads_dir!\win32_process_hacker-!process_hacker_version!.zip
set process_hacker_dir=!tools_dir!\process_hacker-!process_hacker_version!
if not exist "!process_hacker_dir!\64bit\ProcessHacker.exe" (
    call :DownloadFile "https://ci.appveyor.com/api/buildjobs/8say005q9xy48cc3/artifacts/processhacker-!process_hacker_version!-bin.zip" "!process_hacker_zip!" || exit /B
    call :VerifyFileSHA256 "!process_hacker_zip!" "!process_hacker_sha256!" || exit /B
    call :Unzip "!process_hacker_zip!" "!process_hacker_dir!" || exit /B
)

REM ----------------------------------------------------------------------------
REM Python
REM ----------------------------------------------------------------------------
set python_sha256=93cc3db75dffb4d56b9f64af43294f130f2c222a66de7a1325d0ce8f1ed62e26
set python_version=3.9.0.2dot
set python_version_nodot=3902
set python_version_dot=3.9.0
set python_zip=!downloads_dir!\win32_Winpython64-!python_version!.exe
set python_dir=!tools_dir!\Winpython64-!python_version_nodot!
if not exist !python_dir! (
    call :DownloadFile "https://github.com/winpython/winpython/releases/download/3.0.20201028/Winpython64-!python_version!.exe" "!python_zip!" || exit /B
    call :VerifyFileSHA256 "!python_zip!" "!python_sha256!" || exit /B
    call :Unzip "!python_zip!" "!python_dir!" || exit /B
    call :Move "!python_dir!\WPy64-!python_version_nodot!" "!python_dir!" || exit /B
)

set python_bin_dir=!python_dir!\python-!python_version_dot!.amd64
set python_scripts_bin_dir=!python_bin_dir!\Scripts

REM ----------------------------------------------------------------------------
REM ripgrep
REM ----------------------------------------------------------------------------
set rg_sha256=a47ace6f654c5ffa236792fc3ee3fefd9c7e88e026928b44da801acb72124aa8
set rg_version=13.0.0
set rg_zip=!downloads_dir!\win32_rg_v!rg_version!.zip
set rg_dir=!tools_dir!\ripgrep-!rg_version!
if not exist "!rg_dir!\rg.exe" (
    call :DownloadFile "https://github.com/BurntSushi/ripgrep/releases/download/!rg_version!/ripgrep-!rg_version!-x86_64-pc-windows-msvc.zip" "!rg_zip!" || exit /B
    call :VerifyFileSHA256 "!rg_zip!" "!rg_sha256!" || exit /B
    call :Unzip "!rg_zip!" "!rg_dir!" || exit /B
    call :Move "!rg_dir!\ripgrep-!rg_version!-x86_64-pc-windows-msvc" "!rg_dir!" || exit /B
)

REM ----------------------------------------------------------------------------
REM Zig
REM ----------------------------------------------------------------------------
set zig_sha256=8580fbbf3afb72e9b495c7f8aeac752a03475ae0bbcf5d787f3775c7e1f4f807
set zig_version=0.8.0
set zig_file=zig-windows-x86_64-!zig_version!.zip
set zig_zip=!downloads_dir!\win32_!zig_file!
set zig_dir=!tools_dir!\zig-windows-x86_64-!zig_version!
if not exist "!zig_dir!\zig.exe" (
    call :DownloadFile "https://ziglang.org/download/!zig_version!/!zig_file!" "!zig_zip!" || exit /B
    call :VerifyFileSHA256 "!zig_zip!" "!zig_sha256!" || exit /B
    call :Unzip "!zig_zip!" "!zig_dir!" || exit /B
)

REM ----------------------------------------------------------------------------
REM Super Terminal
REM ----------------------------------------------------------------------------
set terminal_script=!root_dir!\win32_terminal.bat
set msvc_script=!tools_dir!\MSVC-2019-v16.9.2-VC-v14.28.29910-Win10-SDK-v10.0.19041.0-x64\msvc_env_x64.bat

echo @echo off> "!terminal_script!"
echo set PATH=%%~dp0!gpg_w32_bin_dir!;%%PATH%%>> "!terminal_script!"
echo set PATH=%%~dp0!gvim_dir!;%%PATH%%>> "!terminal_script!"
echo set PATH=%%~dp0!llvm_bin_dir!;%%PATH%%>> "!terminal_script!"
echo set PATH=%%~dp0!mingw_bin_dir!;%%PATH%%>> "!terminal_script!"
echo set PATH=%%~dp0!python_bin_dir!;%%PATH%%>> "!terminal_script!"
echo set PATH=%%~dp0!python_scripts_bin_dir!;%%PATH%%>> "!terminal_script!"
echo set PATH=%%~dp0!rg_dir!;%%PATH%%>> "!terminal_script!"
echo set PATH=%%~dp0!zig_dir!;%%PATH%%>> "!terminal_script!"
echo set PATH=%%~dp0!zip7_dir!;%%PATH%%>> "!terminal_script!"
echo set PYTHONHOME=%%~dp0!python_bin_dir!>> "!terminal_script!"
echo set HOME=%%~dp0!home_dir!>> "!terminal_script!"
echo set HOMEPATH=%%~dp0!home_dir!>> "!terminal_script!"
echo set USERPROFILE=%%~dp0!home_dir!>> "!terminal_script!"
echo if exist "%%~dp0!msvc_script!" call "%%~dp0!msvc_script!">> "!terminal_script!"
echo call "%%~dp0!cmder_dir!\cmder.exe" %%*>> "!terminal_script!"

REM ----------------------------------------------------------------------------
REM Background Application Scripts
REM ----------------------------------------------------------------------------
set terminal_script=!root_dir!\win32_start_background_apps.bat
echo @echo off> "!terminal_script!"
echo "%%~dp0!everything_dir!\everything.exe">> "!terminal_script!"
echo "%%~dp0!keypirinha_dir!\keypirinha.exe">> "!terminal_script!"

REM ----------------------------------------------------------------------------
REM CTags Helper Script
REM ----------------------------------------------------------------------------
set ctags_file=!cmder_dir!\bin\ctags_cpp.bat
echo @echo off> "!ctags_file!"
echo ctags --c++-kinds=+p --fields=+iaS --extras=+q %%*>> !ctags_file!

echo - Setup complete. Launch !cmder_dir!\cmder.exe [or restart Cmder instance if you're updating an existing installation]
pause
exit /B

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
    call !zip7_dir!\7z.exe x -y -spe -o!dest! !zip_file!
)
exit /B !ERROLEVEL!

REM ------------------------------------------------------------------------------------------------
:VerifyFileSHA256
set file=%~1
set expected_sha256=%~2

REM Calculate hash
set calculated_sha256_file=!file!.sha256.txt
call powershell "$FileHash = Get-FileHash -algorithm sha256 !file!; $FileHash.Hash.ToLower()" > !calculated_sha256_file!

REM Verify Hash
set /p actual_sha256=< !calculated_sha256_file!
if "!expected_sha256!" neq "!actual_sha256!" (
    echo - [Verify] !file!
    echo SHA256 Hash does not match, failing.
    echo Expected:   !expected_sha256!
    echo Calculated: !actual_sha256!
    exit /B -1
) else (
    echo - [Verify] !file! Hash OK: !expected_sha256!
    exit /B 0
)

REM ------------------------------------------------------------------------------------------------
:Move
set src=%~1
set dest=%~2
if exist !src! robocopy !src! !dest! /E /MOVE /NP /NJS /NJS /NS /NC /NFL /NDL
exit /B 0
