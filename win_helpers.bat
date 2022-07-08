@echo off
setlocal EnableDelayedExpansion
REM Win Helpers - Version 2
call %*
goto exit

:DownloadFile
REM call win_helpers.bat :DownloadFile <url> <dest>
REM ------------------------------------------------------------------------------------------------
set url=%~1
set dest_file=%~2

if exist "!dest_file!" (
    echo - [DownloadFile/Cached] !url! to !dest_file!
) else (
    echo - [DownloadFile] !url! to !dest_file!
    call powershell -NoLogo -NoProfile -NonInteractive -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $ProgressPreference = 'SilentlyContinue'; Invoke-WebRequest !url! -OutFile !dest_file! -UserAgent [Microsoft.PowerShell.Commands.PSUserAgent]::FireFox"
)

if exist "!dest_file!" (
    exit /B 0
) else (
    echo [Download File] Failed to download file from !url!
    exit /B 1
)

:OverwriteCopy
REM ------------------------------------------------------------------------------------------------
set src_file=%~1
set dest_file=%~2

if not exist "!src_file!" (
    echo - [OverwriteCopy] File to copy does not exist [file=%src_file%]
    exit /B 1
)

echo - [OverwriteCopy] !src_file! to !dest_file!
call copy /Y !src_file! !dest_file! > nul
exit /B 0

:Unzip
REM call win_helpers.bat :Unzip <path/to/7z.exe> <zip_file> <dest>
REM ------------------------------------------------------------------------------------------------
set zip7_exe=%~1
set zip_file=%~2
set dest=%~3

if not exist "!zip7_exe!" (
    echo - [Unzip] Failed, 7zip exe not found [path=%zip7_exe%]
    exit /B 1
)

if not exist "!zip_file!" (
    echo - [Unzip] Failed, zip to unzip does not exist [path=%zip_file%]
    exit /B 1
)

if exist !dest! (
    echo - [Unzip/Cached] !zip_file! to !dest!
) else (
    echo - [Unzip] !zip_file! to !dest!
    call !zip7_dir!\7z.exe x -y -spe -o!dest! !zip_file!
)
exit /B 0

:FileHashCheck
REM call win_helpers.bat :FileHashCheck [sha256|md5|...] <file> <hash>
REM ------------------------------------------------------------------------------------------------
set algorithm=%~1
set file=%~2
set expected=%~3

if not exist "!file!" (
    echo - [FileHashCheck] File does not exist [file=%file%]
    exit /B 1
)

REM Calculate hash
for /F "tokens=2 delims= " %%c in ('powershell -NoLogo -NoProfile -NonInteractive Get-FileHash -algorithm !algorithm! \"!file!\" ') do ( set "actual=%%c" )

REM Verify Hash
if /I "!expected!" neq "!actual!" (
    echo - [FileHashCheck] !file!
    echo !algorithm! hash does not match, failing.
    echo Expected: !expected!
    echo Actual:   !actual!
    exit /B 1
)

echo - [Verify] !algorithm! Hash OK: !file! !expected!
exit /B 0

:Move
REM call win_helpers.bat :Move <src> <dest>
REM ------------------------------------------------------------------------------------------------
set src=%~1
set dest=%~2

if not exist "!src!" (
    echo - [Move] File/path does not exist [file=%src%]
    exit /B 1
)

echo - [Move] Move "!src!" to "!dest!"
robocopy "!src!" "!dest!" /E /MOVE /NP /NJS /NJS /NS /NC /NFL /NDL
exit /B 0

:MakeBatchShortcut
REM call win_helpers.bat :MakeBatchShortcut <name> <src> <dest_dir>
REM ------------------------------------------------------------------------------------------------
REM NOTE we make a batch file instead of a symlink because symlinks require
REM admin privileges in windows ...
set name=%~1
set executable=%~2
set dest_dir=%~3

if not exist "!executable!" (
    echo - [MakeBatchShortcut] Executable to make shortcut to does not exist [executable=%executable%]
    exit /B %ERRORLEVEL%
)

if not exist "!dest_dir!" (
    echo - [MakeBatchShortcut] Shortcut destination directory does not exist [dir=%dest_dir%]
    exit /B %ERRORLEVEL%
)

echo - [MakeBatchShortcut] Shortcut [name=!name!, exe=!executable!, dest=!dest_dir!]
echo @echo off> "!dest_dir!\!name!.bat"
echo !executable! %%*>> "!dest_dir!\!name!.bat"
exit /B 0

:exit
exit /B
