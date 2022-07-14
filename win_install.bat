@echo off
setlocal EnableDelayedExpansion

REM ----------------------------------------------------------------------------
REM Setup
REM ----------------------------------------------------------------------------
set root_dir=%~dp0

set home_dir=!root_dir!Home
set installer_dir=!root_dir!Installer
set tools_dir=!root_dir!Tools
set downloads_dir=!root_dir!Downloads
if not exist !home_dir! mkdir !home_dir!
if not exist !tools_dir! mkdir !tools_dir!
if not exist !downloads_dir! mkdir !downloads_dir!

set bin_dir=!tools_dir!\Binaries
if not exist !bin_dir! mkdir !bin_dir!

set tmp_terminal_script=!tools_dir!\win_terminal.bat.tmp
set terminal_script=!tools_dir!\win_terminal.bat
echo @echo off> "!tmp_terminal_script!"
echo set HOME=!home_dir!>> "!tmp_terminal_script!"
echo set HOMEPATH=!home_dir!>> "!tmp_terminal_script!"
echo set USERPROFILE=!home_dir!>> "!tmp_terminal_script!"
echo set APPDATA=!home_dir!\AppData>> "!tmp_terminal_script!"
echo set LOCALAPPDATA=!home_dir!\AppData\Local>> "!tmp_terminal_script!"
echo set PATH=!bin_dir!;%%PATH%%>> "!tmp_terminal_script!"

REM ----------------------------------------------------------------------------
REM Setup tools for setting up the development environment
REM ----------------------------------------------------------------------------
REM We are ultra pedantic and we check the hashes of the distribution but also
REM we check the hashes of the actual binary that we'll execute. This will
REM ensure that the currently installed programs in the tools folder doesn't get
REM tampered with at some point after installation.
REM
REM Unforunately, since this is not standard practice to provide by
REM distributions we have to calculate them manually.

REM ----------------------------------------------------------------------------
REM Bootstrap 7zip
REM ----------------------------------------------------------------------------
REM We get an old version of 7z that is available as a .zip file which we can
REM extract on Windows with just PowerShell (i.e. no dependency).
set zip7_bootstrap_sha256=2a3afe19c180f8373fa02ff00254d5394fec0349f5804e0ad2f6067854ff28ac
set zip7_bootstrap_exe_sha256=c136b1467d669a725478a6110ebaaab3cb88a3d389dfa688e06173c066b76fcf
set zip7_bootstrap_version=920

set zip7_bootstrap_label=7zip_bootstrap_win32_!zip7_bootstrap_version!
set zip7_bootstrap_zip=!downloads_dir!\!zip7_bootstrap_label!.zip
set zip7_bootstrap_dir=!tools_dir!\!zip7_bootstrap_label!
set zip7_bootstrap_exe=!zip7_bootstrap_dir!\7za.exe

if not exist "!zip7_bootstrap_exe!" (
    call win_helpers.bat :DownloadFile "https://www.7-zip.org/a/7za!zip7_bootstrap_version!.zip" "!zip7_bootstrap_zip!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :FileHashCheck sha256 "!zip7_bootstrap_zip!" "!zip7_bootstrap_sha256!" || exit /B %ERRORLEVEL%
)
if not exist "!zip7_bootstrap_dir!" powershell "Expand-Archive !zip7_bootstrap_zip! -DestinationPath !zip7_bootstrap_dir!" || exit /B %ERRORLEVEL%
call win_helpers.bat :FileHashCheck sha256 "!zip7_bootstrap_exe!" "!zip7_bootstrap_exe_sha256!" || exit /B %ERRORLEVEL%

REM ----------------------------------------------------------------------------
REM 7zip
REM ----------------------------------------------------------------------------
REM Use our bootstrap 7z from above to download the latest 7zip version
REM NOTE: We do not use 7za because it can not unzip a NSIS installer. The full
REM version however can.
set zip7_sha256=0b461f0a0eccfc4f39733a80d70fd1210fdd69f600fb6b657e03940a734e5fc1
set zip7_exe_sha256=ed24ed04b5d4a20b3f50fc088a455195c756d7b5315d1965e8c569472b43d939
set zip7_version=2107

set zip7_label=7zip_win64_!zip7_version!
set zip7_zip=!downloads_dir!\!zip7_label!.exe
set zip7_dir=!tools_dir!\!zip7_label!
set zip7_exe=!zip7_dir!\7z.exe

if not exist "!zip7_exe!" (
    call win_helpers.bat :DownloadFile "https://www.7-zip.org/a/7z!zip7_version!-x64.exe" "!zip7_zip!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :FileHashCheck sha256 "!zip7_zip!" "!zip7_sha256!" || exit /B %ERRORLEVEL%
    "!zip7_bootstrap_exe!" x -y -o"!zip7_dir!" !zip7_zip! || exit /B %ERRORLEVEL%
)

call win_helpers.bat :FileHashCheck sha256 "!zip7_exe!" "!zip7_exe_sha256!" || exit /B %ERRORLEVEL%

REM Terminal
echo set PATH=!zip7_dir!;%%PATH%%>> "!tmp_terminal_script!"

REM ----------------------------------------------------------------------------
REM GPG Signature Verification
REM ----------------------------------------------------------------------------
set gpg_w32_sha256=1a18adbb24868e14a40ccbd60003108840e238c0893e7bb6908805ae067eb0e8
set gpg_w32_exe_sha256=ac181fb744df2950880458f8e18eb005de38e5c9858d13f0f772b5ae18c6b157
set gpg_w32_version=2.3.6
set gpg_w32_date=20220425

set gpg_w32_label=gpg_win32_!gpg_w32_version!
set gpg_w32_zip=!downloads_dir!\!gpg_w32_label!.exe
set gpg_w32_dir=!tools_dir!\!gpg_w32_label!
set gpg_w32_bin_dir=!gpg_w32_dir!\bin
set gpg_w32_exe=!gpg_w32_bin_dir!\gpg.exe

if not exist "!gpg_w32_exe!" (
    call win_helpers.bat :DownloadFile "https://gnupg.org/ftp/gcrypt/binary/gnupg-w32-!gpg_w32_version!_!gpg_w32_date!.exe" "!gpg_w32_zip!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :FileHashCheck sha256 "!gpg_w32_zip!" "!gpg_w32_sha256!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :Unzip "!zip7_exe!" "!gpg_w32_zip!" "!gpg_w32_dir!" || exit /B %ERRORLEVEL%
)

call win_helpers.bat :FileHashCheck sha256 "!gpg_w32_exe!" "!gpg_w32_exe_sha256!" || exit /B %ERRORLEVEL%
set PATH="!gpg_w32_bin_dir!";!PATH!

REM Terminal
echo set PATH=!gpg_w32_bin_dir!;%%PATH%%>> "!tmp_terminal_script!"

REM ----------------------------------------------------------------------------
REM Application Setup
REM ----------------------------------------------------------------------------
REM Download & verify the tools we want for development

REM ----------------------------------------------------------------------------
REM Wezterm
REM ----------------------------------------------------------------------------
set wezterm_sha256=c634e98fa9715766bbb00cbc3c8a23d1d558c8cd5716ad2efca45ed4e0ef82f9
set wezterm_exe_sha256=b9b5bae20d0679127ca0c4da276dff3b7b32310bfbfaede26a9b8ecb55e295ce
set wezterm_version=20220408-101518-b908e2dd

set wezterm_label=wezterm_win64_!wezterm_version!
set wezterm_zip=!downloads_dir!\!wezterm_label!.zip
set wezterm_dir=!tools_dir!\!wezterm_label!
set wezterm_exe=!wezterm_dir!\wezterm-gui.exe

if not exist "!wezterm_exe!" (
    call win_helpers.bat :DownloadFile https://github.com/wez/wezterm/releases/download/!wezterm_version!/WezTerm-windows-!wezterm_version!.zip "!wezterm_zip!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :FileHashCheck sha256 "!wezterm_zip!" "!wezterm_sha256!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :Unzip "!zip7_exe!" "!wezterm_zip!" "!wezterm_dir!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :Move "!wezterm_dir!\wezterm-windows-!wezterm_version!" "!wezterm_dir!" || exit /B %ERRORLEVEL%
)

call win_helpers.bat :FileHashCheck sha256 "!wezterm_exe!" "!wezterm_exe_sha256!" || exit /B %ERRORLEVEL%
call win_helpers.bat :OverwriteCopy "!installer_dir!\os_wezterm.lua" "!wezterm_dir!\wezterm.lua" || exit /B %ERRORLEVEL%

REM ----------------------------------------------------------------------------
REM Jetbrains Mono Font
REM ----------------------------------------------------------------------------
set jetbrains_mono_sha256=4e315b4ef176ce7ffc971b14997bdc8f646e3d1e5b913d1ecba3a3b10b4a1a9f
set jetbrains_mono_file_sha256=50e1dcb40298fcfcc21a1ef3cbee9fe9e82709c48ad30ce617472c06a3bd9436
set jetbrains_mono_version=2.242

set jetbrains_mono_label=jetbrains_mono_!jetbrains_mono_version!
set jetbrains_mono_zip=!downloads_dir!\!jetbrains_mono_label!.zip
set jetbrains_mono_dir=!tools_dir!\!jetbrains_mono_label!
set jetbrains_mono_file=!jetbrains_mono_dir!\fonts\ttf\JetBrainsMono-Regular.ttf

if not exist "!jetbrains_mono_file!" (
    call win_helpers.bat :DownloadFile https://download.jetbrains.com/fonts/JetBrainsMono-!jetbrains_mono_version!.zip "!jetbrains_mono_zip!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :FileHashCheck sha256 "!jetbrains_mono_zip!" "!jetbrains_mono_sha256!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :Unzip "!zip7_exe!" "!jetbrains_mono_zip!" "!jetbrains_mono_dir!" || exit /B %ERRORLEVEL%
)

call win_helpers.bat :FileHashCheck sha256 "!jetbrains_mono_file!" "!jetbrains_mono_file_sha256!" || exit /B %ERRORLEVEL%

REM ----------------------------------------------------------------------------
REM Programming
REM ----------------------------------------------------------------------------
REM ----------------------------------------------------------------------------
REM CMake
REM ----------------------------------------------------------------------------
set cmake_sha256=9b509cc4eb7191dc128cfa3f2170036f9cbc7d9d5f93ff7fafc5b2d77b3b40dc
set cmake_exe_sha256=326ae6ce4bd46c27f6ce46c95b48efc19848fd9fc24d71d2e8a226dadfef810c
set cmake_version=3.23.1

set cmake_label=cmake_win64_!cmake_version!
set cmake_zip=!downloads_dir!\!cmake_label!.zip
set cmake_dir=!tools_dir!\!cmake_label!
set cmake_bin_dir=!cmake_dir!\bin
set cmake_exe=!cmake_dir!\bin\cmake.exe

if not exist "!cmake_exe!" (
    call win_helpers.bat :DownloadFile "https://github.com/Kitware/CMake/releases/download/v!cmake_version!/cmake-!cmake_version!-windows-x86_64.zip" "!cmake_zip!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :FileHashCheck sha256 "!cmake_zip!" "!cmake_sha256!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :Unzip "!zip7_exe!" "!cmake_zip!" "!cmake_dir!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :Move "!cmake_dir!/cmake-!cmake_version!-windows-x86_64" "!cmake_dir!" || exit /B %ERRORLEVEL%
)

call win_helpers.bat :FileHashCheck sha256 "!cmake_exe!" "!cmake_exe_sha256!" || exit /B %ERRORLEVEL%
echo set PATH=!cmake_bin_dir!;%%PATH%%>> "!tmp_terminal_script!"

REM ----------------------------------------------------------------------------
REM ctags
REM ----------------------------------------------------------------------------
set ctags_sha256=B82648E9A3B2C8E50E0283A47B4F013F1B52E0F0E56DBB4F1C805D17578C4DF2
set ctags_exe_sha256=7465E2D34EAF5F901AC45D7E9ED4AC8E7D3A532964D0D77A94F2D0EE3AE145AA
set ctags_version=p5.9.20220612.0

set ctags_label=ctags_win64_!ctags_version!
set ctags_zip=!downloads_dir!\!ctags_label!.zip
set ctags_dir=!tools_dir!\!ctags_label!
set ctags_exe=!ctags_dir!\ctags.exe

if not exist "!ctags_exe!" (
    call win_helpers.bat :DownloadFile "https://github.com/universal-ctags/ctags-win32/releases/download/!ctags_version!/ctags-!ctags_version!-x64.zip" "!ctags_zip!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :FileHashCheck sha256 "!ctags_zip!" "!ctags_sha256!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :Unzip "!zip7_exe!" "!ctags_zip!" "!ctags_dir!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :Move "!ctags_dir!/ctags-!ctags_version!-windows-x86_64" "!ctags_dir!" || exit /B %ERRORLEVEL%
)
call win_helpers.bat :FileHashCheck sha256 "!ctags_exe!" "!ctags_exe_sha256!" || exit /B %ERRORLEVEL%
call win_helpers.bat :MakeBatchShortcut "ctags" "!ctags_exe!" "!bin_dir!" || exit /B %ERRORLEVEL%

REM ----------------------------------------------------------------------------
REM Git
REM ----------------------------------------------------------------------------
set git_sha256=bc030848e282d49e562ae2392a72501cf539322ad06ffe4cea8cf766f148dfe8
set git_exe_sha256=ae463cad04c2b15fc91de68ab096933ec08c44752e205aebd7d64c3a482df62d
set git_version=2.33.0

set git_label=PortableGit_win64_!git_version!
set git_zip=!downloads_dir!\!git_label!.7z.exe
REM Do *NOT* use an environment variable named git_dir as this will conflict
REM with git reading it as the directory to base off all git operations.
set git_install_dir=!tools_dir!\!git_label!
set git_exe=!git_install_dir!\cmd\git.exe

if not exist "!git_exe!" (
    call win_helpers.bat :DownloadFile "https://github.com/git-for-windows/git/releases/download/v!git_version!.windows.2/PortableGit-!git_version!.2-64-bit.7z.exe" "!git_zip!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :FileHashCheck sha256 "!git_zip!" "!git_sha256!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :Unzip "!zip7_exe!" "!git_zip!" "!git_install_dir!" || exit /B %ERRORLEVEL%
)

call win_helpers.bat :FileHashCheck sha256 "!git_exe!" "!git_exe_sha256!" || exit /B %ERRORLEVEL%

REM Terminal
echo set PATH=!git_install_dir!\cmd;%%PATH%%>> "!tmp_terminal_script!"
echo set PATH=!git_install_dir!\mingw64\bin;%%PATH%%>> "!tmp_terminal_script!"
echo set PATH=!git_install_dir!\usr\bin;%%PATH%%>> "!tmp_terminal_script!"

REM ----------------------------------------------------------------------------
REM LLVM/Clang
REM ----------------------------------------------------------------------------
REM NOTE: This list must be in descending order, latest version at the top. This
REM ensures the latest version is processed last and some variables rely on
REM this.
set llvm_version_list=14.0.6 !llvm_version_list!
set llvm_version_list=13.0.1 !llvm_version_list!
set llvm_version_list=12.0.1 !llvm_version_list!
set llvm_version_list=11.1.0 !llvm_version_list!

for %%a in (%llvm_version_list%) do (
    set llvm_version=%%a
    set llvm_exe_sha256=none

    if "!llvm_version!"=="14.0.6" set llvm_exe_sha256=D557B79BC09A01141AC7D940016F52CE1DB081E31D7968F0D9B6F4C192D8F8CC
    if "!llvm_version!"=="13.0.1" set llvm_exe_sha256=E3F26820AC446CB7C471CCE49F6646B4346AA5380D11790CEAA7BF494A94B21D
    if "!llvm_version!"=="12.0.1" set llvm_exe_sha256=9f0748de7f946c210a030452de226986bab46a0121d7236ea0e7b5079cb6dfef
    if "!llvm_version!"=="11.1.0" set llvm_exe_sha256=F72591F8A02E4B7573AA2FCD2999A3EA76FE729E2468E5414853617268798DFD

    set llvm_label=llvm_win64_!llvm_version!
    set llvm_zip=!downloads_dir!\!llvm_label!.exe
    set llvm_dir=!tools_dir!\!llvm_label!
    set llvm_bin_dir=!llvm_dir!\bin
    set llvm_exe=!llvm_bin_dir!\clang.exe

    set llvm_gpg_key=!downloads_dir!\llvm_tstellar_gpg_key.asc
    set llvm_gpg_sig=!llvm_zip!.sig

    if not exist "!llvm_exe!" (
        call win_helpers.bat :DownloadFile "https://github.com/llvm/llvm-project/releases/download/llvmorg-9.0.1/tstellar-gpg-key.asc" "!llvm_gpg_key!" || exit /B %ERRORLEVEL%
        call win_helpers.bat :DownloadFile "https://github.com/llvm/llvm-project/releases/download/llvmorg-!llvm_version!/LLVM-!llvm_version!-win64.exe" "!llvm_zip!" || exit /B %ERRORLEVEL%

        REM Version 14.0.5 doesn't ship with signatures?
        REM call win_helpers.bat :DownloadFile "https://github.com/llvm/llvm-project/releases/download/llvmorg-!llvm_version!/LLVM-!llvm_version!-win64.exe.sig" "!llvm_gpg_sig!" || exit /B %ERRORLEVEL%
        REM gpg --import "!llvm_gpg_key!" || exit /B %ERRORLEVEL%
        REM gpg --verify "!llvm_gpg_sig!" "!llvm_zip!" || exit /B %ERRORLEVEL%

        call win_helpers.bat :Unzip "!zip7_exe!" "!llvm_zip!" "!llvm_dir!" || exit /B %ERRORLEVEL%
    )

    call win_helpers.bat :FileHashCheck sha256 "!llvm_exe!" "!llvm_exe_sha256!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :MakeBatchShortcut "clang-!llvm_version!" "!llvm_bin_dir!\clang.exe" "!bin_dir!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :MakeBatchShortcut "clang++-!llvm_version!" "!llvm_bin_dir!\clang++.exe" "!bin_dir!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :MakeBatchShortcut "clang-cl-!llvm_version!" "!llvm_bin_dir!\clang-cl.exe" "!bin_dir!" || exit /B %ERRORLEVEL%
)

REM Clang Format
set clang_format=!home_dir!\clang-format.py
call win_helpers.bat :OverwriteCopy "!llvm_dir!\share\clang\clang-format.py" "!clang_format!" || exit /B %ERRORLEVEL%

REM Terminal
echo set PATH=!llvm_bin_dir!;%%PATH%%>> "!tmp_terminal_script!"

REM ------------------------------------------------------------------------
REM MinGW64
REM ------------------------------------------------------------------------
set mingw_sha256=853970527b5de4a55ec8ca4d3fd732c00ae1c69974cc930c82604396d43e79f8
set mingw_exe_sha256=c5f0953f7a71ddcdf0852e1e44a43cef9b8fe121beba4d4202bfe6d405de47c0
set mingw_version=8.1.0

set mingw_label=mingw64-posix-seg-rt_v6-rev0_win64_!mingw_version!
set mingw_zip=!downloads_dir!\!mingw_label!.7z
set mingw_dir=!tools_dir!\!mingw_label!
set mingw_bin_dir=!mingw_dir!\bin
set mingw_exe=!mingw_bin_dir!\gcc.exe

if not exist "!mingw_exe!" (
    call win_helpers.bat :DownloadFile \"https://sourceforge.net/projects/mingw-w64/files/Toolchains targetting Win64/Personal Builds/mingw-builds/!mingw_version!/threads-posix/seh/x86_64-!mingw_version!-release-posix-seh-rt_v6-rev0.7z\" !mingw_zip! || exit /B %ERRORLEVEL%
    call win_helpers.bat :FileHashCheck sha256 !mingw_zip! !mingw_sha256! || exit /B %ERRORLEVEL%
    call win_helpers.bat :Unzip "!zip7_exe!" !mingw_zip! !mingw_dir! || exit /B %ERRORLEVEL%
    call win_helpers.bat :Move !mingw_dir!\mingw64 !mingw_dir! || exit /B %ERRORLEVEL%
)

call win_helpers.bat :FileHashCheck sha256 "!mingw_exe!" "!mingw_exe_sha256!" || exit /B %ERRORLEVEL%

REM Terminal
echo set PATH=!mingw_bin_dir!;%%PATH%%>> "!tmp_terminal_script!"

REM ----------------------------------------------------------------------------
REM ninja
REM ----------------------------------------------------------------------------
set ninja_sha256=bbde850d247d2737c5764c927d1071cbb1f1957dcabda4a130fa8547c12c695f
set ninja_exe_sha256=6a71c03f88897419f19548a8eadd941ed94144bb671be289822080f991c1ab79
set ninja_version=1.10.2

set ninja_label=ninja_win64_!ninja_version!
set ninja_zip=!downloads_dir!\!ninja_label!.zip
set ninja_dir=!tools_dir!\!ninja_label!
set ninja_exe=!ninja_dir!\ninja.exe

if not exist "!ninja_exe!" (
    call win_helpers.bat :DownloadFile "https://github.com/ninja-build/ninja/releases/download/v!ninja_version!/ninja-win.zip" "!ninja_zip!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :FileHashCheck sha256 "!ninja_zip!" "!ninja_sha256!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :Unzip "!zip7_exe!" "!ninja_zip!" "!ninja_dir!" || exit /B %ERRORLEVEL%
)

call win_helpers.bat :FileHashCheck sha256 "!ninja_exe!" "!ninja_exe_sha256!" || exit /B %ERRORLEVEL%
call win_helpers.bat :MakeBatchShortcut "ninja" "!ninja_exe!" "!bin_dir!" || exit /B %ERRORLEVEL%

REM ----------------------------------------------------------------------------
REM nodejs
REM ----------------------------------------------------------------------------
set nodejs_sha256=f7b0e8b0bfcfad7d62eba16fa4db9f085983c12c661bd4c66d8e3bd783befa65
set nodejs_exe_sha256=7f33cbe04cb2940427e6dd97867c1fcf3ddd60911d2ae0260da3cab9f6ea6365
set nodejs_version=16.7.0

set nodejs_label=nodejs_win64_!nodejs_version!
set nodejs_zip=!downloads_dir!\!nodejs_label!.7z
set nodejs_dir=!tools_dir!\!nodejs_label!
set nodejs_exe=!nodejs_dir!\node.exe

if not exist "!nodejs_exe!" (
    call win_helpers.bat :DownloadFile "https://nodejs.org/dist/v!nodejs_version!/node-v!nodejs_version!-win-x64.7z" "!nodejs_zip!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :FileHashCheck sha256 "!nodejs_zip!" "!nodejs_sha256!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :Unzip "!zip7_exe!" "!nodejs_zip!" "!nodejs_dir!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :Move "!nodejs_dir!\node-v!nodejs_version!-win-x64" "!nodejs_dir!" || exit /B %ERRORLEVEL%
)

call win_helpers.bat :FileHashCheck sha256 "!nodejs_exe!" "!nodejs_exe_sha256!" || exit /B %ERRORLEVEL%

REM Terminal
echo set PATH=!nodejs_dir!;%%PATH%%>> "!tmp_terminal_script!"

REM ----------------------------------------------------------------------------
REM Python
REM ----------------------------------------------------------------------------
set python_sha256=93cc3db75dffb4d56b9f64af43294f130f2c222a66de7a1325d0ce8f1ed62e26
set python_exe_sha256=9042daa88b2d3879a51bfabc2d90d4a56da05ebf184b6492a22a46fdc1c936a4
set python_version=3.9.0.2dot
set python_version_nodot=3902
set python_version_dot=3.9.0

set python_label=Winpython64_win64_!python_version_nodot!
set python_zip=!downloads_dir!\!python_label!.zip
set python_dir=!tools_dir!\!python_label!
set python_bin_dir=!python_dir!\python-!python_version_dot!.amd64\
set python_exe=!python_bin_dir!\python.exe

if not exist "!python_exe!" (
    call win_helpers.bat :DownloadFile "https://github.com/winpython/winpython/releases/download/3.0.20201028/Winpython64-!python_version!.exe" "!python_zip!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :FileHashCheck sha256 "!python_zip!" "!python_sha256!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :Unzip "!zip7_exe!" "!python_zip!" "!python_dir!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :Move "!python_dir!\WPy64-!python_version_nodot!" "!python_dir!" || exit /B %ERRORLEVEL%
)

call win_helpers.bat :FileHashCheck sha256 "!python_exe!" "!python_exe_sha256!" || exit /B %ERRORLEVEL%

set python_bin_dir=!python_dir!\python-!python_version_dot!.amd64
set python_scripts_bin_dir=!python_bin_dir!\Scripts

REM Terminal
echo set PATH=!python_bin_dir!;%%PATH%%>> "!tmp_terminal_script!"
echo set PATH=!python_scripts_bin_dir!;%%PATH%%>> "!tmp_terminal_script!"
echo set PYTHONHOME=!python_bin_dir!>> "!tmp_terminal_script!"

REM ----------------------------------------------------------------------------
REM RenderDoc
REM ----------------------------------------------------------------------------
set renderdoc_sha256=ed1c1228b8fc30e53d3560dbae9d7bf47b85e0e15e30e6f3e4f36173a74f77bc
set renderdoc_exe_sha256=3b4874f1677f08e4c329696eaa8281b7ee86b16ad5679932a72085a3e7abc658
set renderdoc_version=1.19

set renderdoc_label=renderdoc_win64_!renderdoc_version!
set renderdoc_zip=!downloads_dir!\!renderdoc_label!.zip
set renderdoc_dir=!tools_dir!\!renderdoc_label!
set renderdoc_exe=!renderdoc_dir!\qrenderdoc.exe

if not exist "!renderdoc_exe!" (
    call win_helpers.bat :DownloadFile "https://renderdoc.org/stable/!renderdoc_version!/RenderDoc_!renderdoc_version!_64.zip" "!renderdoc_zip!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :FileHashCheck sha256 "!renderdoc_zip!" "!renderdoc_sha256!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :Unzip "!zip7_exe!" "!renderdoc_zip!" "!renderdoc_dir!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :Move "!renderdoc_dir!\RenderDoc_!renderdoc_version!_64" "!renderdoc_dir!" || exit /B %ERRORLEVEL%
)

call win_helpers.bat :FileHashCheck sha256 "!renderdoc_exe!" "!renderdoc_exe_sha256!" || exit /B %ERRORLEVEL%

REM ----------------------------------------------------------------------------
REM Zeal
REM ----------------------------------------------------------------------------
set zeal_sha256=08e9992f620ba0a5ea348471d8ac9c85059e95eedd950118928be639746e3f94
set zeal_exe_sha256=d1e687a33e117b6319210f40e2401b4a68ffeb0f33ef82f5fb6a31ce4514a423
set zeal_version=0.6.1

set zeal_label=zeal_win64_!zeal_version!
set zeal_zip=!downloads_dir!\!zeal_label!.7z
set zeal_dir=!tools_dir!\!zeal_label!
set zeal_exe=!zeal_dir!\zeal.exe

if not exist "!zeal_exe!" (
    call win_helpers.bat :DownloadFile "https://github.com/zealdocs/zeal/releases/download/v!zeal_version!/zeal-portable-!zeal_version!-windows-x64.7z" "!zeal_zip!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :FileHashCheck sha256 "!zeal_zip!" "!zeal_sha256!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :Unzip "!zip7_exe!" "!zeal_zip!" "!zeal_dir!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :Move "!zeal_dir!\zeal-portable-!zeal_version!-windows-x64" "!zeal_dir!" || exit /B %ERRORLEVEL%
)

call win_helpers.bat :FileHashCheck sha256 "!zeal_exe!" "!zeal_exe_sha256!" || exit /B %ERRORLEVEL%

REM ----------------------------------------------------------------------------
REM Zig
REM ----------------------------------------------------------------------------
set zig_sha256=443da53387d6ae8ba6bac4b3b90e9fef4ecbe545e1c5fa3a89485c36f5c0e3a2
set zig_exe_sha256=63c2f819cfdb1a35cb954791fc0aa48910a42065a5e1c6ff89ee16775c75a112
set zig_version=0.9.1

set zig_label=zig_win64_!zig_version!
set zig_zip=!downloads_dir!\!zig_label!.zip
set zig_dir=!tools_dir!\!zig_label!
set zig_exe=!zig_dir!\zig.exe

if not exist "!zig_exe!" (
    call win_helpers.bat :DownloadFile "https://ziglang.org/download/!zig_version!/zig-windows-x86_64-!zig_version!.zip" "!zig_zip!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :FileHashCheck sha256 "!zig_zip!" "!zig_sha256!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :Unzip "!zip7_exe!" "!zig_zip!" "!zig_dir!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :Move "!zig_dir!\zig-windows-x86_64-!zig_version!" "!zig_dir!" || exit /B %ERRORLEVEL%
)

call win_helpers.bat :FileHashCheck sha256 "!zig_exe!" "!zig_exe_sha256!" || exit /B %ERRORLEVEL%
call win_helpers.bat :MakeBatchShortcut "zig" "!zig_exe!" "!bin_dir!" || exit /B %ERRORLEVEL%
call win_helpers.bat :MakeBatchShortcut "zig-!zig_version!" "!zig_exe!" "!bin_dir!" || exit /B %ERRORLEVEL%

REM ----------------------------------------------------------------------------
REM MSVC
REM ----------------------------------------------------------------------------
REM This depends on python, so it must be installed after it.
set msvc_version=14.32
set msvc_sdk_version=22621
set msvc_dir=!tools_dir!\msvc_win64_!msvc_version!_win10_sdk_!msvc_sdk_version!
if not exist "!msvc_dir!" (
    call "!python_exe!" !installer_dir!\win_portable-msvc.py --accept-license --msvc-version !msvc_version! --sdk-version !msvc_sdk_version! || exit /B %ERRORLEVEL%
    call win_helpers.bat :Move "msvc" "!msvc_dir!" || exit /B %ERRORLEVEL%
)

REM Put the compiler into the path temporarily for compiling some programs on
REM demand in this script.
call !msvc_dir!\setup.bat

REM Terminal
echo call "!msvc_dir!\setup.bat">> "!tmp_terminal_script!"

REM ----------------------------------------------------------------------------
REM Symget
REM ----------------------------------------------------------------------------
REM set symget_dir=!tools_dir!\symget
REM if not exist "!symget_dir!" (
REM     call !git_exe! clone https://github.com/mmozeiko/symget.git !symget_dir! || exit /B %ERRORLEVEL%
REM )
REM
REM call !git_exe! -C !symget_dir! pull origin main || exit /B %ERRORLEVEL%
REM call !git_exe! -C !symget_dir! checkout 79b026f || exit /B %ERRORLEVEL%

REM ----------------------------------------------------------------------------
REM Odin
REM ----------------------------------------------------------------------------
set odin_git_hash=a4cb6f96
set odin_dir=!tools_dir!\odin_win64
set odin_exe=!odin_dir!\odin.exe

if not exist "!odin_dir!" (
    call !git_exe! clone https://github.com/odin-lang/odin.git !odin_dir! || exit /B %ERRORLEVEL%
)

REM Extract current git hash of the repository. Remove the last character as
REM rev-parse has a trailing whitespace.
for /F "tokens=1 USEBACKQ" %%F IN (`"!git_exe!" -C !odin_dir! rev-parse --short HEAD`) do ( SET odin_curr_git_hash=%%F )
set odin_curr_git_hash=!odin_curr_git_hash:~0,-1!

if !odin_curr_git_hash! neq !odin_git_hash! (
    call !git_exe! -C !odin_dir! pull origin master || exit /B %ERRORLEVEL%
    call !git_exe! -C !odin_dir! checkout !odin_git_hash! || exit /B %ERRORLEVEL%
)

if not exist "!odin_exe!" (
    pushd !odin_dir!
    call build.bat
    popd
)

call win_helpers.bat :MakeBatchShortcut "odin" "!odin_exe!" "!bin_dir!" || exit /B %ERRORLEVEL%

REM ----------------------------------------------------------------------------
REM QoL/Tools
REM ----------------------------------------------------------------------------
REM ----------------------------------------------------------------------------
REM clink - Bash style tab completion in terminal
REM ----------------------------------------------------------------------------
set clink_sha256=00A516A9D072E46ADF381156703E54CDF086A1F078D006971E6D96DFA0186881
set clink_exe_sha256=7448FD3BE1CB698A154AAA9F2EB27146B81EE266F27BFE993B342C22C25E520A
set clink_version=1.3.35
set clink_git_hash=5e327d

set clink_label=clink_win64_!clink_version!
set clink_zip=!downloads_dir!\!clink_label!.zip
set clink_dir=!tools_dir!\!clink_label!
set clink_exe=!clink_dir!\clink_x64.exe
set clink_bat=!clink_dir!\clink.bat

if not exist "!clink_exe!" (
    call win_helpers.bat :DownloadFile "https://github.com/chrisant996/clink/releases/download/v!clink_version!/clink.!clink_version!.!clink_git_hash!.zip" "!clink_zip!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :FileHashCheck sha256 "!clink_zip!" "!clink_sha256!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :Unzip "!zip7_exe!" "!clink_zip!" "!clink_dir!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :OverwriteCopy "!clink_dir!\_default_inputrc" "!clink_dir!\default_inputrc" || exit /B %ERRORLEVEL%
    call win_helpers.bat :OverwriteCopy "!clink_dir!\_default_settings" "!clink_dir!\default_settings" || exit /B %ERRORLEVEL%
)

call win_helpers.bat :FileHashCheck sha256 "!clink_exe!" "!clink_exe_sha256!" || exit /B %ERRORLEVEL%
call win_helpers.bat :MakeBatchShortcut "clink" "!clink_bat!" "!bin_dir!" || exit /B %ERRORLEVEL%

REM Clink Completion Addon
set clink_completions_dir=!tools_dir!\clink-completions
if not exist "!clink_completions_dir!" (
    call !git_exe! clone https://github.com/vladimir-kotikov/clink-completions !clink_completions_dir! || exit /B %ERRORLEVEL%
)
call !git_exe! -C !clink_completions_dir! pull origin master || exit /B %ERRORLEVEL%
call !git_exe! -C !clink_completions_dir! checkout 9ab9342 || exit /B %ERRORLEVEL%

REM Terminal Script
echo set CLINK_PATH=!clink_completions_dir!>> "!tmp_terminal_script!

REM ----------------------------------------------------------------------------
REM Dependencies (Walker) - For DLL dependency management
REM ----------------------------------------------------------------------------
set dependencies_sha256=7d22dc00f1c09fd4415d48ad74d1cf801893e83b9a39944b0fce6dea7ceaea99
set dependencies_exe_sha256=1737e5406128c3560bbb2bced3ac62d77998e592444f94b10cc0aa0bb1e617e6
set dependencies_version=1.11.1

set dependencies_label=dependencies_win64_!dependencies_version!
set dependencies_zip=!downloads_dir!\!dependencies_label!.zip
set dependencies_dir=!tools_dir!\!dependencies_label!
set dependencies_exe=!dependencies_dir!\DependenciesGui.exe

if not exist "!dependencies_exe!" (
    call win_helpers.bat :DownloadFile "https://github.com/lucasg/Dependencies/releases/download/v!dependencies_version!/Dependencies_x64_Release.zip" "!dependencies_zip!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :FileHashCheck sha256 "!dependencies_zip!" "!dependencies_sha256!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :Unzip "!zip7_exe!" "!dependencies_zip!" "!dependencies_dir!" || exit /B %ERRORLEVEL%
)

call win_helpers.bat :FileHashCheck sha256 "!dependencies_exe!" "!dependencies_exe_sha256!" || exit /B %ERRORLEVEL%

REM ----------------------------------------------------------------------------
REM everything (void tools search program)
REM ----------------------------------------------------------------------------
set everything_sha256=656ff3946222048a5558160023da6fd8abc6fa9569f7ac1dff058410a3db6f28
set everything_exe_sha256=8f853443c0b0e8c144315a27d1e8bf1595bd09cb364393226accfe105c0a2c85
set everything_version=1.4.1.1015

set everything_label=everything_win64_!everything_version!
set everything_zip=!downloads_dir!\!everything_label!.zip
set everything_dir=!tools_dir!\!everything_label!
set everything_exe=!everything_dir!\everything.exe

if not exist "!everything_exe!" (
    call win_helpers.bat :DownloadFile "https://www.voidtools.com/Everything-!everything_version!.x64.zip" "!everything_zip!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :FileHashCheck sha256 "!everything_zip!" "!everything_sha256!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :Unzip "!zip7_exe!" "!everything_zip!" "!everything_dir!" || exit /B %ERRORLEVEL%
)

call win_helpers.bat :FileHashCheck sha256 "!everything_exe!" "!everything_exe_sha256!" || exit /B %ERRORLEVEL%

REM ----------------------------------------------------------------------------
REM fzf
REM ----------------------------------------------------------------------------
set fzf_sha256=AB0ED3255564DF1A6643FF492EBC728C25F3DF9EAA5C11AC7A28CF661667412F
set fzf_exe_sha256=C41293D9E632C5A3604AD863389C0BEC7AC2AD1E3C1F51B60EA2271A63BBB3D2
set fzf_version=0.30.0

set fzf_label=fzf_win64_!fzf_version!
set fzf_zip=!downloads_dir!\!fzf_label!.zip
set fzf_dir=!tools_dir!
set fzf_exe=!fzf_dir!\fzf_win64_!fzf_version!.exe

if not exist "!fzf_exe!" (
    call win_helpers.bat :DownloadFile "https://github.com/junegunn/fzf/releases/download/!fzf_version!/fzf-!fzf_version!-windows_amd64.zip" "!fzf_zip!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :FileHashCheck sha256 "!fzf_zip!" "!fzf_sha256!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :Unzip "!zip7_exe!" "!fzf_zip!" "!fzf_dir!" || exit /B %ERRORLEVEL%
    move /Y "!fzf_dir!\fzf.exe" "!fzf_exe!" 1>NUL || exit /B %ERRORLEVEL%
)

call win_helpers.bat :FileHashCheck sha256 "!fzf_exe!" "!fzf_exe_sha256!" || exit /B %ERRORLEVEL%
call win_helpers.bat :MakeBatchShortcut "fzf" "!fzf_exe!" "!bin_dir!" || exit /B %ERRORLEVEL%

REM Terminal
REM Use FD for FZF to make it ultra fast
echo set FZF_DEFAULT_OPTS=--multi --layout=reverse>> "!tmp_terminal_script!"
echo set FZF_DEFAULT_COMMAND=fd --unrestricted>> "!tmp_terminal_script!"

REM ----------------------------------------------------------------------------
REM NVIM
REM ----------------------------------------------------------------------------
set nvim_sha256=a72a90e2897ea296b777c325a37c981a0b51e2fe0c8b8735e3366b65e958cddc
set nvim_exe_sha256=E2B9B9C38EE169475EEAE4501278A36A93C7A4F08F6E5379CA65A166041B8DA8
set nvim_version=0.7.0

set nvim_label=nvim_win64_!nvim_version!
set nvim_zip=!downloads_dir!\!nvim_label!.zip
set nvim_dir=!tools_dir!\!nvim_label!
set nvim_exe=!nvim_dir!\bin\nvim.exe

if not exist "!nvim_exe!" (
    call win_helpers.bat :DownloadFile "https://github.com/neovim/neovim/releases/download/v!nvim_version!/nvim-win64.zip" "!nvim_zip!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :FileHashCheck sha256 "!nvim_zip!" "!nvim_sha256!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :Unzip "!zip7_exe!" "!nvim_zip!" "!nvim_dir!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :Move "!nvim_dir!\nvim-win64" "!nvim_dir!" || exit /B %ERRORLEVEL%
)

call win_helpers.bat :FileHashCheck sha256 "!nvim_exe!" "!nvim_exe_sha256!" || exit /B %ERRORLEVEL%
call win_helpers.bat :MakeBatchShortcut "nvim" "!nvim_exe!" "!bin_dir!" || exit /B %ERRORLEVEL%
call win_helpers.bat :MakeBatchShortcut "nvim-qt" "!nvim_dir!\bin\nvim-qt.exe" "!bin_dir!" || exit /B %ERRORLEVEL%

REM ----------------------------------------------------------------------------
REM Neovide
REM ----------------------------------------------------------------------------
set neovide_sha256=D1DE20E0FCBF68CB4D85CD6F15691DFB77848DAFB97519F8E67E3036A2A7927D
set neovide_exe_sha256=C0F6ED7ED8BAC4EE910267FA785DA698A581004EA45838BE401E3FBA18DD3234
set neovide_version=0.9.0

set neovide_label=neovide_win64_!neovide_version!
set neovide_zip=!downloads_dir!\!neovide_label!.zip
set neovide_dir=!tools_dir!\!neovide_label!
set neovide_exe=!neovide_dir!\neovide.exe

if not exist "!neovide_exe!" (
    call win_helpers.bat :DownloadFile "https://github.com/neovide/neovide/releases/download/!neovide_version!/neovide-windows.zip" "!neovide_zip!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :FileHashCheck sha256 "!neovide_zip!" "!neovide_sha256!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :Unzip "!zip7_exe!" "!neovide_zip!" "!neovide_dir!" || exit /B %ERRORLEVEL%
)

call win_helpers.bat :FileHashCheck sha256 "!neovide_exe!" "!neovide_exe_sha256!" || exit /B %ERRORLEVEL%
call win_helpers.bat :MakeBatchShortcut "neovide" "!neovide_exe!" "!bin_dir!" || exit /B %ERRORLEVEL%

REM Vim Configuration
REM ----------------------------------------------------------------------------
REM Nvim Config
set nvim_init_dir=!home_dir!\AppData\Local\nvim
if not exist "!nvim_init_dir!" mkdir "!nvim_init_dir!"
call win_helpers.bat :OverwriteCopy "!installer_dir!\os_nvim_init.vim" "!nvim_init_dir!\init.vim"

REM Vim Package Manager
set vim_plug_dir=!nvim_init_dir!\autoload
set vim_plug=!vim_plug_dir!\plug.vim
if not exist "!vim_plug_dir!" mkdir "!vim_plug_dir!"
call win_helpers.bat :DownloadFile "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" "!vim_plug!" || exit /B %ERRORLEVEL%

REM Install Python NVIM module, for :py3 support
set PYTHONHOME=!python_bin_dir!
!python_bin_dir!\Scripts\pip.exe install pynvim cmake-language-server

REM ----------------------------------------------------------------------------
REM ImHex
REM ----------------------------------------------------------------------------
set imhex_sha256=080f537d3ea58c002cc2112adbec1352144710b43764de9a1dc04f129d3a3343
set imhex_exe_sha256=6a4b0e70bf7c78af074af0de2346164d9f5aec28ea224f9ee903412e1c774d95
set imhex_version=1.17.0

set imhex_label=imhex_win64_!imhex_version!
set imhex_zip=!downloads_dir!\!imhex_label!.zip
set imhex_dir=!tools_dir!\!imhex_label!
set imhex_exe=!imhex_dir!\imhex.exe

if not exist "!imhex_exe!" (
    call win_helpers.bat :DownloadFile "https://github.com/WerWolv/ImHex/releases/download/v!imhex_version!/Windows.Portable.ZIP.zip" "!imhex_zip!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :FileHashCheck sha256 "!imhex_zip!" "!imhex_sha256!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :Unzip "!zip7_exe!" "!imhex_zip!" "!imhex_dir!" || exit /B %ERRORLEVEL%
)

call win_helpers.bat :FileHashCheck sha256 "!imhex_exe!" "!imhex_exe_sha256!" || exit /B %ERRORLEVEL%

REM ----------------------------------------------------------------------------
REM Keypirinha
REM ----------------------------------------------------------------------------
set keypirinha_sha256=d109a16e6a5cf311abf6d06bbe5b1be3b9ba323b79c32a168628189e10f102a5
set keypirinha_exe_sha256=2d3adb36a04e9fdf94636c9ac5d4c2b754accbfaecd81f4ee7189c3c0edc8af1
set keypirinha_version=2.26

set keypirinha_label=keypirinha_win64_!keypirinha_version!
set keypirinha_zip=!downloads_dir!\!keypirinha_label!.7z
set keypirinha_dir=!tools_dir!\!keypirinha_label!
set keypirinha_exe=!keypirinha_dir!\keypirinha.exe

if not exist "!keypirinha_exe!" (
    call win_helpers.bat :DownloadFile "https://github.com/Keypirinha/Keypirinha/releases/download/v!keypirinha_version!/keypirinha-!keypirinha_version!-x64-portable.7z" "!keypirinha_zip!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :FileHashCheck sha256 "!keypirinha_zip!" "!keypirinha_sha256!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :Unzip "!zip7_exe!" "!keypirinha_zip!" "!keypirinha_dir!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :Move "!keypirinha_dir!\keypirinha" "!keypirinha_dir!" || exit /B %ERRORLEVEL%
)

call win_helpers.bat :FileHashCheck sha256 "!keypirinha_exe!" "!keypirinha_exe_sha256!" || exit /B %ERRORLEVEL%

REM ----------------------------------------------------------------------------
REM Misc Tools
REM ----------------------------------------------------------------------------
REM ctags: C/C++ code annotation generator
REM scanmapset: Bind capslock to escape via registry
REM uncap: Bind capslock to escape via run-time program
call win_helpers.bat :OverwriteCopy "!installer_dir!\win_clang_merge_compilation_command_files.bat" "!bin_dir!\clang_merge_compilation_command_files.bat" || exit /B %ERRORLEVEL%
call win_helpers.bat :OverwriteCopy "!installer_dir!\win_scanmapset.exe"                            "!bin_dir!\scanmapset.exe" || exit /B %ERRORLEVEL%
call win_helpers.bat :OverwriteCopy "!installer_dir!\win_uncap.exe"                                 "!bin_dir!\uncap.exe" || exit /B %ERRORLEVEL%
call win_helpers.bat :OverwriteCopy "!installer_dir!\os_clang_format_style_file"                    "!home_dir!\_clang-format" || exit /B %ERRORLEVEL%

REM ------------------------------------------------------------------------
REM MobaXTerm
REM ------------------------------------------------------------------------
set mobaxterm_sha256=91f80537f12c2ad34a5eba99a285c149781c6d35a144a965ce3aea8a9bc6868c
set mobaxterm_exe_sha256=1053c81b44018d6e6519a9c80d7413f7bb36e9f6e43b3da619b2229aa362a522
set mobaxterm_version=21.2

set mobaxterm_label=mobaxterm_win64_!mobaxterm_version!
set mobaxterm_zip=!downloads_dir!\!mobaxterm_label!.zip
set mobaxterm_dir=!tools_dir!\!mobaxterm_label!
set mobaxterm_exe=!mobaxterm_dir!\MobaXterm_Personal_21.2.exe

if not exist "!mobaxterm_exe!" (
    call win_helpers.bat :DownloadFile "https://download.mobatek.net/2122021051924233/MobaXterm_Portable_v!mobaxterm_version!.zip" !mobaxterm_zip! || exit /B %ERRORLEVEL%
    call win_helpers.bat :FileHashCheck sha256 !mobaxterm_zip! !mobaxterm_sha256! || exit /B %ERRORLEVEL%
    call win_helpers.bat :Unzip "!zip7_exe!" !mobaxterm_zip! !mobaxterm_dir! || exit /B %ERRORLEVEL%
)

call win_helpers.bat :FileHashCheck sha256 "!mobaxterm_exe!" "!mobaxterm_exe_sha256!" || exit /B %ERRORLEVEL%

REM ----------------------------------------------------------------------------
REM O&O ShutUp10 (Privacy Tool for Windows)
REM ----------------------------------------------------------------------------
REM We don't do SHA256 here since we don't get a versioned URL, this can
REM change at a whim and it'd be painful to have to reupdate the script
REM everytime.
set oo_shutup_10_dir=!tools_dir!
set oo_shutup_10_file=!oo_shutup_10_dir!\oo_shutup_10.exe
if not exist "!oo_shutup_10_file!" (
    if not exist "!oo_shutup_10_dir!" mkdir "!oo_shutup_10_dir!"
    call win_helpers.bat :DownloadFile "https://dl5.oo-software.com/files/ooshutup10/OOSU10.exe" "!oo_shutup_10_file!" || exit /B %ERRORLEVEL%
)

REM ----------------------------------------------------------------------------
REM ProcessHacker
REM ----------------------------------------------------------------------------
set process_hacker_sha256=c662b756324c9727760b4e921459d31a30f99cf8d3f24b64f4fcb3b29a26beb4
set process_hacker_exe_sha256=22b1b8f080a41a07f23eae8ab0ad2e5f88d3c5af5d8c1cd1bb4f6856482e945c
set process_hacker_version=3.0.4861

set process_hacker_label=process_hacker_win64_!process_hacker_version!
set process_hacker_zip=!downloads_dir!\!process_hacker_label!
set process_hacker_dir=!tools_dir!\!process_hacker_label!
set process_hacker_exe=!process_hacker_dir!\64bit\ProcessHacker.exe

if not exist "!process_hacker_exe!" (
    call win_helpers.bat :DownloadFile "https://github.com/ProcessHackerRepoTool/nightly-builds-mirror/releases/download/v!process_hacker_version!/processhacker-!process_hacker_version!-bin.zip" "!process_hacker_zip!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :FileHashCheck sha256 "!process_hacker_zip!" "!process_hacker_sha256!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :Unzip "!zip7_exe!" "!process_hacker_zip!" "!process_hacker_dir!" || exit /B %ERRORLEVEL%
)

call win_helpers.bat :FileHashCheck sha256 "!process_hacker_exe!" "!process_hacker_exe_sha256!" || exit /B %ERRORLEVEL%

REM ----------------------------------------------------------------------------
REM ripgrep
REM ----------------------------------------------------------------------------
set rg_sha256=a47ace6f654c5ffa236792fc3ee3fefd9c7e88e026928b44da801acb72124aa8
set rg_exe_sha256=ab5595a4f7a6b918cece0e7e22ebc883ead6163948571419a1dd5cd3c7f37972
set rg_version=13.0.0

set rg_label=ripgrep_win64_!rg_version!
set rg_zip=!downloads_dir!\!rg_label!.zip
set rg_dir=!tools_dir!\!rg_label!
set rg_exe=!rg_dir!\rg.exe

if not exist "!rg_exe!" (
    call win_helpers.bat :DownloadFile "https://github.com/BurntSushi/ripgrep/releases/download/!rg_version!/ripgrep-!rg_version!-x86_64-pc-windows-msvc.zip" "!rg_zip!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :FileHashCheck sha256 "!rg_zip!" "!rg_sha256!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :Unzip "!zip7_exe!" "!rg_zip!" "!rg_dir!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :Move "!rg_dir!\ripgrep-!rg_version!-x86_64-pc-windows-msvc" "!rg_dir!" || exit /B %ERRORLEVEL%
)

call win_helpers.bat :FileHashCheck sha256 "!rg_exe!" "!rg_exe_sha256!" || exit /B %ERRORLEVEL%

REM Terminal
echo set PATH=!rg_dir!;%%PATH%%>> "!tmp_terminal_script!"

REM ----------------------------------------------------------------------------
REM fd
REM ----------------------------------------------------------------------------
set fd_sha256=F21BC26C1AB6BDBE4FE43F87A20C792D4ABE629AE97C6F42B25AC8A042F5521F
set fd_exe_sha256=764F31AC5B477707B51DAEC32458E4D66059BA0D17F03032B7CD0C0534703354
set fd_version=8.4.0

set fd_label=fd_win64_!fd_version!
set fd_zip=!downloads_dir!\!fd_label!.zip
set fd_dir=!tools_dir!\!fd_label!
set fd_exe=!fd_dir!\fd.exe

if not exist "!fd_exe!" (
    call win_helpers.bat :DownloadFile "https://github.com/sharkdp/fd/releases/download/v!fd_version!/fd-v!fd_version!-x86_64-pc-windows-msvc.zip" "!fd_zip!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :FileHashCheck sha256 "!fd_zip!" "!fd_sha256!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :Unzip "!zip7_exe!" "!fd_zip!" "!fd_dir!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :Move "!fd_dir!\fd-v!fd_version!-x86_64-pc-windows-msvc" "!fd_dir!" || exit /B %ERRORLEVEL%
)

call win_helpers.bat :FileHashCheck sha256 "!fd_exe!" "!fd_exe_sha256!" || exit /B %ERRORLEVEL%

REM Terminal
echo set PATH=!fd_dir!;%%PATH%%>> "!tmp_terminal_script!"

REM ----------------------------------------------------------------------------
REM Ethereum
REM ----------------------------------------------------------------------------
REM ----------------------------------------------------------------------------
REM geth
REM ----------------------------------------------------------------------------
set geth_md5=753cab189bd175d9fc6fea965ff7161b
set geth_exe_sha256=7374e1c761f27a24a1d66299935b03b46ac354b6dc5f48505178d014a56f12df
set geth_version=1.10.17-25c9b49f

set geth_label=geth_win64_!geth_version!
set geth_zip=!downloads_dir!\!geth_label!.zip
set geth_dir=!tools_dir!\!geth_label!
set geth_exe=!geth_dir!\geth.exe

set geth_gpg_key=!installer_dir!\win_geth_windows_builder_gpg_key.asc
set geth_gpg_sig=!geth_zip!.asc

if not exist "!geth_exe!" (
    call win_helpers.bat :DownloadFile "https://gethstore.blob.core.windows.net/builds/geth-windows-amd64-!geth_version!.zip" "!geth_zip!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :DownloadFile "https://gethstore.blob.core.windows.net/builds/geth-windows-amd64-!geth_version!.zip.asc" "!geth_gpg_sig!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :FileHashCheck md5 "!geth_zip!" "!geth_md5!" || exit /B %ERRORLEVEL%

    gpg --import "!geth_gpg_key!" || exit /B %ERRORLEVEL%
    gpg --verify "!geth_gpg_sig!" "!geth_zip!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :Unzip "!zip7_exe!" "!geth_zip!" "!geth_dir!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :Move "!geth_dir!\geth-windows-amd64-!geth_version!" "!geth_dir!"
)

call win_helpers.bat :FileHashCheck sha256 "!geth_exe!" "!geth_exe_sha256!" || exit /B %ERRORLEVEL%
call win_helpers.bat :MakeBatchShortcut "geth" "!geth_exe!" "!bin_dir!" || exit /B %ERRORLEVEL%

REM ----------------------------------------------------------------------------
REM remix_ide
REM ----------------------------------------------------------------------------
set remix_ide_sha256=E3736B66ECF30384B88FD4D626F788412C0117E18C4D26F2289469CD0E33752A
set remix_ide_exe_sha256=BEE0A36255D16A9888BA421D95CFC3B672265790E70AE56924E27022E8A2BA0D
set remix_ide_version=1.3.3

set remix_ide_label=remix_ide_win64_!remix_ide_version!
set remix_ide_zip=!downloads_dir!\!remix_ide_label!.zip
set remix_ide_dir=!tools_dir!\!remix_ide_label!
set remix_ide_exe=!remix_ide_dir!\Remix IDE.exe

if not exist "!remix_ide_exe!" (
    call win_helpers.bat :DownloadFile "https://github.com/ethereum/remix-desktop/releases/download/v!remix_ide_version!/Remix-IDE-!remix_ide_version!-win.zip" "!remix_ide_zip!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :FileHashCheck sha256 "!remix_ide_zip!" "!remix_ide_sha256!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :Unzip "!zip7_exe!" "!remix_ide_zip!" "!remix_ide_dir!" || exit /B %ERRORLEVEL%
)

call win_helpers.bat :FileHashCheck sha256 "!remix_ide_exe!" "!remix_ide_exe_sha256!" || exit /B %ERRORLEVEL%

REM ----------------------------------------------------------------------------
REM solidity
REM ----------------------------------------------------------------------------
set solidity_exe_sha256=70A5A7EAA9135D13BD036CA55735F489559368AF819C5810CFAF0315DF56AB53
set solidity_version=0.8.14

set solidity_label=solidity_win64_!solidity_version!
set solidity_dir=!tools_dir!
set solidity_exe=!solidity_dir!\!solidity_label!.exe

if not exist "!solidity_exe!" (
    if not exist "!solidity_dir!" mkdir "!solidity_dir!"
    call win_helpers.bat :DownloadFile "https://github.com/ethereum/solidity/releases/download/v!solidity_version!/solc-windows.exe" "!solidity_exe!" || exit /B %ERRORLEVEL%
)

call win_helpers.bat :FileHashCheck sha256 "!solidity_exe!" "!solidity_exe_sha256!" || exit /B %ERRORLEVEL%
call win_helpers.bat :MakeBatchShortcut "solc" "!solidity_exe!" "!bin_dir!" || exit /B %ERRORLEVEL%
call win_helpers.bat :MakeBatchShortcut "solc-!solidity_version!" "!solidity_exe!" "!bin_dir!" || exit /B %ERRORLEVEL%

REM ----------------------------------------------------------------------------
REM Finish Terminal Script
REM ----------------------------------------------------------------------------
echo if exist "!tools_dir!\win_terminal_user_config.bat" call "!tools_dir!\win_terminal_user_config.bat">> "!tmp_terminal_script!"
echo start "" /MAX "!wezterm_exe!">> "!tmp_terminal_script!"
echo exit>> "!tmp_terminal_script!"
move /Y !tmp_terminal_script! !terminal_script!

REM ----------------------------------------------------------------------------
REM Odin & Portable MSVC Work-around
REM ----------------------------------------------------------------------------
REM Odin uses J. Blow's Microsoft craziness SDK locator which relies on the
REM registry. Here we inject the registry entry that the SDK locator checks for
REM finding our portable MSVC installation.
set odin_install_workaround_script=!tools_dir!\win_install_odin_msvc_workaround.reg
set odin_uninstall_workaround_script=!tools_dir!\win_uninstall_odin_msvc_workaround.reg

set kits_root_10=%msvc_dir%\Windows Kits\10\
set kits_root_10=%kits_root_10:\=\\%

echo Windows Registry Editor Version 5.00>!odin_install_workaround_script!
echo.>>!odin_install_workaround_script!
echo [HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows Kits\Installed Roots]>>!odin_install_workaround_script!
echo "KitsRoot10"="%kits_root_10%">>!odin_install_workaround_script!

echo Windows Registry Editor Version 5.00>!odin_uninstall_workaround_script!
echo.>>!odin_uninstall_workaround_script!
echo [HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows Kits\Installed Roots]>>!odin_uninstall_workaround_script!
echo "KitsRoot10"=->>!odin_uninstall_workaround_script!

REM ----------------------------------------------------------------------------
REM Background Application Scripts
REM ----------------------------------------------------------------------------
set bg_app_script=!tools_dir!\win_start_background_apps.bat
echo @echo off> "!bg_app_script!"
echo start "" "!everything_dir!\everything.exe">> "!bg_app_script!"
echo start "" "!keypirinha_dir!\keypirinha.exe">> "!bg_app_script!"

REM ----------------------------------------------------------------------------
REM CTags Helper Script
REM ----------------------------------------------------------------------------
set ctags_file=!bin_dir!\ctags_cpp.bat
echo @echo off> "!ctags_file!"
echo ctags --c++-kinds=+p --fields=+iaS --extras=+q %%*>> !ctags_file!

REM ----------------------------------------------------------------------------
REM Finish
REM ----------------------------------------------------------------------------
echo - Setup complete. Launch !tools_dir!\win_terminal.bat [or restart Wezterm instance if you're updating an existing installation]
echo - (Optional) A custom font is provided and requires manual intallation in Windows at !jetbrains_mono_file!
echo              This font will be used in GVIM if it's available.
pause
exit /B %ERRORLEVEL%
