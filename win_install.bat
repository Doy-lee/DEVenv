@echo off
setlocal EnableDelayedExpansion

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
echo set HOME=%%~dp0..\Home>> "!tmp_terminal_script!"
echo set HOMEPATH=%%~dp0..\Home>> "!tmp_terminal_script!"
echo set USERPROFILE=%%~dp0..\Home>> "!tmp_terminal_script!"
echo set APPDATA=%%~dp0..\Home\AppData>> "!tmp_terminal_script!"
echo set LOCALAPPDATA=%%~dp0..\Home\AppData\Local>> "!tmp_terminal_script!"
echo set PATH=%%~dp0Binaries;%%PATH%%>> "!tmp_terminal_script!"

REM Setup tools for setting up the development environment
REM ----------------------------------------------------------------------------
REM We are ultra pedantic and we check the hashes of the distribution but also
REM we check the hashes of the actual binary that we'll execute. This will
REM ensure that the currently installed programs in the tools folder doesn't get
REM tampered with at some point after installation.
REM
REM Unforunately, since this is not standard practice to provide by
REM distributions we have to calculate them manually.

REM Bootstrap 7zip
REM ----------------------------------------------------------------------------
REM We get an old version of 7z that is available as a .zip file which we can
REM extract on Windows with just PowerShell (i.e. no dependency).
set zip7_bootstrap_sha256=2a3afe19c180f8373fa02ff00254d5394fec0349f5804e0ad2f6067854ff28ac
set zip7_bootstrap_exe_sha256=c136b1467d669a725478a6110ebaaab3cb88a3d389dfa688e06173c066b76fcf
set zip7_bootstrap_version=920

set zip7_bootstrap_download_name=7za!zip7_bootstrap_version!
set zip7_bootstrap_download_file=!zip7_bootstrap_download_name!.zip
set zip7_bootstrap_download_path=!downloads_dir!\!zip7_bootstrap_download_file!
set zip7_bootstrap_download_url="https://www.7-zip.org/a/!zip7_bootstrap_download_file!"

set zip7_bootstrap_dir=!tools_dir!\7zip_bootstrap_win32_!zip7_bootstrap_version!
set zip7_bootstrap_exe=!zip7_bootstrap_dir!\7za.exe

if not exist "!zip7_bootstrap_exe!" (
    call win_helpers.bat :DownloadFile "!zip7_bootstrap_download_url!" "!zip7_bootstrap_download_path!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :FileHashCheck sha256 "!zip7_bootstrap_download_path!" "!zip7_bootstrap_sha256!" || exit /B %ERRORLEVEL%
)

if not exist "!zip7_bootstrap_dir!" powershell "Expand-Archive !zip7_bootstrap_download_path! -DestinationPath !zip7_bootstrap_dir!" || exit /B %ERRORLEVEL%
call win_helpers.bat :FileHashCheck sha256 "!zip7_bootstrap_exe!" "!zip7_bootstrap_exe_sha256!" || exit /B %ERRORLEVEL%

REM 7zip
REM ----------------------------------------------------------------------------
REM Use our bootstrap 7z from above to download the latest 7zip version
REM NOTE: We do not use 7za because it can not unzip a NSIS installer. The full
REM version however can.
set zip7_sha256=0b461f0a0eccfc4f39733a80d70fd1210fdd69f600fb6b657e03940a734e5fc1
set zip7_exe_sha256=ed24ed04b5d4a20b3f50fc088a455195c756d7b5315d1965e8c569472b43d939
set zip7_version=2107

set zip7_download_name=7z!zip7_version!-x64
set zip7_download_file=!zip7_download_name!.exe
set zip7_download_path=!downloads_dir!\!zip7_download_file!
set zip7_download_url="https://www.7-zip.org/a/!zip7_download_file!"

set zip7_dir_name=7zip_win64_!zip7_version!
set zip7_dir=!tools_dir!\!zip7_dir_name!
set zip7_exe=!zip7_dir!\7z.exe

if not exist "!zip7_exe!" (
    call win_helpers.bat :DownloadFile "!zip7_download_url!" "!zip7_download_path!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :FileHashCheck sha256 "!zip7_download_path!" "!zip7_sha256!" || exit /B %ERRORLEVEL%
    "!zip7_bootstrap_exe!" x -y -o"!zip7_dir!" !zip7_download_path! || exit /B %ERRORLEVEL%
)

call win_helpers.bat :FileHashCheck sha256 "!zip7_exe!" "!zip7_exe_sha256!" || exit /B %ERRORLEVEL%

REM Terminal
echo set PATH=%%~dp0!zip7_dir_name!;%%PATH%%>> "!tmp_terminal_script!"

REM GPG Signature Verification
REM ----------------------------------------------------------------------------
set gpg_w32_sha256=1a18adbb24868e14a40ccbd60003108840e238c0893e7bb6908805ae067eb0e8
set gpg_w32_exe_sha256=ac181fb744df2950880458f8e18eb005de38e5c9858d13f0f772b5ae18c6b157
set gpg_w32_version=2.3.6
set gpg_w32_date=20220425

set gpg_download_name=gnupg-w32-!gpg_w32_version!_!gpg_w32_date!
set gpg_download_file=!gpg_download_name!.exe
set gpg_download_path=!downloads_dir!\!gpg_download_file!
set gpg_download_url="https://gnupg.org/ftp/gcrypt/binary/!gpg_download_file!"

set gpg_w32_dir_name=gpg_win32_!gpg_w32_version!
set gpg_w32_dir=!tools_dir!\!gpg_w32_dir_name!
set gpg_w32_bin_dir=!gpg_w32_dir!\bin
set gpg_w32_exe=!gpg_w32_bin_dir!\gpg.exe

if not exist "!gpg_w32_exe!" (
    call win_helpers.bat :DownloadFile "!gpg_download_url!" "!gpg_w32_download_path!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :FileHashCheck sha256 "!gpg_w32_download_path!" "!gpg_w32_sha256!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :Unzip "!zip7_exe!" "!gpg_w32_download_path!" "!gpg_w32_dir!" || exit /B %ERRORLEVEL%
)

call win_helpers.bat :FileHashCheck sha256 "!gpg_w32_exe!" "!gpg_w32_exe_sha256!" || exit /B %ERRORLEVEL%
set PATH="!gpg_w32_bin_dir!";!PATH!

REM Terminal
echo set PATH=%%~dp0!gpg_w32_dir_name!\bin;%%PATH%%>> "!tmp_terminal_script!"

REM Application Setup
REM ----------------------------------------------------------------------------
REM Download & verify the tools we want for development

REM Wezterm
REM ----------------------------------------------------------------------------
set wezterm_sha256=c634e98fa9715766bbb00cbc3c8a23d1d558c8cd5716ad2efca45ed4e0ef82f9
set wezterm_exe_sha256=b9b5bae20d0679127ca0c4da276dff3b7b32310bfbfaede26a9b8ecb55e295ce
set wezterm_version=20220408-101518-b908e2dd

set wezterm_download_name=WezTerm-windows-!wezterm_version!
set wezterm_download_file=!wezterm_download_name!.zip
set wezterm_download_path=!downloads_dir!\!wezterm_download_file!
set wezterm_download_url="https://github.com/wez/wezterm/releases/download/!wezterm_version!/!wezterm_download_file!"

set wezterm_dir_name=wezterm_win64_!wezterm_version!
set wezterm_dir=!tools_dir!\!wezterm_dir_name!
set wezterm_exe=!wezterm_dir!\wezterm-gui.exe

if not exist "!wezterm_exe!" (
    call win_helpers.bat :DownloadFile "!wezterm_download_url!" "!wezterm_download_path!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :FileHashCheck sha256 "!wezterm_download_path!" "!wezterm_sha256!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :Unzip "!zip7_exe!" "!wezterm_download_path!" "!wezterm_dir!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :MoveDir "!wezterm_dir!\!wezterm_download_Name!" "!wezterm_dir!" || exit /B %ERRORLEVEL%
)

call win_helpers.bat :FileHashCheck sha256 "!wezterm_exe!" "!wezterm_exe_sha256!" || exit /B %ERRORLEVEL%
call win_helpers.bat :OverwriteCopy "!installer_dir!\os_wezterm.lua" "!wezterm_dir!\wezterm.lua" || exit /B %ERRORLEVEL%

REM Jetbrains Mono Font
REM ----------------------------------------------------------------------------
set jetbrains_mono_sha256=4e315b4ef176ce7ffc971b14997bdc8f646e3d1e5b913d1ecba3a3b10b4a1a9f
set jetbrains_mono_file_sha256=50e1dcb40298fcfcc21a1ef3cbee9fe9e82709c48ad30ce617472c06a3bd9436
set jetbrains_mono_version=2.242

set jetbrains_download_name=JetBrainsMono-!jetbrains_mono_version!
set jetbrains_download_file=!jetbrains_download_name!.zip
set jetbrains_download_path=!downloads_dir!\!jetbrains_download_file!
set jetbrains_download_url="https://download.jetbrains.com/fonts/!jetbrains_download_file!"

set jetbrains_mono_dir=!tools_dir!\jetbrains_mono_!jetbrains_mono_version!
set jetbrains_mono_file=!jetbrains_mono_dir!\fonts\ttf\JetBrainsMono-Regular.ttf

if not exist "!jetbrains_mono_file!" (
    call win_helpers.bat :DownloadFile "!jetbrains_download_url!" "!jetbrains_mono_download_path!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :FileHashCheck sha256 "!jetbrains_mono_download_path!" "!jetbrains_mono_sha256!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :Unzip "!zip7_exe!" "!jetbrains_mono_download_path!" "!jetbrains_mono_dir!" || exit /B %ERRORLEVEL%
)

call win_helpers.bat :FileHashCheck sha256 "!jetbrains_mono_file!" "!jetbrains_mono_file_sha256!" || exit /B %ERRORLEVEL%

REM Programming
REM ----------------------------------------------------------------------------
REM CMake
REM ----------------------------------------------------------------------------
set cmake_version_list=3.23.1 !cmake_version_list!
set cmake_version_list=3.22.2 !cmake_version_list!
set cmake_version_list=3.10.3 !cmake_version_list!
set cmake_version_list=!cmake_version_list!

for %%a in (%cmake_version_list%) do (
    set cmake_version=%%a
    set cmake_download_name=cmake-!cmake_version!-windows-x86_64

    if "!cmake_version!"=="3.23.1" (
        set cmake_sha256=9b509cc4eb7191dc128cfa3f2170036f9cbc7d9d5f93ff7fafc5b2d77b3b40dc
        set cmake_exe_sha256=326ae6ce4bd46c27f6ce46c95b48efc19848fd9fc24d71d2e8a226dadfef810c
    ) else if "!cmake_version!"=="3.22.2" (
        set cmake_sha256=192D62EAECB0600E743F01058DFBD5B6BED91504FE8F56416FEBF54C38CE096E
        set cmake_exe_sha256=CF1AF65D22BD01BF1CF2DB7ECEFEB730AB147549755FAA4357E5427E3175F638
    ) else if "!cmake_version!"=="3.10.3" (
        set cmake_sha256=3BD57D1CFCF720A4CC72DB77BDA4C76A7B700FB0341821AD868963AD28856CD0
        set cmake_exe_sha256=F2E3B486D87D2A6BC19B3A62C740028F3F8945875196AC7D3D0E69649E98730A
        set cmake_download_name=cmake-!cmake_version!-win64-x64
    )

    set cmake_download_file=!cmake_download_name!.zip
    set cmake_download_path=!downloads_dir!\!cmake_download_file!
    set cmake_download_url="https://github.com/Kitware/CMake/releases/download/v!cmake_version!/!cmake_download_file!"

    set cmake_dir_name=cmake_win64_!cmake_version!
    set cmake_dir=!tools_dir!\!cmake_dir_name!
    set cmake_bin_dir=!cmake_dir!\bin
    set cmake_exe=!cmake_bin_dir!\cmake.exe

    if not exist "!cmake_exe!" (
        call win_helpers.bat :DownloadFile "!cmake_download_url!" "!cmake_download_path!" || exit /B %ERRORLEVEL%
        call win_helpers.bat :FileHashCheck sha256 "!cmake_download_path!" "!cmake_sha256!" || exit /B %ERRORLEVEL%
        call win_helpers.bat :Unzip "!zip7_exe!" "!cmake_download_path!" "!cmake_dir!" || exit /B %ERRORLEVEL%
        call win_helpers.bat :MoveDir "!cmake_dir!/!cmake_download_name!" "!cmake_dir!" || exit /B %ERRORLEVEL%
    )

    call win_helpers.bat :FileHashCheck sha256 "!cmake_exe!" "!cmake_exe_sha256!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :MakeRelativeBatchShortcut "cmake-!cmake_version!" "..\!cmake_dir_name!\bin\cmake.exe" "!bin_dir!" || exit /B %ERRORLEVEL%
)
echo set PATH=%%~dp0!cmake_dir_name!\bin;%%PATH%%>> "!tmp_terminal_script!"

REM ctags
REM ----------------------------------------------------------------------------
set ctags_sha256=B82648E9A3B2C8E50E0283A47B4F013F1B52E0F0E56DBB4F1C805D17578C4DF2
set ctags_exe_sha256=7465E2D34EAF5F901AC45D7E9ED4AC8E7D3A532964D0D77A94F2D0EE3AE145AA
set ctags_version=p5.9.20220612.0

set ctags_download_name=ctags-!ctags_version!-x64
set ctags_download_file=!ctags_download_name!.zip
set ctags_download_path=!downloads_dir!\!ctags_download_file!
set ctags_download_url="https://github.com/universal-ctags/ctags-win32/releases/download/!ctags_version!/!ctags_download_file!"

set ctags_dir_name=ctags_win64_!ctags_version!
set ctags_dir=!tools_dir!\!ctags_dir_name!
set ctags_exe=!ctags_dir!\ctags.exe

if not exist "!ctags_exe!" (
    call win_helpers.bat :DownloadFile "!ctags_download_url!" "!ctags_download_path!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :FileHashCheck sha256 "!ctags_download_path!" "!ctags_sha256!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :Unzip "!zip7_exe!" "!ctags_download_path!" "!ctags_dir!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :MoveDir "!ctags_dir!/ctags-!ctags_version!-windows-x86_64" "!ctags_dir!" || exit /B %ERRORLEVEL%
)
call win_helpers.bat :FileHashCheck sha256 "!ctags_exe!" "!ctags_exe_sha256!" || exit /B %ERRORLEVEL%
call win_helpers.bat :MakeRelativeBatchShortcut "ctags" "..\!ctags_dir_name!\ctags.exe" "!bin_dir!" || exit /B %ERRORLEVEL%

REM doxygen
REM ----------------------------------------------------------------------------
set doxygen_md5=266a2b66914d0d1d96cc97e9f740b74c
set doxygen_exe_sha256=3CB4D89F2B3DB7EEC2B6797DC6B49CDFE9ADDA954575898895260F66F312D730
set doxygen_version=1.9.4

set doxygen_download_name=doxygen-!doxygen_version!.windows.x64.bin
set doxygen_download_file=!doxygen_download_name!.zip
set doxygen_download_path=!downloads_dir!\!doxygen_download_file!
set doxygen_download_url="https://www.doxygen.nl/files/!doxygen_download_file!"

set doxygen_dir_name=doxygen_win64_!doxygen_version!
set doxygen_dir=!tools_dir!\!doxygen_dir_name!
set doxygen_exe=!doxygen_dir!\doxygen.exe

if not exist "!doxygen_exe!" (
    call win_helpers.bat :DownloadFile "!doxygen_download_url!" "!doxygen_download_path!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :FileHashCheck md5 "!doxygen_download_path!" "!doxygen_md5!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :Unzip "!zip7_exe!" "!doxygen_download_path!" "!doxygen_dir!" || exit /B %ERRORLEVEL%
)
call win_helpers.bat :FileHashCheck sha256 "!doxygen_exe!" "!doxygen_exe_sha256!" || exit /B %ERRORLEVEL%
call win_helpers.bat :MakeRelativeBatchShortcut "doxygen" "..\!doxygen_dir_name!\doxygen.exe" "!bin_dir!" || exit /B %ERRORLEVEL%

REM Git
REM ----------------------------------------------------------------------------
set git_sha256=bc030848e282d49e562ae2392a72501cf539322ad06ffe4cea8cf766f148dfe8
set git_exe_sha256=ae463cad04c2b15fc91de68ab096933ec08c44752e205aebd7d64c3a482df62d
set git_version=2.33.0

set git_download_name=PortableGit-!git_version!.2-64-bit.7z
set git_download_file=!git_download_name!.exe
set git_download_path=!downloads_dir!\!git_download_file!
set git_download_url="https://github.com/git-for-windows/git/releases/download/v!git_version!.windows.2/!git_download_file!"

REM Do *NOT* use an environment variable named git_dir as this will conflict
REM with git reading it as the directory to base off all git operations.
set git_install_dir_name=PortableGit_win64_!git_version!
set git_install_dir=!tools_dir!\!git_install_dir_name!
set git_exe=!git_install_dir!\cmd\git.exe

if not exist "!git_exe!" (
    call win_helpers.bat :DownloadFile "!git_download_url!" "!git_download_path!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :FileHashCheck sha256 "!git_download_path!" "!git_sha256!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :Unzip "!zip7_exe!" "!git_download_path!" "!git_install_dir!" || exit /B %ERRORLEVEL%
)

call win_helpers.bat :FileHashCheck sha256 "!git_exe!" "!git_exe_sha256!" || exit /B %ERRORLEVEL%

REM Terminal
echo set PATH=%%~dp0!git_install_dir_name!\cmd;%%PATH%%>> "!tmp_terminal_script!"
echo set PATH=%%~dp0!git_install_dir_name!\mingw64\bin;%%PATH%%>> "!tmp_terminal_script!"
echo set PATH=%%~dp0!git_install_dir_name!\usr\bin;%%PATH%%>> "!tmp_terminal_script!"

REM GCC/MinGW for 32/64bit ARM
REM ----------------------------------------------------------------------------
set gcc_mingw_arm_version_list=12.2.0 !gcc_mingw_arm_version_list!
set gcc_mingw_arm_version_list=11.3.0 !gcc_mingw_arm_version_list!
set gcc_mingw_arm_version_list=10.3.0 !gcc_mingw_arm_version_list!

set gcc_mingw_arm_arch_list=aarch64-none-elf !gcc_mingw_arm_arch_list!
set gcc_mingw_arm_arch_list=arm-none-eabi !gcc_mingw_arm_arch_list!

for %%a in (%gcc_mingw_arm_version_list%) do (
    for %%b in (%gcc_mingw_arm_arch_list%) do (
        set gcc_mingw_arm_version=%%a
        set gcc_mingw_arm_arch=%%b
        set gcc_mingw_arm_exe_sha256=none

        if "!gcc_mingw_arm_arch!"=="aarch64-none-elf" (
            if "!gcc_mingw_arm_version!"=="12.2.0" set gcc_mingw_arm_exe_sha256=A26BAFFA86BC3401790D682F13F9B321EA56153EAE7DD4F332BDE40A6B76FCB3
            if "!gcc_mingw_arm_version!"=="11.3.0" set gcc_mingw_arm_exe_sha256=47EAEF0E603C9FCAE18F2EFADA305888503E878053119EDE3A9E0B8B8BEAC2EE
            if "!gcc_mingw_arm_version!"=="10.3.0" set gcc_mingw_arm_exe_sha256=F2B2D3C6DAB0F84A151835540F25E6D6F9442D00BF546BC4C709FAD4B6FDDA06
        ) else (
            if "!gcc_mingw_arm_version!"=="12.2.0" set gcc_mingw_arm_exe_sha256=FA48985C43CF82B426C461381E4C50D0AC3E9425F7E97BF116E1BAB4B3A2A388
            if "!gcc_mingw_arm_version!"=="11.3.0" set gcc_mingw_arm_exe_sha256=A36F2EA6846BADF7C91631F118E88967F25D6E479A9BEEA158445CE75403A655
            if "!gcc_mingw_arm_version!"=="10.3.0" set gcc_mingw_arm_exe_sha256=C3DC49B561D177B3586992DFEA86067EB8799E1586A7F26CEA5B0EA97926632E
        )

        set gcc_mingw_arm_download_name=gcc-v!gcc_mingw_arm_version!-!gcc_mingw_arm_arch!
        set gcc_mingw_arm_download_file=!gcc_mingw_arm_download_name!.7z
        set gcc_mingw_arm_download_path=!downloads_dir!\!gcc_mingw_arm_download_file!
        set gcc_mingw_arm_download_url="https://github.com/mmozeiko/build-gcc-arm/releases/download/gcc-v!gcc_mingw_arm_version!/!gcc_mingw_arm_download_file!"

        set gcc_mingw_arm_dir_name=gcc_mingw_arm_win64_!gcc_mingw_arm_version!_!gcc_mingw_arm_arch!
        set gcc_mingw_arm_dir=!tools_dir!\!gcc_mingw_arm_dir_name!
        set gcc_mingw_arm_bin_dir=!gcc_mingw_arm_dir!\bin
        set gcc_mingw_arm_exe=!gcc_mingw_arm_bin_dir!\!gcc_mingw_arm_arch!-g++.exe

        if not exist "!gcc_mingw_arm_exe!" (
            call win_helpers.bat :DownloadFile "!gcc_mingw_arm_download_url!" "!gcc_mingw_arm_download_path!" || exit /B %ERRORLEVEL%
            call win_helpers.bat :Unzip "!zip7_exe!" "!gcc_mingw_arm_download_path!" "!gcc_mingw_arm_dir!" || exit /B %ERRORLEVEL%
            call win_helpers.bat :MoveDir "!gcc_mingw_arm_dir!\gcc-v!gcc_mingw_arm_version!-!gcc_mingw_arm_arch!" !gcc_mingw_arm_dir! || exit /B %ERRORLEVEL%
        )

        call win_helpers.bat :FileHashCheck sha256 "!gcc_mingw_arm_exe!" "!gcc_mingw_arm_exe_sha256!" || exit /B %ERRORLEVEL%
        call win_helpers.bat :MakeRelativeBatchShortcut "!gcc_mingw_arm_arch!-gcc-!gcc_mingw_arm_version!" "..\!gcc_mingw_arm_dir_name!\bin\!gcc_mingw_arm_arch!-gcc.exe" "!bin_dir!" || exit /B %ERRORLEVEL%
        call win_helpers.bat :MakeRelativeBatchShortcut "!gcc_mingw_arm_arch!-g++-!gcc_mingw_arm_version!" "..\!gcc_mingw_arm_dir_name!\bin\!gcc_mingw_arm_arch!-g++.exe" "!bin_dir!" || exit /B %ERRORLEVEL%
    )
)

REM GCC+MinGW
REM ----------------------------------------------------------------------------
set gcc_version_list=12.2.0 !gcc_version_list!
set gcc_version_list=11.3.0 !gcc_version_list!
set gcc_version_list=10.3.0 !gcc_version_list!

for %%a in (%gcc_version_list%) do (
    set gcc_version=%%a
    set gcc_mingw_version=none
    set gcc_exe_sha256=none

    if "!gcc_version!"=="12.2.0" (
        set gcc_mingw_version=10.0.0
        set gcc_exe_sha256=886B0F25256DDBD0F4AD09E6E3B81279F9A8B6A1B5C32C714C9C201D802CAA39
    )

    if "!gcc_version!"=="11.3.0" (
        set gcc_mingw_version=10.0.0
        set gcc_exe_sha256=E92ECFA0171F2AB0C3CA39F2121AB5E887B3A378399A4BE7E056820F5841C7A5
    )

    if "!gcc_version!"=="10.3.0" (
        set gcc_mingw_version=8.0.0
        set gcc_exe_sha256=5C93B6DA129EA01EE5FC87D5C7DB948FC3BC62BAE261DED9A883F1FA543571D2
    )

    set gcc_download_name=gcc-v!gcc_version!-mingw-v!gcc_mingw_version!-x86_64
    set gcc_download_file=!gcc_download_name!.7z
    set gcc_download_path=!downloads_dir!\!gcc_download_file!
    set gcc_download_url="https://github.com/mmozeiko/build-gcc/releases/download/gcc-v!gcc_version!-mingw-v!gcc_mingw_version!/!gcc_download_file!"

    set gcc_dir_name=gcc_!gcc_version!_mingw_!gcc_mingw_version!_win64
    set gcc_dir=!tools_dir!\!gcc_dir_name!
    set gcc_bin_dir=!gcc_dir!\bin
    set gcc_exe=!gcc_bin_dir!\g++.exe

    if not exist "!gcc_exe!" (
        call win_helpers.bat :DownloadFile "!gcc_download_url!" "!gcc_download_path!" || exit /B %ERRORLEVEL%
        call win_helpers.bat :Unzip "!zip7_exe!" "!gcc_download_path!" "!gcc_dir!" || exit /B %ERRORLEVEL%
        call win_helpers.bat :MoveDir "!gcc_dir!\gcc-v!gcc_version!-mingw-v!gcc_mingw_version!-x86_64" !gcc_dir! || exit /B %ERRORLEVEL%
    )

    call win_helpers.bat :FileHashCheck sha256 "!gcc_exe!" "!gcc_exe_sha256!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :MakeRelativeBatchShortcut "gcc-!gcc_version!" "..\!gcc_dir_name!\bin\gcc.exe" "!bin_dir!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :MakeRelativeBatchShortcut "g++-!gcc_version!" "..\!gcc_dir_name!\bin\g++.exe" "!bin_dir!" || exit /B %ERRORLEVEL%
)

REM Terminal
echo set PATH=%%~dp0!gcc_dir_name!\bin;%%PATH%%>> "!tmp_terminal_script!"

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

    set llvm_download_name=LLVM-!llvm_version!-win64
    set llvm_download_file=!llvm_download_name!.exe
    set llvm_download_path=!downloads_dir!\!llvm_download_file!
    set llvm_download_url="https://github.com/llvm/llvm-project/releases/download/llvmorg-!llvm_version!/!llvm_download_file!"

    set llvm_dir_name=llvm_win64_!llvm_version!
    set llvm_dir=!tools_dir!\!llvm_dir_name!
    set llvm_bin_dir=!llvm_dir!\bin
    set llvm_exe=!llvm_bin_dir!\clang.exe

    set llvm_gpg_key_download_url="https://github.com/llvm/llvm-project/releases/download/llvmorg-9.0.1/tstellar-gpg-key.asc"
    set llvm_gpg_key=!downloads_dir!\llvm_tstellar_gpg_key.asc
    set llvm_gpg_sig=!llvm_download_path!.sig

    if not exist "!llvm_exe!" (
        call win_helpers.bat :DownloadFile "!llvm_gpg_key_download_url!" "!llvm_gpg_key!" || exit /B %ERRORLEVEL%
        call win_helpers.bat :DownloadFile "!llvm_download_url!" "!llvm_download_path!" || exit /B %ERRORLEVEL%

        REM Version 14.0.5 doesn't ship with signatures?
        REM call win_helpers.bat :DownloadFile "https://github.com/llvm/llvm-project/releases/download/llvmorg-!llvm_version!/LLVM-!llvm_version!-win64.exe.sig" "!llvm_gpg_sig!" || exit /B %ERRORLEVEL%
        REM gpg --import "!llvm_gpg_key!" || exit /B %ERRORLEVEL%
        REM gpg --verify "!llvm_gpg_sig!" "!llvm_download_path!" || exit /B %ERRORLEVEL%

        call win_helpers.bat :Unzip "!zip7_exe!" "!llvm_download_path!" "!llvm_dir!" || exit /B %ERRORLEVEL%
    )

    call win_helpers.bat :FileHashCheck sha256 "!llvm_exe!" "!llvm_exe_sha256!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :MakeRelativeBatchShortcut "clang-!llvm_version!"    "..\!llvm_dir_name!\bin\clang.exe" "!bin_dir!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :MakeRelativeBatchShortcut "clang++-!llvm_version!"  "..\!llvm_dir_name!\bin\clang++.exe" "!bin_dir!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :MakeRelativeBatchShortcut "clang-cl-!llvm_version!" "..\!llvm_dir_name!\bin\clang-cl.exe" "!bin_dir!" || exit /B %ERRORLEVEL%
)

REM Clang Format
set clang_format=!home_dir!\clang-format.py
call win_helpers.bat :OverwriteCopy "!llvm_dir!\share\clang\clang-format.py" "!clang_format!" || exit /B %ERRORLEVEL%

REM Terminal
echo set PATH=%%~dp0!llvm_dir_name!\bin;%%PATH%%>> "!tmp_terminal_script!"

REM MinGW64
REM ------------------------------------------------------------------------
set mingw_sha256=853970527b5de4a55ec8ca4d3fd732c00ae1c69974cc930c82604396d43e79f8
set mingw_exe_sha256=c5f0953f7a71ddcdf0852e1e44a43cef9b8fe121beba4d4202bfe6d405de47c0
set mingw_version=8.1.0

set mingw_download_name=x86_64-!mingw_version!-release-posix-seh-rt_v6-rev0
set mingw_download_file=!mingw_download_name!.7z
set mingw_download_path=!downloads_dir!\!mingw_download_file!
set mingw_download_url="https://sourceforge.net/projects/mingw-w64/files/Toolchains targetting Win64/Personal Builds/mingw-builds/!mingw_version!/threads-posix/seh/!mingw_download_file!\"

set mingw_dir_name=mingw64-posix-seg-rt_v6-rev0_win64_!mingw_version!
set mingw_dir=!tools_dir!\!mingw_dir_name!
set mingw_bin_dir=!mingw_dir!\bin
set mingw_exe=!mingw_bin_dir!\gcc.exe

if not exist "!mingw_exe!" (
    call win_helpers.bat :DownloadFile \"!mingw_download_url!\" !ming_download_path! || exit /B %ERRORLEVEL%
    call win_helpers.bat :FileHashCheck sha256 !ming_download_path! !mingw_sha256! || exit /B %ERRORLEVEL%
    call win_helpers.bat :Unzip "!zip7_exe!" !ming_download_path! !mingw_dir! || exit /B %ERRORLEVEL%
    call win_helpers.bat :MoveDir !mingw_dir!\mingw64 !mingw_dir! || exit /B %ERRORLEVEL%
)

call win_helpers.bat :FileHashCheck sha256 "!mingw_exe!" "!mingw_exe_sha256!" || exit /B %ERRORLEVEL%

REM ninja
REM ----------------------------------------------------------------------------
set ninja_sha256=bbde850d247d2737c5764c927d1071cbb1f1957dcabda4a130fa8547c12c695f
set ninja_exe_sha256=6a71c03f88897419f19548a8eadd941ed94144bb671be289822080f991c1ab79
set ninja_version=1.10.2

set ninja_download_name=ninja-win
set ninja_download_file=!ninja_download_name!.zip
set ninja_download_path=!downloads_dir!\!ninja_download_file!
set ninja_download_url="https://github.com/ninja-build/ninja/releases/download/v!ninja_version!/!ninja_download_file!"

set ninja_dir_name=ninja_win64_!ninja_version!
set ninja_dir=!tools_dir!\!ninja_dir_name!
set ninja_exe=!ninja_dir!\ninja.exe

if not exist "!ninja_exe!" (
    call win_helpers.bat :DownloadFile "!ninja_download_url!" "!ninja_download_path!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :FileHashCheck sha256 "!ninja_download_path!" "!ninja_sha256!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :Unzip "!zip7_exe!" "!ninja_download_path!" "!ninja_dir!" || exit /B %ERRORLEVEL%
)

call win_helpers.bat :FileHashCheck sha256 "!ninja_exe!" "!ninja_exe_sha256!" || exit /B %ERRORLEVEL%
call win_helpers.bat :MakeRelativeBatchShortcut "ninja" "..\!ninja_dir_name!\ninja.exe" "!bin_dir!" || exit /B %ERRORLEVEL%

REM nodejs
REM ----------------------------------------------------------------------------
set nodejs_sha256=f7b0e8b0bfcfad7d62eba16fa4db9f085983c12c661bd4c66d8e3bd783befa65
set nodejs_exe_sha256=7f33cbe04cb2940427e6dd97867c1fcf3ddd60911d2ae0260da3cab9f6ea6365
set nodejs_version=16.7.0

set nodejs_download_name=node-v!nodejs_version!-win-x64
set nodejs_download_file=!nodejs_download_name!.7z
set nodejs_download_path=!downloads_dir!\!nodejs_download_file!
set nodejs_download_url="https://nodejs.org/dist/v!nodejs_version!/!nodejs_download_file!"

set nodejs_dir_name=nodejs_win64_!nodejs_version!
set nodejs_dir=!tools_dir!\!nodejs_dir_name!
set nodejs_exe=!nodejs_dir!\node.exe

if not exist "!nodejs_exe!" (
    call win_helpers.bat :DownloadFile "!nodejs_download_url!" "!nodejs_download_path!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :FileHashCheck sha256 "!nodejs_download_path!" "!nodejs_sha256!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :Unzip "!zip7_exe!" "!nodejs_download_path!" "!nodejs_dir!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :MoveDir "!nodejs_dir!\!nodejs_download_name!" "!nodejs_dir!" || exit /B %ERRORLEVEL%
)

call win_helpers.bat :FileHashCheck sha256 "!nodejs_exe!" "!nodejs_exe_sha256!" || exit /B %ERRORLEVEL%

REM Terminal
echo set PATH=%%~dp0!nodejs_dir_name!;%%PATH%%>> "!tmp_terminal_script!"

REM Python
REM ----------------------------------------------------------------------------
REM We use the shared installation of python since pynvim/greenlet does not work
REM with a static python distribution.
set python_sha256=39EE2B12AAB9E07E2B3CE698331160C55C75CD4AFFEE028F6AE78020711D503C
set python_exe_sha256=8677FBA3EFC27F51EA84C528B24E5824B580CE59CD5714C47073FF2459637687

set python_date=20220630
set python_version=3.9.13
set python_version_and_date=!python_version!+!python_date!

set python_download_name=cpython-!python_version_and_date!-x86_64-pc-windows-msvc-shared-install_only
set python_download_file=!python_download_name!.tar.gz
set python_download_path=!downloads_dir!\!python_download_file!
set python_download_url="https://github.com/indygreg/python-build-standalone/releases/download/!python_date!/!python_download_file!"

set python_dir_name=cpython_win64_!python_version_and_date!
set python_dir=!tools_dir!\!python_dir_name!
set python_exe=!python_dir!\python.exe

if not exist "!python_exe!" (
    call win_helpers.bat :DownloadFile "!python_download_url!" "!python_download_path!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :FileHashCheck sha256 "!python_download_path!" "!python_sha256!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :Unzip "!zip7_exe!" "!python_download_path!" "!downloads_dir!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :Unzip "!zip7_exe!" "!downloads_dir!\!python_download_name!.tar" "!python_dir!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :MoveDir "!python_dir!\python" "!python_dir!" || exit /B %ERRORLEVEL%
)

call win_helpers.bat :FileHashCheck sha256 "!python_exe!" "!python_exe_sha256!" || exit /B %ERRORLEVEL%

REM Terminal
echo set PYTHONHOME=%%~dp0!python_dir_name!>> "!tmp_terminal_script!"
echo set PATH=%%~dp0!python_dir_name!;%%PATH%%>> "!tmp_terminal_script!"

REM RenderDoc
REM ----------------------------------------------------------------------------
set renderdoc_sha256=ed1c1228b8fc30e53d3560dbae9d7bf47b85e0e15e30e6f3e4f36173a74f77bc
set renderdoc_exe_sha256=3b4874f1677f08e4c329696eaa8281b7ee86b16ad5679932a72085a3e7abc658
set renderdoc_version=1.19

set renderdoc_download_name=RenderDoc_!renderdoc_version!_64
set renderdoc_download_file=!renderdoc_download_name!.zip
set renderdoc_download_path=!downloads_dir!\!renderdoc_download_file!
set renderdoc_download_url="https://renderdoc.org/stable/!renderdoc_version!/!renderdoc_download_file!"

set renderdoc_dir=!tools_dir!\renderdoc_win64_!renderdoc_version!
set renderdoc_exe=!renderdoc_dir!\qrenderdoc.exe

if not exist "!renderdoc_exe!" (
    call win_helpers.bat :DownloadFile "!renderdoc_download_url!" "!renderdoc_download_path!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :FileHashCheck sha256 "!renderdoc_download_path!" "!renderdoc_sha256!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :Unzip "!zip7_exe!" "!renderdoc_download_path!" "!renderdoc_dir!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :MoveDir "!renderdoc_dir!\!renderdoc_download_name!" "!renderdoc_dir!" || exit /B %ERRORLEVEL%
)

call win_helpers.bat :FileHashCheck sha256 "!renderdoc_exe!" "!renderdoc_exe_sha256!" || exit /B %ERRORLEVEL%

REM Zeal
REM ----------------------------------------------------------------------------
set zeal_sha256=08e9992f620ba0a5ea348471d8ac9c85059e95eedd950118928be639746e3f94
set zeal_exe_sha256=d1e687a33e117b6319210f40e2401b4a68ffeb0f33ef82f5fb6a31ce4514a423
set zeal_version=0.6.1

set zeal_download_name=zeal-portable-!zeal_version!-windows-x64
set zeal_download_file=!zeal_download_name!.7z
set zeal_download_path=!downloads_dir!\!zeal_download_file!
set zeal_download_url="https://github.com/zealdocs/zeal/releases/download/v!zeal_version!/!zeal_download_file!"

set zeal_dir=!tools_dir!\zeal_win64_!zeal_version!
set zeal_exe=!zeal_dir!\zeal.exe

if not exist "!zeal_exe!" (
    call win_helpers.bat :DownloadFile "!zeal_download_url!" "!zeal_download_path!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :FileHashCheck sha256 "!zeal_download_path!" "!zeal_sha256!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :Unzip "!zip7_exe!" "!zeal_download_path!" "!zeal_dir!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :MoveDir "!zeal_dir!\!zeal_download_name!" "!zeal_dir!" || exit /B %ERRORLEVEL%
)

call win_helpers.bat :FileHashCheck sha256 "!zeal_exe!" "!zeal_exe_sha256!" || exit /B %ERRORLEVEL%

REM Zig
REM ----------------------------------------------------------------------------
set zig_sha256=443da53387d6ae8ba6bac4b3b90e9fef4ecbe545e1c5fa3a89485c36f5c0e3a2
set zig_exe_sha256=63c2f819cfdb1a35cb954791fc0aa48910a42065a5e1c6ff89ee16775c75a112
set zig_version=0.9.1

set zig_download_name=zig-windows-x86_64-!zig_version!
set zig_download_file=!zig_download_name!.zip
set zig_download_path=!downloads_dir!\!zig_download_file!
set zig_download_url="https://ziglang.org/download/!zig_version!/!zig_download_file!"

set zig_dir_name=zig_win64_!zig_version!
set zig_dir=!tools_dir!\!zig_dir_name!
set zig_exe=!zig_dir!\zig.exe

if not exist "!zig_exe!" (
    call win_helpers.bat :DownloadFile "!zig_download_url!" "!zig_download_path!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :FileHashCheck sha256 "!zig_download_path!" "!zig_sha256!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :Unzip "!zip7_exe!" "!zig_download_path!" "!zig_dir!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :MoveDir "!zig_dir!\!zig_download_name!" "!zig_dir!" || exit /B %ERRORLEVEL%
)

call win_helpers.bat :FileHashCheck sha256 "!zig_exe!" "!zig_exe_sha256!" || exit /B %ERRORLEVEL%
call win_helpers.bat :MakeRelativeBatchShortcut "zig"               "..\!zig_dir_name!\zig.exe" "!bin_dir!" || exit /B %ERRORLEVEL%
call win_helpers.bat :MakeRelativeBatchShortcut "zig-!zig_version!" "..\!zig_dir_name!\zig.exe" "!bin_dir!" || exit /B %ERRORLEVEL%

REM MSVC
REM ----------------------------------------------------------------------------
REM This depends on python, so it must be installed after it.
set msvc_version=14.32
set msvc_sdk_version=22621
set msvc_dir_name=msvc_win64_!msvc_version!_win10_sdk_!msvc_sdk_version!
set msvc_dir=!tools_dir!\!msvc_dir_name!
if not exist "!msvc_dir!" (
    call "!python_exe!" !installer_dir!\win_portable-msvc.py --accept-license --msvc-version !msvc_version! --sdk-version !msvc_sdk_version! || exit /B %ERRORLEVEL%
    call win_helpers.bat :MoveDir "msvc" "!msvc_dir!" || exit /B %ERRORLEVEL%
)

REM Put the compiler into the path temporarily for compiling some programs on
REM demand in this script.
call !msvc_dir!\setup.bat

REM Terminal
echo call "%%~dp0!msvc_dir_name!\setup.bat">> "!tmp_terminal_script!"

REM Symget
REM ----------------------------------------------------------------------------
set symget_git_hash=79b026f
set symget_dir=!tools_dir!\symget
set symget_exe=!symget_dir!\symget.exe
if not exist "!symget_dir!" (
    call "!git_exe!" clone "https://github.com/mmozeiko/symget.git" "!symget_dir!" || exit /B %ERRORLEVEL%
)

REM Extract current git hash of the repository. Remove the last character as
REM rev-parse has a trailing whitespace.
for /F "tokens=1 USEBACKQ" %%F IN (`"!git_exe!" -C !symget_dir! rev-parse --short HEAD`) do ( SET symget_curr_git_hash=%%F )
set symget_curr_git_hash=!symget_curr_git_hash:~0,-1!

if !symget_curr_git_hash! neq !symget_git_hash! (
    call "!git_exe!" -C "!symget_dir!" pull origin master || exit /B %ERRORLEVEL%
    call "!git_exe!" -C "!symget_dir!" checkout "!symget_git_hash!" || exit /B %ERRORLEVEL%
    if exist "!symget_exe!" del /F "!symget_exe!"
)

if not exist "!symget_exe!" (
    pushd !symget_dir!
    call build.cmd
    popd
)

REM Odin
REM ----------------------------------------------------------------------------
set odin_git_hash=7fe36de
set odin_dir_name=odin_win64
set odin_dir=!tools_dir!\!odin_dir_name!
set odin_exe=!odin_dir!\odin.exe

if not exist "!odin_dir!" (
    call "!git_exe!" clone "https://github.com/odin-lang/odin.git" "!odin_dir!" || exit /B %ERRORLEVEL%
)

REM Extract current git hash of the repository. Remove the last character as
REM rev-parse has a trailing whitespace.
for /F "tokens=1 USEBACKQ" %%F IN (`"!git_exe!" -C !odin_dir! rev-parse --short HEAD`) do ( SET odin_curr_git_hash=%%F )
set odin_curr_git_hash=!odin_curr_git_hash:~0,-1!

if "!odin_curr_git_hash!" neq "!odin_git_hash!" (
    call "!git_exe!" -C "!odin_dir!" pull origin master || exit /B %ERRORLEVEL%
    call "!git_exe!" -C "!odin_dir!" checkout "!odin_git_hash!" || exit /B %ERRORLEVEL%
    if exist "!odin_exe!" del /F "!odin_exe!"
)

if not exist "!odin_exe!" (
    pushd "!odin_dir!"
    call build.bat
    popd
)

call win_helpers.bat :MakeRelativeBatchShortcut "odin" "..\!odin_dir_name!\odin.exe" "!bin_dir!" || exit /B %ERRORLEVEL%

REM QoL/Tools
REM ----------------------------------------------------------------------------
REM clink - Bash style tab completion in terminal
REM ----------------------------------------------------------------------------
set clink_sha256=6FD44B1D085ABC8319108986C0E19B119D54BC84A753397D567A5F62950F0ACC
set clink_exe_sha256=138F680A25C993ACE201B844DEAC7F42D8D3EC9F02042D3DE7E9B6426C8A6D42
set clink_version=1.3.37
set clink_git_hash=b85068

set clink_download_name=clink.!clink_version!.!clink_git_hash!
set clink_download_file=!clink_download_name!.zip
set clink_download_path=!downloads_dir!\!clink_download_file!
set clink_download_url="https://github.com/chrisant996/clink/releases/download/v!clink_version!/!clink_download_file!"

set clink_dir_name=clink_win64_!clink_version!
set clink_dir=!tools_dir!\!clink_dir_name!
set clink_exe=!clink_dir!\clink_x64.exe

if not exist "!clink_exe!" (
    call win_helpers.bat :DownloadFile "!clink_download_url!" "!clink_download_path!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :FileHashCheck sha256 "!clink_download_path!" "!clink_sha256!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :Unzip "!zip7_exe!" "!clink_download_path!" "!clink_dir!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :OverwriteCopy "!clink_dir!\_default_inputrc" "!clink_dir!\default_inputrc" || exit /B %ERRORLEVEL%
    call win_helpers.bat :OverwriteCopy "!clink_dir!\_default_settings" "!clink_dir!\default_settings" || exit /B %ERRORLEVEL%
)

call win_helpers.bat :FileHashCheck sha256 "!clink_exe!" "!clink_exe_sha256!" || exit /B %ERRORLEVEL%
call win_helpers.bat :MakeRelativeBatchShortcut "clink" "..\!clink_dir_name!\clink.bat" "!bin_dir!" || exit /B %ERRORLEVEL%

REM Clink Completion Addon
set clink_completions_dir_name=clink-completions
set clink_completions_dir=!tools_dir!\!clink_completions_dir_name!
if not exist "!clink_completions_dir!" (
    call !git_exe! clone https://github.com/vladimir-kotikov/clink-completions !clink_completions_dir! || exit /B %ERRORLEVEL%
)
call !git_exe! -C !clink_completions_dir! pull origin master || exit /B %ERRORLEVEL%
call !git_exe! -C !clink_completions_dir! checkout 9ab9342 || exit /B %ERRORLEVEL%

REM Terminal Script
echo set CLINK_PATH=%%~dp0!clink_completions_dir_name!>> "!tmp_terminal_script!

REM Dependencies (Walker) - For DLL dependency management
REM ----------------------------------------------------------------------------
set dependencies_sha256=7d22dc00f1c09fd4415d48ad74d1cf801893e83b9a39944b0fce6dea7ceaea99
set dependencies_exe_sha256=1737e5406128c3560bbb2bced3ac62d77998e592444f94b10cc0aa0bb1e617e6
set dependencies_version=1.11.1

set dependencies_download_name=Dependencies_x64_Release
set dependencies_download_file=!dependencies_download_name!.zip
set dependencies_download_path=!downloads_dir!\!dependencies_download_file!
set dependencies_download_url="https://github.com/lucasg/Dependencies/releases/download/v!dependencies_version!/!dependencies_download_file!"

set dependencies_dir=!tools_dir!\dependencies_win64_!dependencies_version!
set dependencies_exe=!dependencies_dir!\DependenciesGui.exe

if not exist "!dependencies_exe!" (
    call win_helpers.bat :DownloadFile "!dependencies_download_url!" "!dependencies_download_path!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :FileHashCheck sha256 "!dependencies_download_path!" "!dependencies_sha256!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :Unzip "!zip7_exe!" "!dependencies_download_path!" "!dependencies_dir!" || exit /B %ERRORLEVEL%
)

call win_helpers.bat :FileHashCheck sha256 "!dependencies_exe!" "!dependencies_exe_sha256!" || exit /B %ERRORLEVEL%

REM everything (void tools search program)
REM ----------------------------------------------------------------------------
set everything_sha256=656ff3946222048a5558160023da6fd8abc6fa9569f7ac1dff058410a3db6f28
set everything_exe_sha256=8f853443c0b0e8c144315a27d1e8bf1595bd09cb364393226accfe105c0a2c85
set everything_version=1.4.1.1015

set everything_download_name=Everything-!everything_version!.x64
set everything_download_file=!everything_download_name!.zip
set everything_download_path=!downloads_dir!\!everything_download_file!
set everything_download_url="https://www.voidtools.com/!everything_download_file!"

set everything_dir_name=everything_win64_!everything_version!
set everything_dir=!tools_dir!\!everything_dir_name!
set everything_exe=!everything_dir!\everything.exe

if not exist "!everything_exe!" (
    call win_helpers.bat :DownloadFile "!everything_download_url!" "!everything_download_path!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :FileHashCheck sha256 "!everything_download_path!" "!everything_sha256!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :Unzip "!zip7_exe!" "!everything_download_path!" "!everything_dir!" || exit /B %ERRORLEVEL%
)

call win_helpers.bat :FileHashCheck sha256 "!everything_exe!" "!everything_exe_sha256!" || exit /B %ERRORLEVEL%

REM fzf
REM ----------------------------------------------------------------------------
set fzf_sha256=AB0ED3255564DF1A6643FF492EBC728C25F3DF9EAA5C11AC7A28CF661667412F
set fzf_exe_sha256=C41293D9E632C5A3604AD863389C0BEC7AC2AD1E3C1F51B60EA2271A63BBB3D2
set fzf_version=0.30.0

set fzf_download_name=fzf-!fzf_version!-windows_amd64
set fzf_download_file=!fzf_download_name!.zip
set fzf_download_path=!downloads_dir!\!fzf_download_file!
set fzf_download_url="https://github.com/junegunn/fzf/releases/download/!fzf_version!/!fzf_download_file!"

set fzf_dir=!tools_dir!
set fzf_exe=!fzf_dir!\fzf_win64_!fzf_version!.exe

if not exist "!fzf_exe!" (
    call win_helpers.bat :DownloadFile "!fzf_download_url!" "!fzf_download_path!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :FileHashCheck sha256 "!fzf_download_path!" "!fzf_sha256!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :Unzip "!zip7_exe!" "!fzf_download_path!" "!fzf_dir!" || exit /B %ERRORLEVEL%
    move /Y "!fzf_dir!\fzf.exe" "!fzf_exe!" 1>NUL || exit /B %ERRORLEVEL%
)

call win_helpers.bat :FileHashCheck sha256 "!fzf_exe!" "!fzf_exe_sha256!" || exit /B %ERRORLEVEL%
call win_helpers.bat :MakeRelativeBatchShortcut "fzf" "..\fzf_win64_!fzf_version!.exe" "!bin_dir!" || exit /B %ERRORLEVEL%

REM Terminal
REM Use FD for FZF to make it ultra fast
echo set FZF_DEFAULT_OPTS=--multi --layout=reverse>> "!tmp_terminal_script!"
echo set FZF_DEFAULT_COMMAND=fd --unrestricted>> "!tmp_terminal_script!"

REM NVIM
REM ----------------------------------------------------------------------------
set nvim_sha256=a72a90e2897ea296b777c325a37c981a0b51e2fe0c8b8735e3366b65e958cddc
set nvim_exe_sha256=E2B9B9C38EE169475EEAE4501278A36A93C7A4F08F6E5379CA65A166041B8DA8
set nvim_version=0.7.0

set nvim_download_name=nvim-win64
set nvim_download_file=!nvim_download_name!.zip
set nvim_download_path=!downloads_dir!\!nvim_download_file!
set nvim_download_url="https://github.com/neovim/neovim/releases/download/v!nvim_version!/!nvim_download_file!"

set nvim_dir_name=nvim_win64_!nvim_version!
set nvim_dir=!tools_dir!\!nvim_dir_name!
set nvim_exe=!nvim_dir!\bin\nvim.exe

if not exist "!nvim_exe!" (
    call win_helpers.bat :DownloadFile "!nvim_download_url!" "!nvim_download_path!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :FileHashCheck sha256 "!nvim_download_path!" "!nvim_sha256!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :Unzip "!zip7_exe!" "!nvim_download_path!" "!nvim_dir!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :MoveDir "!nvim_dir!\!nvim_download_name!" "!nvim_dir!" || exit /B %ERRORLEVEL%
)

call win_helpers.bat :FileHashCheck sha256 "!nvim_exe!" "!nvim_exe_sha256!" || exit /B %ERRORLEVEL%
call win_helpers.bat :MakeRelativeBatchShortcut "nvim"    "..\!nvim_dir_name!\bin\nvim.exe" "!bin_dir!" || exit /B %ERRORLEVEL%
call win_helpers.bat :MakeRelativeBatchShortcut "nvim-qt" "..\!nvim_dir_name!\bin\nvim-qt.exe" "!bin_dir!" || exit /B %ERRORLEVEL%

REM Neovide
REM ----------------------------------------------------------------------------
set neovide_sha256=D1DE20E0FCBF68CB4D85CD6F15691DFB77848DAFB97519F8E67E3036A2A7927D
set neovide_exe_sha256=C0F6ED7ED8BAC4EE910267FA785DA698A581004EA45838BE401E3FBA18DD3234
set neovide_version=0.9.0

set neovide_download_name=neovide-windows
set neovide_download_file=!neovide_download_name!.zip
set neovide_download_path=!downloads_dir!\!neovide_download_file!
set neovide_download_url="https://github.com/neovide/neovide/releases/download/!neovide_version!/!neovide_download_file!"

set neovide_dir=!tools_dir!\
set neovide_exe=!neovide_dir!\neovide_win64_!neovide_version!.exe

if not exist "!neovide_exe!" (
    call win_helpers.bat :DownloadFile "!neovide_download_url!" "!neovide_download_path!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :FileHashCheck sha256 "!neovide_download_path!" "!neovide_sha256!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :Unzip "!zip7_exe!" "!neovide_download_path!" "!neovide_dir!" || exit /B %ERRORLEVEL%
    move /Y "!neovide_dir!\neovide.exe" "!neovide_exe!" || exit /B %ERRORLEVEL%
)

call win_helpers.bat :FileHashCheck sha256 "!neovide_exe!" "!neovide_exe_sha256!" || exit /B %ERRORLEVEL%
call win_helpers.bat :MakeRelativeBatchShortcut "neovide" "..\neovide_win64_!neovide_version!.exe" "!bin_dir!" || exit /B %ERRORLEVEL%

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
set PYTHONHOME=!python_dir!
!python_dir!\python.exe -m pip install pynvim cmake-language-server

REM ImHex
REM ----------------------------------------------------------------------------
set imhex_sha256=080f537d3ea58c002cc2112adbec1352144710b43764de9a1dc04f129d3a3343
set imhex_exe_sha256=6a4b0e70bf7c78af074af0de2346164d9f5aec28ea224f9ee903412e1c774d95
set imhex_version=1.17.0

set imhex_download_name=Windows.Portable.ZIP
set imhex_download_file=!imhex_download_name!.zip
set imhex_download_path=!downloads_dir!\!imhex_download_file!
set imhex_download_url="https://github.com/WerWolv/ImHex/releases/download/v!imhex_version!/!imhex_download_url!"

set imhex_dir=!tools_dir!\imhex_win64_!imhex_version!
set imhex_exe=!imhex_dir!\imhex.exe

if not exist "!imhex_exe!" (
    call win_helpers.bat :DownloadFile "!imhex_download_url!" "!imhex_download_path!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :FileHashCheck sha256 "!imhex_download_path!" "!imhex_sha256!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :Unzip "!zip7_exe!" "!imhex_download_path!" "!imhex_dir!" || exit /B %ERRORLEVEL%
)

call win_helpers.bat :FileHashCheck sha256 "!imhex_exe!" "!imhex_exe_sha256!" || exit /B %ERRORLEVEL%

REM Keypirinha
REM ----------------------------------------------------------------------------
set keypirinha_sha256=d109a16e6a5cf311abf6d06bbe5b1be3b9ba323b79c32a168628189e10f102a5
set keypirinha_exe_sha256=2d3adb36a04e9fdf94636c9ac5d4c2b754accbfaecd81f4ee7189c3c0edc8af1
set keypirinha_version=2.26

set keypirinha_download_name=keypirinha-!keypirinha_version!-x64-portable
set keypirinha_download_file=!keypirinha_download_name!.7z
set keypirinha_download_path=!downloads_dir!\!keypirinha_download_file!
set keypirinha_download_url="https://github.com/Keypirinha/Keypirinha/releases/download/v!keypirinha_version!/!keypirinha_download_file!"

set keypirinha_dir_name=keypirinha_win64_!keypirinha_version!
set keypirinha_dir=!tools_dir!\!keypirinha_dir_name!
set keypirinha_exe=!keypirinha_dir!\keypirinha.exe

if not exist "!keypirinha_exe!" (
    call win_helpers.bat :DownloadFile "!keypirinha_download_url!" "!keypirinha_download_path!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :FileHashCheck sha256 "!keypirinha_download_path!" "!keypirinha_sha256!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :Unzip "!zip7_exe!" "!keypirinha_download_path!" "!keypirinha_dir!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :MoveDir "!keypirinha_dir!\keypirinha" "!keypirinha_dir!" || exit /B %ERRORLEVEL%
)

call win_helpers.bat :FileHashCheck sha256 "!keypirinha_exe!" "!keypirinha_exe_sha256!" || exit /B %ERRORLEVEL%

REM Misc Tools
REM ----------------------------------------------------------------------------
REM ctags: C/C++ code annotation generator
REM scanmapset: Bind capslock to escape via registry
REM uncap: Bind capslock to escape via run-time program
call win_helpers.bat :OverwriteCopy "!installer_dir!\win_clang_merge_compilation_command_files.bat" "!bin_dir!\clang_merge_compilation_command_files.bat" || exit /B %ERRORLEVEL%
call win_helpers.bat :OverwriteCopy "!installer_dir!\win_scanmapset.exe"                            "!bin_dir!\scanmapset.exe" || exit /B %ERRORLEVEL%
call win_helpers.bat :OverwriteCopy "!installer_dir!\win_uncap.exe"                                 "!bin_dir!\uncap.exe" || exit /B %ERRORLEVEL%
call win_helpers.bat :OverwriteCopy "!installer_dir!\os_clang_format_style_file"                    "!home_dir!\_clang-format" || exit /B %ERRORLEVEL%

REM MobaXTerm
REM ------------------------------------------------------------------------
set mobaxterm_sha256=91f80537f12c2ad34a5eba99a285c149781c6d35a144a965ce3aea8a9bc6868c
set mobaxterm_exe_sha256=1053c81b44018d6e6519a9c80d7413f7bb36e9f6e43b3da619b2229aa362a522
set mobaxterm_version=21.2

set mobaxterm_download_name=MobaXterm_Portable_v!mobaxterm_version!
set mobaxterm_download_file=!mobaxterm_download_name!.zip
set mobaxterm_download_path=!downloads_dir!\!mobaxterm_download_file!
set mobaxterm_download_url="https://download.mobatek.net/2122021051924233/!mobaxterm_download_file!"

set mobaxterm_dir=!tools_dir!\mobaxterm_win64_!mobaxterm_version!
set mobaxterm_exe=!mobaxterm_dir!\MobaXterm_Personal_21.2.exe

if not exist "!mobaxterm_exe!" (
    call win_helpers.bat :DownloadFile "!mobaxterm_download_url!" !mobaxterm_download_path! || exit /B %ERRORLEVEL%
    call win_helpers.bat :FileHashCheck sha256 !mobaxterm_download_path! !mobaxterm_sha256! || exit /B %ERRORLEVEL%
    call win_helpers.bat :Unzip "!zip7_exe!" !mobaxterm_download_path! !mobaxterm_dir! || exit /B %ERRORLEVEL%
)

call win_helpers.bat :FileHashCheck sha256 "!mobaxterm_exe!" "!mobaxterm_exe_sha256!" || exit /B %ERRORLEVEL%

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

REM ProcessHacker
REM ----------------------------------------------------------------------------
set process_hacker_sha256=c662b756324c9727760b4e921459d31a30f99cf8d3f24b64f4fcb3b29a26beb4
set process_hacker_exe_sha256=22b1b8f080a41a07f23eae8ab0ad2e5f88d3c5af5d8c1cd1bb4f6856482e945c
set process_hacker_version=3.0.4861

set process_hacker_download_name=processhacker-!process_hacker_version!-bin
set process_hacker_download_file=!process_hacker_download_name!.zip
set process_hacker_download_path=!downloads_dir!\!process_hacker_download_file!
set process_hacker_download_url="https://github.com/ProcessHackerRepoTool/nightly-builds-mirror/releases/download/v!process_hacker_version!/!process_hacker_download_file!"

set process_hacker_dir=!tools_dir!\process_hacker_win64_!process_hacker_version!
set process_hacker_exe=!process_hacker_dir!\64bit\ProcessHacker.exe

if not exist "!process_hacker_exe!" (
    call win_helpers.bat :DownloadFile "!process_hacker_download_url!" "!process_hacker_download_path!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :FileHashCheck sha256 "!process_hacker_download_path!" "!process_hacker_sha256!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :Unzip "!zip7_exe!" "!process_hacker_download_path!" "!process_hacker_dir!" || exit /B %ERRORLEVEL%
)

call win_helpers.bat :FileHashCheck sha256 "!process_hacker_exe!" "!process_hacker_exe_sha256!" || exit /B %ERRORLEVEL%

REM ripgrep
REM ----------------------------------------------------------------------------
set rg_sha256=a47ace6f654c5ffa236792fc3ee3fefd9c7e88e026928b44da801acb72124aa8
set rg_exe_sha256=ab5595a4f7a6b918cece0e7e22ebc883ead6163948571419a1dd5cd3c7f37972
set rg_version=13.0.0

set rg_download_name=ripgrep-!rg_version!-x86_64-pc-windows-msvc
set rg_download_file=!rg_download_name!.zip
set rg_download_path=!downloads_dir!\!rg_download_file!
set rg_download_url="https://github.com/BurntSushi/ripgrep/releases/download/!rg_version!/!ripgrep_download_file!"

set rg_dir_name=ripgrep_win64_!rg_version!
set rg_dir=!tools_dir!\!rg_dir_name!
set rg_exe=!rg_dir!\rg.exe

if not exist "!rg_exe!" (
    call win_helpers.bat :DownloadFile "!rg_download_url!" "!rg_download_path!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :FileHashCheck sha256 "!rg_download_path!" "!rg_sha256!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :Unzip "!zip7_exe!" "!rg_download_path!" "!rg_dir!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :MoveDir "!rg_dir!\!rg_download_name!" "!rg_dir!" || exit /B %ERRORLEVEL%
)

call win_helpers.bat :FileHashCheck sha256 "!rg_exe!" "!rg_exe_sha256!" || exit /B %ERRORLEVEL%

REM Terminal
echo set PATH=%%~dp0!rg_dir_name!;%%PATH%%>> "!tmp_terminal_script!"

REM fd
REM ----------------------------------------------------------------------------
set fd_sha256=F21BC26C1AB6BDBE4FE43F87A20C792D4ABE629AE97C6F42B25AC8A042F5521F
set fd_exe_sha256=764F31AC5B477707B51DAEC32458E4D66059BA0D17F03032B7CD0C0534703354
set fd_version=8.4.0

set fd_download_name=ripgrep-!fd_version!-x86_64-pc-windows-msvc
set fd_download_file=!fd_download_name!.zip
set fd_download_path=!downloads_dir!\!fd_download_file!
set fd_download_url="https://github.com/sharkdp/fd/releases/download/!fd_version!/!fd_download_file!"

set fd_dir_name=fd_win64_!fd_version!
set fd_dir=!tools_dir!\!fd_dir_name!
set fd_exe=!fd_dir!\fd.exe

if not exist "!fd_exe!" (
    call win_helpers.bat :DownloadFile "!fd_download_url!" "!fd_download_path!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :FileHashCheck sha256 "!fd_download_path!" "!fd_sha256!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :Unzip "!zip7_exe!" "!fd_download_path!" "!fd_dir!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :MoveDir "!fd_dir!\fd-v!fd_version!-x86_64-pc-windows-msvc" "!fd_dir!" || exit /B %ERRORLEVEL%
)

call win_helpers.bat :FileHashCheck sha256 "!fd_exe!" "!fd_exe_sha256!" || exit /B %ERRORLEVEL%

REM Terminal
echo set PATH=%%~dp0!fd_dir_name!;%%PATH%%>> "!tmp_terminal_script!"

REM wiztree
REM ----------------------------------------------------------------------------
set wiztree_sha256=066E270DE1E398CC8447428047628C241832D53839AAE9815443B486AFFD66C9
set wiztree_exe_sha256=688a21f225af918c47b883a0d905922411a63cbe55785aa4fbc16af244c1fcdf
set wiztree_version=4_08

set wiztree_download_name=wiztree_!wiztree_version!_portable
set wiztree_download_file=!wiztree_download_name!.zip
set wiztree_download_path=!downloads_dir!\!wiztree_download_file!
set wiztree_download_url="https://www.diskanalyzer.com/files/!wiztree_download_file!"

set wiztree_dir=!tools_dir!\wiztree_win64_!wiztree_version!
set wiztree_exe=!wiztree_dir!\wiztree64.exe

if not exist "!wiztree_exe!" (
    call win_helpers.bat :DownloadFile "!wiztree_download_url!" "!wiztree_download_path!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :FileHashCheck sha256 "!wiztree_download_path!" "!wiztree_sha256!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :Unzip "!zip7_exe!" "!wiztree_download_path!" "!wiztree_dir!" || exit /B %ERRORLEVEL%
)

call win_helpers.bat :FileHashCheck sha256 "!wiztree_exe!" "!wiztree_exe_sha256!" || exit /B %ERRORLEVEL%

REM Ethereum
REM ----------------------------------------------------------------------------
REM geth
REM ----------------------------------------------------------------------------
set geth_md5=753cab189bd175d9fc6fea965ff7161b
set geth_exe_sha256=7374e1c761f27a24a1d66299935b03b46ac354b6dc5f48505178d014a56f12df
set geth_version=1.10.17-25c9b49f

set geth_download_name=geth-windows-amd64-!geth_version!
set geth_download_file=!geth_download_name!.zip
set geth_download_path=!downloads_dir!\!geth_download_file!
set geth_download_url="https://gethstore.blob.core.windows.net/builds/!geth_download_file!"

set geth_dir_name=geth_win64_!geth_version!
set geth_dir=!tools_dir!\!geth_dir_name!
set geth_exe=!geth_dir!\geth.exe

set geth_gpg_key_download_name=geth-windows-amd64-!geth_version!.zip
set geth_gpg_key_download_file=!geth_gpg_key_download_name!.asc
set geth_gpg_key_download_path=!downloads_dir!\!geth_gpg_key_download_file!
set geth_gpg_key_download_url="https://gethstore.blob.core.windows.net/builds/!geth_gpg_key_download_file!"

set geth_gpg_key=!installer_dir!\win_geth_windows_builder_gpg_key.asc

if not exist "!geth_exe!" (
    call win_helpers.bat :DownloadFile "!geth_download_url!" "!geth_download_path!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :DownloadFile "!geth_gpg_key_download_url!" "!geth_gpg_key_download_path!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :FileHashCheck md5 "!geth_download_path!" "!geth_md5!" || exit /B %ERRORLEVEL%

    gpg --import "!geth_gpg_key!" || exit /B %ERRORLEVEL%
    gpg --verify "!geth_gpg_key_download_path!" "!geth_download_path!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :Unzip "!zip7_exe!" "!geth_download_path!" "!geth_dir!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :MoveDir "!geth_dir!\!geth_download_name!" "!geth_dir!"
)

call win_helpers.bat :FileHashCheck sha256 "!geth_exe!" "!geth_exe_sha256!" || exit /B %ERRORLEVEL%
call win_helpers.bat :MakeRelativeBatchShortcut "geth" "..\!geth_dir_name!\geth.exe" "!bin_dir!" || exit /B %ERRORLEVEL%

REM remix_ide
REM ----------------------------------------------------------------------------
set remix_ide_sha256=E3736B66ECF30384B88FD4D626F788412C0117E18C4D26F2289469CD0E33752A
set remix_ide_exe_sha256=BEE0A36255D16A9888BA421D95CFC3B672265790E70AE56924E27022E8A2BA0D
set remix_ide_version=1.3.3

set remix_ide_download_name=Remix-IDE-!remix_ide_version!-win
set remix_ide_download_file=!remix_ide_download_name!.zip
set remix_ide_download_path=!downloads_dir!\!remix_ide_download_file!
set remix_ide_download_url="https://github.com/ethereum/remix-desktop/releases/download/v!remix_ide_version!/!remix_ide_download_file!"

set remix_ide_dir=!tools_dir!\remix_ide_win64_!remix_ide_version!
set remix_ide_exe=!remix_ide_dir!\Remix IDE.exe

if not exist "!remix_ide_exe!" (
    call win_helpers.bat :DownloadFile "!remix_ide_download_url!" "!remix_ide_download_path!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :FileHashCheck sha256 "!remix_ide_download_path!" "!remix_ide_sha256!" || exit /B %ERRORLEVEL%
    call win_helpers.bat :Unzip "!zip7_exe!" "!remix_ide_download_path!" "!remix_ide_dir!" || exit /B %ERRORLEVEL%
)

call win_helpers.bat :FileHashCheck sha256 "!remix_ide_exe!" "!remix_ide_exe_sha256!" || exit /B %ERRORLEVEL%

REM solidity
REM ----------------------------------------------------------------------------
set solidity_exe_sha256=70A5A7EAA9135D13BD036CA55735F489559368AF819C5810CFAF0315DF56AB53
set solidity_version=0.8.14

set solidity_download_name=solc-windows
set solidity_download_file=!solidity_download_name!.exe
set solidity_download_path=!downloads_dir!\!solidity_download_file!
set solidity_download_url="https://github.com/ethereum/solidity/releases/download/v!solidity_version!/!solidity_download_file!"

set solidity_dir=!tools_dir!
set solidity_exe=!solidity_dir!\solidity_win64_!solidity_version!.exe

if not exist "!solidity_exe!" (
    if not exist "!solidity_dir!" mkdir "!solidity_dir!"
    call win_helpers.bat :DownloadFile "" "!solidity_exe!" || exit /B %ERRORLEVEL%
)

call win_helpers.bat :FileHashCheck sha256 "!solidity_exe!" "!solidity_exe_sha256!" || exit /B %ERRORLEVEL%
call win_helpers.bat :MakeRelativeBatchShortcut "solc" "..\solidity_win64_!solidity_version!.exe" "!bin_dir!" || exit /B %ERRORLEVEL%
call win_helpers.bat :MakeRelativeBatchShortcut "solc-!solidity_version!" "..\solidity_win64_!solidity_version!.exe" "!bin_dir!" || exit /B %ERRORLEVEL%

REM Finish Terminal Script
REM ----------------------------------------------------------------------------
echo if exist "%%~dp0win_terminal_user_config.bat" call "%%~dp0win_terminal_user_config.bat">> "!tmp_terminal_script!"
echo start "" /MAX "%%~dp0!wezterm_dir_name!\wezterm-gui.exe">> "!tmp_terminal_script!"
echo exit>> "!tmp_terminal_script!"
move /Y !tmp_terminal_script! !terminal_script!

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

REM Background Application Scripts
REM ----------------------------------------------------------------------------
set bg_app_script=!tools_dir!\win_start_background_apps.bat
echo @echo off> "!bg_app_script!"
echo start "" "%%~dp0!everything_dir_name!\everything.exe">> "!bg_app_script!"
echo start "" "%%~dp0!keypirinha_dir_name!\keypirinha.exe">> "!bg_app_script!"

REM CTags Helper Script
REM ----------------------------------------------------------------------------
set ctags_file=!bin_dir!\ctags_cpp.bat
echo @echo off> "!ctags_file!"
echo ctags --c++-kinds=+p --fields=+iaS --extras=+q %%*>> !ctags_file!

REM Finish
REM ----------------------------------------------------------------------------
echo - Setup complete. Launch !tools_dir!\win_terminal.bat [or restart Wezterm instance if you're updating an existing installation]
echo - (Optional) A custom font is provided and requires manual intallation in Windows at !jetbrains_mono_file!
echo              This font will be used in GVIM if it's available.
pause
exit /B %ERRORLEVEL%
