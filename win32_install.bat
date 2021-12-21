@echo off
setlocal EnableDelayedExpansion

call win32_install_config.bat

REM ----------------------------------------------------------------------------
REM Setup Folder Locations
REM ----------------------------------------------------------------------------
set root_dir=!CD!
set home_dir=Home
set install_dir=Installer
set downloads_dir=!install_dir!\Downloads
set vim_dir=!home_dir!\vimfiles
set tools_dir=Tools
set bin_dir=!tools_dir!\binaries

if not exist !home_dir! mkdir !home_dir!
if not exist !install_dir! mkdir !install_dir!
if not exist !downloads_dir! mkdir !downloads_dir!
if not exist !tools_dir! mkdir !tools_dir!
if not exist !bin_dir! mkdir !bin_dir!

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

set zip7_bootstrap_zip=!downloads_dir!\win32_7zip_bootstrap_v!zip7_bootstrap_version!.zip
set zip7_bootstrap_dir=!tools_dir!\7zip_bootstrap-!zip7_bootstrap_version!
set zip7_bootstrap_exe=!zip7_bootstrap_dir!\7za.exe

if not exist "!zip7_bootstrap_exe!" (
    call :DownloadFile "https://www.7-zip.org/a/7za!zip7_bootstrap_version!.zip" "!zip7_bootstrap_zip!" || exit /B
    call :VerifyFileSHA256 "!zip7_bootstrap_zip!" "!zip7_bootstrap_sha256!" || exit /B
)
if not exist "!zip7_bootstrap_dir!" powershell "Expand-Archive !zip7_bootstrap_zip! -DestinationPath !zip7_bootstrap_dir!" || exit /B

call :VerifyFileSHA256 "!zip7_bootstrap_exe!" "!zip7_bootstrap_exe_sha256!" || exit /B

REM ----------------------------------------------------------------------------
REM 7zip
REM ----------------------------------------------------------------------------
REM Use our bootstrap 7z from above to download the latest 7zip version
REM NOTE: We do not use 7za because it can not unzip a NSIS installer. The full
REM version however can.
set zip7_sha256=0f5d4dbbe5e55b7aa31b91e5925ed901fdf46a367491d81381846f05ad54c45e
set zip7_exe_sha256=344f076bb1211cb02eca9e5ed2c0ce59bcf74ccbc749ec611538fa14ecb9aad2
set zip7_version=1900

set zip7_zip=!downloads_dir!\win32_7zip_v!zip7_version!.exe
set zip7_dir=!tools_dir!\7zip-!zip7_version!
set zip7_exe=!zip7_dir!\7z.exe

if not exist "!zip7_exe!" (
    call :DownloadFile "https://www.7-zip.org/a/7z!zip7_version!-x64.exe" "!zip7_zip!" || exit /B
    call :VerifyFileSHA256 "!zip7_zip!" "!zip7_sha256!" || exit /B
    "!zip7_bootstrap_exe!" x -y -o"!zip7_dir!" !zip7_zip! || exit /B
)

call :VerifyFileSHA256 "!zip7_exe!" "!zip7_exe_sha256!" || exit /B

REM ----------------------------------------------------------------------------
REM GPG Signature Verification
REM ----------------------------------------------------------------------------
set gpg_w32_sha256=77cec7f274ee6347642a488efdfa324e8c3ab577286e611c397e69b1b396ab16
set gpg_w32_exe_sha256=551bfc44b1c90c66908379ec4035756b812545eee19b36bdbe1f659cfcd6bc0b
set gpg_w32_version=2.3.1
set gpg_w32_date=20210420

set gpg_w32_zip=!downloads_dir!\win32_gpg_w32_v!gpg_w32_version!.exe
set gpg_w32_dir=!tools_dir!\gpg_w32-!gpg_w32_version!
set gpg_w32_exe=!gpg_w32_dir!\bin\gpg.exe

if not exist "!gpg_w32_exe!" (
    call :DownloadFile "https://gnupg.org/ftp/gcrypt/binary/gnupg-w32-!gpg_w32_version!_!gpg_w32_date!.exe" "!gpg_w32_zip!" || exit /B
    call :VerifyFileSHA256 "!gpg_w32_zip!" "!gpg_w32_sha256!" || exit /B
    call :Unzip "!gpg_w32_zip!" "!gpg_w32_dir!" || exit /B
)

call :VerifyFileSHA256 "!gpg_w32_exe!" "!gpg_w32_exe_sha256!" || exit /B

set gpg_w32_bin_dir=!gpg_w32_dir!\bin
set PATH="!gpg_w32_bin_dir!";!PATH!

REM ----------------------------------------------------------------------------
REM Application Setup
REM ----------------------------------------------------------------------------
REM Download & verify the tools we want for development

REM ----------------------------------------------------------------------------
REM Wezterm
REM ----------------------------------------------------------------------------
if !install_wezterm! == 1 (
    set wezterm_sha256=75242f12ea2d03ab8c1bcb1a8afdb872fb722c84be64b9a40dc41f3ed7d76492
    set wezterm_exe_sha256=e1b8d680714c2c32bf04f3457915416d227b6704d8c29ecd772a827136882fd3
    set wezterm_version=20210814-124438-54e29167

    set wezterm_zip=!downloads_dir!\win32_wezterm-!wezterm_version!.zip
    set wezterm_dir=!tools_dir!\wezterm-!wezterm_version!
    set wezterm_exe=!wezterm_dir!\wezterm-gui.exe

    if not exist "!wezterm_exe!" (
        call :DownloadFile https://github.com/wez/wezterm/releases/download/!wezterm_version!/WezTerm-windows-!wezterm_version!.zip "!wezterm_zip!" || exit /B
        call :VerifyFileSHA256 "!wezterm_zip!" "!wezterm_sha256!" || exit /B
        call :Unzip "!wezterm_zip!" "!wezterm_dir!" || exit /B
        call :Move "!wezterm_dir!\wezterm-windows-!wezterm_version!" "!wezterm_dir!" || exit /B
    )

    call :VerifyFileSHA256 "!wezterm_exe!" "!wezterm_exe_sha256!" || exit /B
    call :CopyAndAlwaysOverwriteFile "!install_dir!\wezterm.lua" "!wezterm_dir!\wezterm.lua" || exit /B
)

REM ----------------------------------------------------------------------------
REM Jetbrains Mono Font
REM ----------------------------------------------------------------------------
set jetbrains_mono_sha256=4e315b4ef176ce7ffc971b14997bdc8f646e3d1e5b913d1ecba3a3b10b4a1a9f
set jetbrains_mono_file_sha256=50e1dcb40298fcfcc21a1ef3cbee9fe9e82709c48ad30ce617472c06a3bd9436
set jetbrains_mono_version=2.242

set jetbrains_mono_zip=!downloads_dir!\jetbrains_mono-!jetbrains_mono_version!.zip
set jetbrains_mono_dir=!tools_dir!\jetbrains_mono-!jetbrains_mono_version!
set jetbrains_mono_file=!jetbrains_mono_dir!\fonts\ttf\JetBrainsMono-Regular.ttf

if not exist "!jetbrains_mono_file!" (
    call :DownloadFile https://download.jetbrains.com/fonts/JetBrainsMono-!jetbrains_mono_version!.zip "!jetbrains_mono_zip!" || exit /B
    call :VerifyFileSHA256 "!jetbrains_mono_zip!" "!jetbrains_mono_sha256!" || exit /B
    call :Unzip "!jetbrains_mono_zip!" "!jetbrains_mono_dir!" || exit /B
)

call :VerifyFileSHA256 "!jetbrains_mono_file!" "!jetbrains_mono_file_sha256!" || exit /B

REM ----------------------------------------------------------------------------
REM Programming
REM ----------------------------------------------------------------------------
REM ----------------------------------------------------------------------------
REM Git
REM ----------------------------------------------------------------------------
if !install_git! == 1 (
    set git_sha256=bc030848e282d49e562ae2392a72501cf539322ad06ffe4cea8cf766f148dfe8
    set git_exe_sha256=ae463cad04c2b15fc91de68ab096933ec08c44752e205aebd7d64c3a482df62d
    set git_version=2.33.0

    set git_zip=!downloads_dir!\win32_git_!git_version!.7z.exe
    set git_dir=!tools_dir!\PortableGit-!git_version!
    set git_exe=!git_dir!\cmd\git.exe

    if not exist "!git_exe!" (
        call :DownloadFile "https://github.com/git-for-windows/git/releases/download/v!git_version!.windows.2/PortableGit-!git_version!.2-64-bit.7z.exe" "!git_zip!" || exit /B
        call :VerifyFileSHA256 "!git_zip!" "!git_sha256!" || exit /B
        call :Unzip "!git_zip!" "!git_dir!" || exit /B
    )

    call :VerifyFileSHA256 "!git_exe!" "!git_exe_sha256!" || exit /B
)

REM ----------------------------------------------------------------------------
REM LLVM/Clang
REM ----------------------------------------------------------------------------
if !install_llvm_clang! == 1 (
    set llvm_exe_sha256=9f0748de7f946c210a030452de226986bab46a0121d7236ea0e7b5079cb6dfef
    set llvm_version=12.0.1

    set llvm_zip=!downloads_dir!\win32_llvm_x64_v!llvm_version!.exe
    set llvm_dir=!tools_dir!\llvm-!llvm_version!
    set llvm_exe=!llvm_dir!\bin\clang.exe

    set llvm_gpg_key=!downloads_dir!\llvm-tstellar-gpg-key.asc
    set llvm_gpg_sig=!llvm_zip!.sig

    if not exist "!llvm_exe!" (
        call :DownloadFile "https://github.com/llvm/llvm-project/releases/download/llvmorg-9.0.1/tstellar-gpg-key.asc" "!llvm_gpg_key!" || exit /B
        call :DownloadFile "https://github.com/llvm/llvm-project/releases/download/llvmorg-!llvm_version!/LLVM-!llvm_version!-win64.exe.sig" "!llvm_gpg_sig!" || exit /B
        call :DownloadFile "https://github.com/llvm/llvm-project/releases/download/llvmorg-!llvm_version!/LLVM-!llvm_version!-win64.exe" "!llvm_zip!" || exit /B

        gpg --import "!llvm_gpg_key!" || exit /B
        gpg --verify "!llvm_gpg_sig!" "!llvm_zip!" || exit /B
        call :Unzip "!llvm_zip!" "!llvm_dir!" || exit /B
    )

    if !install_gvim! == 1 (
        set clang_format_py_sha256=36ba7aa047f8a8ac8fdc278aaa733de801cc84dea60a4210973fd3e4f0d2a330
        set vim_clang_format=!vim_dir!\clang-format.py
        call :CopyAndAlwaysOverwriteFile "!llvm_dir!\share\clang\clang-format.py" "!vim_clang_format!" || exit /B
        call :VerifyFileSHA256 !vim_clang_format! !clang_format_py_sha256! || exit /B
    )

    set llvm_bin_dir=!llvm_dir!\bin
    call :VerifyFileSHA256 !llvm_exe! !llvm_exe_sha256! || exit /B
)

REM ------------------------------------------------------------------------
REM MinGW64
REM ------------------------------------------------------------------------
if !install_mingw64! == 1 (
    set mingw_sha256=853970527b5de4a55ec8ca4d3fd732c00ae1c69974cc930c82604396d43e79f8
    set mingw_exe_sha256=c5f0953f7a71ddcdf0852e1e44a43cef9b8fe121beba4d4202bfe6d405de47c0
    set mingw_version=8.1.0

    set mingw_zip=!downloads_dir!\win32_mingw64-posix-seg-rt_v6-rev0!mingw_version!.7z
    set mingw_dir=!tools_dir!\mingw64-posix-seh-rt_v6-rev0-!mingw_version!
    set mingw_bin_dir=!mingw_dir!\bin
    set mingw_exe=!mingw_bin_dir!\gcc.exe

    if not exist "!mingw_exe!" (
        call :DownloadFile \"https://sourceforge.net/projects/mingw-w64/files/Toolchains targetting Win64/Personal Builds/mingw-builds/!mingw_version!/threads-posix/seh/x86_64-!mingw_version!-release-posix-seh-rt_v6-rev0.7z\" !mingw_zip! || exit /B
        call :VerifyFileSHA256 !mingw_zip! !mingw_sha256! || exit /B
        call :Unzip !mingw_zip! !mingw_dir! || exit /B
        call :Move !mingw_dir!\mingw64 !mingw_dir! || exit /B
    )

    call :VerifyFileSHA256 !mingw_exe! !mingw_exe_sha256! || exit /B
)

REM ----------------------------------------------------------------------------
REM nodejs
REM ----------------------------------------------------------------------------
if !install_nodejs! == 1 (
    set nodejs_sha256=f7b0e8b0bfcfad7d62eba16fa4db9f085983c12c661bd4c66d8e3bd783befa65
    set nodejs_exe_sha256=7f33cbe04cb2940427e6dd97867c1fcf3ddd60911d2ae0260da3cab9f6ea6365
    set nodejs_version=16.7.0

    set nodejs_zip=!downloads_dir!\nodejs-!nodejs_version!-win-x64.7z
    set nodejs_dir=!tools_dir!\nodejs-!nodejs_version!
    set nodejs_exe=!nodejs_dir!\node.exe

    if not exist "!nodejs_exe!" (
        call :DownloadFile "https://nodejs.org/dist/v!nodejs_version!/node-v!nodejs_version!-win-x64.7z" "!nodejs_zip!" || exit /B
        call :VerifyFileSHA256 "!nodejs_zip!" "!nodejs_sha256!" || exit /B
        call :Unzip "!nodejs_zip!" "!nodejs_dir!" || exit /B
        call :Move "!nodejs_dir!\node-v!nodejs_version!-win-x64" "!nodejs_dir!" || exit /B
    )

    call :VerifyFileSHA256 "!nodejs_exe!" "!nodejs_exe_sha256!" || exit /B
)

REM ----------------------------------------------------------------------------
REM Python
REM ----------------------------------------------------------------------------
if !install_python3! == 1 (
    set python_sha256=93cc3db75dffb4d56b9f64af43294f130f2c222a66de7a1325d0ce8f1ed62e26
    set python_exe_sha256=9042daa88b2d3879a51bfabc2d90d4a56da05ebf184b6492a22a46fdc1c936a4
    set python_version=3.9.0.2dot
    set python_version_nodot=3902
    set python_version_dot=3.9.0

    set python_zip=!downloads_dir!\win32_Winpython64-!python_version!.exe
    set python_dir=!tools_dir!\Winpython64-!python_version_nodot!
    set python_exe=!python_dir!\python-3.9.0.amd64\python.exe

    if not exist "!python_exe!" (
        call :DownloadFile "https://github.com/winpython/winpython/releases/download/3.0.20201028/Winpython64-!python_version!.exe" "!python_zip!" || exit /B
        call :VerifyFileSHA256 "!python_zip!" "!python_sha256!" || exit /B
        call :Unzip "!python_zip!" "!python_dir!" || exit /B
        call :Move "!python_dir!\WPy64-!python_version_nodot!" "!python_dir!" || exit /B
    )

    call :VerifyFileSHA256 "!python_exe!" "!python_exe_sha256!" || exit /B

    set python_bin_dir=!python_dir!\python-!python_version_dot!.amd64
    set python_scripts_bin_dir=!python_bin_dir!\Scripts
)

REM ----------------------------------------------------------------------------
REM Zig
REM ----------------------------------------------------------------------------
if !install_zig! == 1 (
    set zig_sha256=43573db14cd238f7111d6bdf37492d363f11ecd1eba802567a172f277d003926
    set zig_exe_sha256=465739a787178ded19efab55916b587f3ead2a9cdff8dcaaf1765fe907797917
    set zig_version=0.8.1

    set zig_file=zig-windows-x86_64-!zig_version!.zip
    set zig_zip=!downloads_dir!\win32_!zig_file!
    set zig_dir=!tools_dir!\zig-windows-x86_64-!zig_version!
    set zig_exe=!zig_dir!\zig.exe

    if not exist "!zig_exe!" (
        call :DownloadFile "https://ziglang.org/download/!zig_version!/!zig_file!" "!zig_zip!" || exit /B
        call :VerifyFileSHA256 "!zig_zip!" "!zig_sha256!" || exit /B
        call :Unzip "!zig_zip!" "!zig_dir!" || exit /B
    )

    call :VerifyFileSHA256 "!zig_exe!" "!zig_exe_sha256!" || exit /B
    call :MakeBatchShortcutInBinDir "zig" "!zig_exe!"
)

REM ----------------------------------------------------------------------------
REM QoL/Tools
REM ----------------------------------------------------------------------------
REM ----------------------------------------------------------------------------
REM clink - Bash style tab completion in terminal
REM ----------------------------------------------------------------------------
if !install_clink! == 1 (
    set clink_sha256=57618d5fab9f0f777430fde5beceffdfb99cc81cfbd353ca58f41b7faf84eddc
    set clink_exe_sha256=e09a338081b83a42e97b60311d9af749baaedb226b155d9e7bd658de1c5a349d
    set clink_version=0.4.9

    set clink_zip=!downloads_dir!\win32_clink_!clink_version!.zip
    set clink_dir=!tools_dir!\clink-!clink_version!
    set clink_exe=!clink_dir!\clink_x64.exe
    set clink_bat=!clink_dir!\clink.bat

    if not exist "!clink_exe!" (
        call :DownloadFile "https://github.com/mridgers/clink/releases/download/!clink_version!/clink_!clink_version!.zip" "!clink_zip!" || exit /B
        call :VerifyFileSHA256 "!clink_zip!" "!clink_sha256!" || exit /B
        call :Unzip "!clink_zip!" "!clink_dir!" || exit /B
        call :Move "!clink_dir!\clink_!clink_version!" "!clink_dir!" || exit /B
    )

    call :VerifyFileSHA256 "!clink_exe!" "!clink_exe_sha256!" || exit /B
    call :MakeBatchShortcutInBinDir "clink" "!clink_bat!"
)

REM ----------------------------------------------------------------------------
REM Dependencies (Walker) - For DLL dependency management
REM ----------------------------------------------------------------------------
if !install_dependency_walker! == 1 (
    set dependencies_sha256=44df956dbe267e0a705224c3b85d515fee2adc87509861e24fb6c6b0ea1b86d6
    set dependencies_exe_sha256=f9c9d78284d03b0457061cfb33751071c8c1ceeb26bc9b75ae9b7e0465e99858
    set dependencies_version=v1.10

    set dependencies_zip=!downloads_dir!\win32_dependencies_!dependencies_version!.zip
    set dependencies_dir=!tools_dir!\dependencies-!dependencies_version!
    set dependencies_exe=!dependencies_dir!\DependenciesGui.exe

    if not exist "!dependencies_exe!" (
        call :DownloadFile "https://github.com/lucasg/Dependencies/releases/download/!dependencies_version!/Dependencies_x64_Release.zip" "!dependencies_zip!" || exit /B
        call :VerifyFileSHA256 "!dependencies_zip!" "!dependencies_sha256!" || exit /B
        call :Unzip "!dependencies_zip!" "!dependencies_dir!" || exit /B
    )

    call :VerifyFileSHA256 "!dependencies_exe!" "!dependencies_exe_sha256!" || exit /B
)

REM ----------------------------------------------------------------------------
REM everything (void tools search program)
REM ----------------------------------------------------------------------------
if !install_everything_void_tools! == 1 (
    set everything_sha256=f61b601acba59d61fb0631a654e48a564db34e279b6f2cc45e20a42ce9d9c466
    set everything_exe_sha256=48a17c3c22476f642c2b1ab2da8dfd789e39882997d7a8e266104f7404a0ded9
    set everything_version=1.4.1.1009

    set everything_zip=!downloads_dir!\win32_everything_v!everything_version!.7z
    set everything_dir=!tools_dir!\everything-!everything_version!
    set everything_exe=!everything_dir!\everything.exe

    if not exist "!everything_exe!" (
        call :DownloadFile "https://www.voidtools.com/Everything-!everything_version!.x64.zip" "!everything_zip!" || exit /B
        call :VerifyFileSHA256 "!everything_zip!" "!everything_sha256!" || exit /B
        call :Unzip "!everything_zip!" "!everything_dir!" || exit /B
    )

    call :VerifyFileSHA256 "!everything_exe!" "!everything_exe_sha256!" || exit /B
)

REM ----------------------------------------------------------------------------
REM fzf
REM ----------------------------------------------------------------------------
if !install_fzf! == 1 (
    set fzf_sha256=c9b5c8bdbef06305a2d0a33b0d82218bebd5a81a3f2187624d4a9d8fe972fc09
    set fzf_exe_sha256=83cdcb08d65edc734205f9de5e87ef3261358a4abf6f21e1c97d431205da8bc9
    set fzf_version=0.27.2

    set fzf_zip=!downloads_dir!\win32_fzf_v!fzf_version!.zip
    set fzf_dir=!bin_dir!
    set fzf_exe=!fzf_dir!\fzf.exe

    if not exist "!fzf_exe!" (
        call :DownloadFile "https://github.com/junegunn/fzf/releases/download/!fzf_version!/fzf-!fzf_version!-windows_amd64.zip" "!fzf_zip!" || exit /B
        call :VerifyFileSHA256 "!fzf_zip!" "!fzf_sha256!" || exit /B
        call :UnzipAndAlwaysOverwrite "!fzf_zip!" "!fzf_dir!" || exit /B
    )
    call :VerifyFileSHA256 "!fzf_exe!" "!fzf_exe_sha256!" || exit /B
)

REM ----------------------------------------------------------------------------
REM GVim, Vim Plug, Vim Config
REM ----------------------------------------------------------------------------
if !install_gvim! == 1 (
    set gvim_zip=!downloads_dir!\win32_gvim_x64.7z
    set gvim_dir=!tools_dir!\GVim
    if not exist "!gvim_dir!\gvim.exe" (
        call :DownloadFile https://tuxproject.de/projects/vim/complete-x64.7z !gvim_zip! || exit /B
        call :Unzip "!gvim_zip!" "!gvim_dir!" || exit /B
    )

    call :CopyAndAlwaysOverwriteFile "!install_dir!\_vimrc" !home_dir!

    REM DLL that hooks into GVIM and provides fullscreen with F11
    set gvim_fullscreen_dll_sha256=1c83747b67ed73c05d44c1af8222a860bc5a48b56bf54cd6e21465a2deb78456
    set gvim_fullscreen_dll=!gvim_dir!\gvim_fullscreen.dll
    call :CopyAndAlwaysOverwriteFile "!install_dir!\win32_gvim_fullscreen.dll" "!gvim_fullscreen_dll!" || exit /B
    call :VerifyFileSHA256 "!gvim_fullscreen_dll!" "!gvim_fullscreen_dll_sha256!" || exit /B

    set vim_plug_dir=!vim_dir!\autoload
    set vim_plug=!vim_plug_dir!\plug.vim
    if not exist "!vim_plug_dir!" mkdir "!vim_plug_dir!"
    call :DownloadFile "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" "!vim_plug!" || exit /B
)

REM ----------------------------------------------------------------------------
REM Joplin
REM ----------------------------------------------------------------------------
if !install_joplin! == 1 (
    set joplin_sha256=816439f47c3288a484ff090a6d5e280979859fd610d6988bc3701d73a1b5dfc4
    set joplin_version=2.6.2

    set joplin_dir=!tools_dir!\joplin-x64-!joplin_version!
    set joplin_exe=!joplin_dir!\JoplinPortable.exe

    if not exist "!joplin_exe!" (
        if not exist "!joplin_dir!" mkdir "!joplin_dir!"
        call :DownloadFile "https://github.com/laurent22/joplin/releases/download/v!joplin_version!/JoplinPortable.exe" "!joplin_exe!" || exit /B
    )

    call :VerifyFileSHA256 "!joplin_exe!" "!joplin_sha256!" || exit /B
)

REM ----------------------------------------------------------------------------
REM Keypirinha
REM ----------------------------------------------------------------------------
if !install_keypirinha! == 1 (
    set keypirinha_sha256=d109a16e6a5cf311abf6d06bbe5b1be3b9ba323b79c32a168628189e10f102a5
    set keypirinha_exe_sha256=2d3adb36a04e9fdf94636c9ac5d4c2b754accbfaecd81f4ee7189c3c0edc8af1
    set keypirinha_version=2.26

    set keypirinha_zip=!downloads_dir!\win32_keypirinha-x64-!keypirinha_version!.7z
    set keypirinha_dir=!tools_dir!\keypirinha-x64-!keypirinha_version!
    set keypirinha_exe=!keypirinha_dir!\keypirinha.exe

    if not exist "!keypirinha_exe!" (
        call :DownloadFile "https://github.com/Keypirinha/Keypirinha/releases/download/v!keypirinha_version!/keypirinha-!keypirinha_version!-x64-portable.7z" "!keypirinha_zip!" || exit /B
        call :VerifyFileSHA256 "!keypirinha_zip!" "!keypirinha_sha256!" || exit /B
        call :Unzip "!keypirinha_zip!" "!keypirinha_dir!" || exit /B
        call :Move "!keypirinha_dir!\keypirinha" "!keypirinha_dir!" || exit /B
    )

    call :VerifyFileSHA256 "!keypirinha_exe!" "!keypirinha_exe_sha256!" || exit /B
)

REM ----------------------------------------------------------------------------
REM Misc Tools
REM ----------------------------------------------------------------------------
REM ctags: C/C++ code annotation generator
REM scanmapset: Bind capslock to escape via registry
REM uncap: Bind capslock to escape via run-time program
call :CopyAndAlwaysOverwriteFile "!install_dir!\win32_ctags.exe" "!bin_dir!\ctags.exe" || exit /B
call :CopyAndAlwaysOverwriteFile "!install_dir!\win32_scanmapset.exe" "!bin_dir!\scanmapset.exe" || exit /B
call :CopyAndAlwaysOverwriteFile "!install_dir!\win32_uncap.exe" "!bin_dir!\uncap.exe" || exit /B
call :CopyAndAlwaysOverwriteFile "!install_dir!\clang_format_style_file" "!home_dir!\_clang-format" || exit /B
call :CopyAndAlwaysOverwriteFile "!install_dir!\win32_download_windows_symbols_pdb" "!bin_dir!\download_windows_symbols_pdb.bat" || exit /B

REM ------------------------------------------------------------------------
REM MobaXTerm
REM ------------------------------------------------------------------------
if !install_mobaxterm! == 1 (
    set mobaxterm_sha256=91f80537f12c2ad34a5eba99a285c149781c6d35a144a965ce3aea8a9bc6868c
    set mobaxterm_exe_sha256=1053c81b44018d6e6519a9c80d7413f7bb36e9f6e43b3da619b2229aa362a522
    set mobaxterm_version=21.2

    set mobaxterm_zip=!downloads_dir!\win32_mobaxterm-!mobaxterm_version!.zip
    set mobaxterm_dir=!tools_dir!\mobaxterm-!mobaxterm_version!
    set mobaxterm_exe=!mobaxterm_dir!\MobaXterm_Personal_21.2.exe

    if not exist "!mobaxterm_exe!" (
        call :DownloadFile "https://download.mobatek.net/2122021051924233/MobaXterm_Portable_v!mobaxterm_version!.zip" !mobaxterm_zip! || exit /B
        call :VerifyFileSHA256 !mobaxterm_zip! !mobaxterm_sha256! || exit /B
        call :Unzip !mobaxterm_zip! !mobaxterm_dir! || exit /B
    )

    call :VerifyFileSHA256 !mobaxterm_exe! !mobaxterm_exe_sha256! || exit /B
)

REM ----------------------------------------------------------------------------
REM O&O ShutUp10 (Privacy Tool for Windows)
REM ----------------------------------------------------------------------------
if !install_ooshutup10! == 1 (

    REM We don't do SHA256 here since we don't get a versioned URL, this can
    REM change at a whim and it'd be painful to have to reupdate the script
    REM everytime.

    set oo_shutup_10_dir=!tools_dir!\oo_shutup_10
    set oo_shutup_10_file=!oo_shutup_10_dir!\oo_shutup_10.exe

    if not exist "!oo_shutup_10_file!" (
        if not exist "!oo_shutup_10_dir!" mkdir "!oo_shutup_10_dir!"
        call :DownloadFile "https://dl5.oo-software.com/files/ooshutup10/OOSU10.exe" "!oo_shutup_10_file!" || exit /B
    )
)

REM ----------------------------------------------------------------------------
REM ProcessHacker
REM ----------------------------------------------------------------------------
if !install_process_hacker! == 1 (
    set process_hacker_sha256=e8836365abab7478d8e4c2d3fb3bb1fce82048cd4da54bab41cacbae1f45b1ff
    set process_hacker_exe_sha256=46367bfcf4b150da573a74d91aa2f7caf7a0789741bc65878a028e91ffbf5e42
    set process_hacker_version=3.0.4212

    set process_hacker_zip=!downloads_dir!\win32_process_hacker-!process_hacker_version!.zip
    set process_hacker_dir=!tools_dir!\process_hacker-!process_hacker_version!
    set process_hacker_exe=!process_hacker_dir!\64bit\ProcessHacker.exe

    if not exist "!process_hacker_exe!" (
        call :DownloadFile "https://ci.appveyor.com/api/buildjobs/8say005q9xy48cc3/artifacts/processhacker-!process_hacker_version!-bin.zip" "!process_hacker_zip!" || exit /B
        call :VerifyFileSHA256 "!process_hacker_zip!" "!process_hacker_sha256!" || exit /B
        call :Unzip "!process_hacker_zip!" "!process_hacker_dir!" || exit /B
    )

    call :VerifyFileSHA256 "!process_hacker_exe!" "!process_hacker_exe_sha256!" || exit /B
)

REM ----------------------------------------------------------------------------
REM ripgrep
REM ----------------------------------------------------------------------------
if !install_ripgrep! == 1 (
    set rg_sha256=a47ace6f654c5ffa236792fc3ee3fefd9c7e88e026928b44da801acb72124aa8
    set rg_exe_sha256=ab5595a4f7a6b918cece0e7e22ebc883ead6163948571419a1dd5cd3c7f37972
    set rg_version=13.0.0

    set rg_zip=!downloads_dir!\win32_rg_v!rg_version!.zip
    set rg_dir=!tools_dir!\ripgrep-!rg_version!
    set rg_exe=!rg_dir!\rg.exe

    if not exist "!rg_exe!" (
        call :DownloadFile "https://github.com/BurntSushi/ripgrep/releases/download/!rg_version!/ripgrep-!rg_version!-x86_64-pc-windows-msvc.zip" "!rg_zip!" || exit /B
        call :VerifyFileSHA256 "!rg_zip!" "!rg_sha256!" || exit /B
        call :Unzip "!rg_zip!" "!rg_dir!" || exit /B
        call :Move "!rg_dir!\ripgrep-!rg_version!-x86_64-pc-windows-msvc" "!rg_dir!" || exit /B
    )

    call :VerifyFileSHA256 "!rg_exe!" "!rg_exe_sha256!" || exit /B
    call :MakeBatchShortcutInBinDir "rg" "!rg_exe!"
)

REM ----------------------------------------------------------------------------
REM Ethereum
REM ----------------------------------------------------------------------------
REM ----------------------------------------------------------------------------
REM geth
REM ----------------------------------------------------------------------------
if !install_geth! == 1 (
    set geth_md5=a975ba6591577b6f5b19f4fd8757fd03
    set geth_exe_sha256=7d9fd1566f2fd07c741a64aad2865b25f8cd82388e15bed2d68e92105b1e0fd3
    set geth_version=1.10.8-26675454

    set geth_zip=!downloads_dir!\win32_geth-amd64-v!geth_version!.zip
    set geth_dir=!tools_dir!\geth-windows-amd64-!geth_version!
    set geth_exe=!geth_dir!\geth.exe

    set geth_gpg_key=!downloads_dir!\..\geth_windows_builder_gpg_key.asc
    set geth_gpg_sig=!geth_zip!.asc

    if not exist "!geth_exe!" (
        call :DownloadFile "https://gethstore.blob.core.windows.net/builds/geth-windows-amd64-!geth_version!.zip" "!geth_zip!" || exit /B
        call :DownloadFile "https://gethstore.blob.core.windows.net/builds/geth-windows-amd64-!geth_version!.zip.asc" "!geth_gpg_sig! || exit /B
        call :VerifyFileMD5 "!geth_zip!" "!geth_md5!" || exit /B

        gpg --import "!geth_gpg_key!" || exit /B
        gpg --verify "!geth_gpg_sig!" "!geth_zip!" || exit /B
        call :Unzip "!geth_zip!" "!geth_dir!" || exit /B
    )

    call :VerifyFileSHA256 "!geth_exe!" "!geth_exe_sha256!" || exit /B
    call :MakeBatchShortcutInBinDir "geth" "!geth_exe!"
)

REM ----------------------------------------------------------------------------
REM remix_ide
REM ----------------------------------------------------------------------------
if !install_remix_ide! == 1 (
    set remix_ide_sha256=19a56cb79459e612d8cbdd6b6729d06c7080d983537d2494a15fd25ea67b2499
    set remix_ide_exe_sha256=960bc454e37a718b86018b596d14ed977d1a8e1a5bc57b5afd573fc5e9b84a47
    set remix_ide_version=1.3.1

    set remix_ide_zip=!downloads_dir!\win32_remix-ide-amd64-v!remix_ide_version!.zip
    set remix_ide_dir=!tools_dir!\remix-ide-!remix_ide_version!
    set remix_ide_exe=!remix_ide_dir!\Remix IDE.exe

    if not exist "!remix_ide_exe!" (
        call :DownloadFile "https://github.com/ethereum/remix-desktop/releases/download/v!remix_ide_version!/Remix-IDE-!remix_ide_version!-win.zip" "!remix_ide_zip!" || exit /B
        call :VerifyFileSHA256 "!remix_ide_zip!" "!remix_ide_sha256!" || exit /B
        call :Unzip "!remix_ide_zip!" "!remix_ide_dir!" || exit /B
    )

    call :VerifyFileSHA256 "!remix_ide_exe!" "!remix_ide_exe_sha256!" || exit /B
)

REM ----------------------------------------------------------------------------
REM solidity
REM ----------------------------------------------------------------------------
if !install_solidity! == 1 (
    set solidity_exe_sha256=82db83111c6e2c892179486cb7050d85f1517bf851027607eb7f4e589e714bc5
    set solidity_version=0.8.7+commit.e28d00a7

    set solidity_dir=!tools_dir!\solidity-windows-amd64-!solidity_version!
    set solidity_exe=!solidity_dir!\solc.exe

    if not exist "!solidity_exe!" (
        if not exist "!solidity_dir!" mkdir "!solidity_dir!"
        call :DownloadFile "https://binaries.soliditylang.org/windows-amd64/solc-windows-amd64-v!solidity_version!.exe" "!solidity_exe!" || exit /B
    )

    call :VerifyFileSHA256 "!solidity_exe!" "!solidity_exe_sha256!" || exit /B
    call :MakeBatchShortcutInBinDir "solc" "!solidity_exe!"
)

REM ----------------------------------------------------------------------------
REM Super Terminal
REM ----------------------------------------------------------------------------
set terminal_script=!root_dir!\win32_terminal.bat
set msvc_script=!tools_dir!\MSVC-2019-v16.9.2-VC-v14.28.29910-Win10-SDK-v10.0.19041.0-x64\msvc_env_x64.bat

echo @echo off> "!terminal_script!"

echo set APPDATA=%%~dp0!home_dir!\AppData>> "!terminal_script!"
echo set HOME=%%~dp0!home_dir!>> "!terminal_script!"
echo set HOMEPATH=%%~dp0!home_dir!>> "!terminal_script!"
echo set USERPROFILE=%%~dp0!home_dir!>> "!terminal_script!"
echo set LOCALAPPDATA=%%~dp0!home_dir!\AppData\Local>> "!terminal_script!"

echo set PATH=%%~dp0!gpg_w32_bin_dir!;%%PATH%%>> "!terminal_script!"
echo set PATH=%%~dp0!bin_dir!;%%PATH%%>> "!terminal_script!"

if !install_fzf! == 1 (
    echo set FZF_DEFAULT_OPTS=--multi --layout=reverse>> "!terminal_script!"

    REM Use RG for FZF to make it ultra fast
    if !install_ripgrep! == 1 (
        echo set FZF_DEFAULT_COMMAND=rg --files --no-ignore-vcs --hidden>> "!terminal_script!"
    )
)

if !install_git! == 1 (
    echo set PATH=%%~dp0!git_dir!\cmd;%%PATH%%>> "!terminal_script!"
    echo set PATH=%%~dp0!git_dir!\mingw64\bin;%%PATH%%>> "!terminal_script!"
    echo set PATH=%%~dp0!git_dir!\usr\bin;%%PATH%%>> "!terminal_script!"
)

if !install_gvim! == 1 ( echo set PATH=%%~dp0!gvim_dir!;%%PATH%%>> "!terminal_script!" )
if !install_llvm_clang! == 1 ( echo set PATH=%%~dp0!llvm_bin_dir!;%%PATH%%>> "!terminal_script!" )
if !install_mingw64! == 1 ( echo set PATH=%%~dp0!mingw_bin_dir!;%%PATH%%>> "!terminal_script!" )
if !install_nodejs! == 1 ( echo set PATH=%%~dp0!nodejs_dir!;%%PATH%%>> "!terminal_script!" )

if !install_python3! == 1 (
    echo set PATH=%%~dp0!python_bin_dir!;%%PATH%%>> "!terminal_script!"
    echo set PATH=%%~dp0!python_scripts_bin_dir!;%%PATH%%>> "!terminal_script!"
    echo set PYTHONHOME=%%~dp0!python_bin_dir!>> "!terminal_script!"
)

echo set PATH=%%~dp0!zip7_dir!;%%PATH%%>> "!terminal_script!"
echo if exist "%%~dp0!msvc_script!" call "%%~dp0!msvc_script!">> "!terminal_script!"
echo if exist "%%~dp0win32_terminal_user_config.bat" call "%%~dp0win32_terminal_user_config.bat">> "!terminal_script!"

if !install_wezterm! == 1 (
    echo start "" /MAX "%%~dp0!wezterm_exe!">> "!terminal_script!"
    echo exit>> "!terminal_script!"
)

REM ----------------------------------------------------------------------------
REM Background Application Scripts
REM ----------------------------------------------------------------------------
set terminal_script=!root_dir!\win32_start_background_apps.bat
echo @echo off> "!terminal_script!"
if !install_everything_void_tools! == 1 echo start "" "%%~dp0!everything_dir!\everything.exe">> "!terminal_script!"
if !install_keypirinha! == 1 echo start "" "%%~dp0!keypirinha_dir!\keypirinha.exe">> "!terminal_script!"

REM ----------------------------------------------------------------------------
REM CTags Helper Script
REM ----------------------------------------------------------------------------
set ctags_file=!bin_dir!\ctags_cpp.bat
echo @echo off> "!ctags_file!"
echo ctags --c++-kinds=+p --fields=+iaS --extras=+q %%*>> !ctags_file!

echo - Setup complete. Launch !root_dir!\win32_terminal.bat [or restart Wezterm instance if you're updating an existing installation]
echo - (Optional) A custom font is provided and requires manual intallation in Windows at !jetbrains_mono_file!
echo              This font will be used in GVIM if it's available.
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
:CopyAndAlwaysOverwriteFile
set src_file=%~1
set dest_file=%~2

echo - [Copy] !src_file! to !dest_file!
call copy /Y !src_file! !dest_file! > nul

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
:UnzipAndAlwaysOverwrite
set zip_file=%~1
set dest=%~2
set msg=[Unzip] !zip_file! to !dest!

echo - !msg!
call !zip7_dir!\7z.exe x -y -spe -o!dest! !zip_file!
exit /B !ERROLEVEL!

REM ------------------------------------------------------------------------------------------------
:VerifyFileSHA256
set file=%~1
set expected_sha256=%~2

REM Calculate hash
set calculated_sha256_file=!file!.sha256.txt
call powershell "$FileHash = Get-FileHash -algorithm sha256 \"!file!\"; $FileHash.Hash.ToLower()" > !calculated_sha256_file!

REM Verify Hash
set /p actual_sha256=< !calculated_sha256_file!
if "!expected_sha256!" neq "!actual_sha256!" (
    echo - [Verify] !file!
    echo sha256 hash does not match, failing.
    echo Expected:   !expected_sha256!
    echo Calculated: !actual_sha256!
    exit /B -1
) else (
    echo - [Verify] !file! Hash OK: !expected_sha256!
    exit /B 0
)

REM ------------------------------------------------------------------------------------------------
:VerifyFileMD5
set file=%~1
set expected_md5=%~2

REM Calculate hash
set calculated_md5_file=!file!.md5.txt
call powershell "$FileHash = Get-FileHash -algorithm md5 \"!file!\"; $FileHash.Hash.ToLower()" > !calculated_md5_file!

REM Verify Hash
set /p actual_md5=< !calculated_md5_file!
if "!expected_md5!" neq "!actual_md5!" (
    echo - [Verify] !file!
    echo md5 hash does not match, failing.
    echo Expected:   !expected_md5!
    echo Calculated: !actual_md5!
    exit /B -1
) else (
    echo - [Verify] !file! Hash OK: !expected_md5!
    exit /B 0
)

REM ------------------------------------------------------------------------------------------------
:Move
set src=%~1
set dest=%~2
if exist !src! robocopy !src! !dest! /E /MOVE /NP /NJS /NJS /NS /NC /NFL /NDL
exit /B 0

REM ------------------------------------------------------------------------------------------------
:MakeBatchShortcutInBinDir
REM NOTE we make a batch file instead of a symlink because symlinks require
REM admin privileges in windows ...
set script_name=%~1
set executable=%~2
echo @echo off> "!bin_dir!\!script_name!.bat"
echo %%~dp0..\..\!executable! %%*>> "!bin_dir!\!script_name!.bat"
exit /B 0
