@echo off
setlocal EnableDelayedExpansion
REM Win Helpers - Version 11
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
    echo [DownloadFile] Download failed [url=!url!]
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
REM Overwrite mode: "-aos" Skip extracting of existing files
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

echo - [Unzip] !zip_file! to !dest!
call !zip7_dir!\7z.exe x -y -aos -spe -o!dest! !zip_file!
exit /B %ERRORLEVEL%

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
for /F %%c in ('powershell -NoLogo -NoProfile -NonInteractive "Get-FileHash -algorithm !algorithm! \"!file!\" | Select-Object -ExpandProperty Hash "') do ( set "actual=%%c" )

REM Verify Hash
if /I "!expected!" neq "!actual!" (
    echo - [FileHashCheck] !algorithm! failed [file=!file!,
    echo     expect=!expected!,
    echo     actual=!actual!
    echo   ]
    exit /B 1
)

echo - [FileHashCheck] !algorithm! OK [file=!file! hash=!expected!]
exit /B 0

:MoveDir
REM call win_helpers.bat :MoveDir <src> <dest>
REM ------------------------------------------------------------------------------------------------
set src=%~1
set dest=%~2

if not exist "!src!" (
    echo - [MoveDir] Directory does not exist [dir=%src%]
    exit /B 1
)

echo - [MoveDir] "!src!" to "!dest!"
robocopy "!src!" "!dest!" /E /MOVE /MT /NP /NJS /NS /NC /NFL /NDL
exit /B 0

:MakeBatchShortcut
REM call win_helpers.bat :MakeBatchShortcut <name> <exe> <dest_dir>
REM ------------------------------------------------------------------------------------------------
REM NOTE we make a batch file instead of a symlink because symlinks require
REM admin privileges in windows ...
set name=%~1
set executable=%~2
set dest_dir=%~3

if not exist "!executable!" (
    echo - [MakeBatchShortcut] Executable for shortcut does not exist [exe=%executable%]
    exit /B 1
)

if not exist "!dest_dir!" (
    echo - [MakeBatchShortcut] Shortcut destination directory does not exist [dir=%dest_dir%]
    exit /B 1
)

echo - [MakeBatchShortcut] Create [name=!name!, exe=!executable!, dest=!dest_dir!]
echo @echo off> "!dest_dir!\!name!.bat"
echo !executable! %%*>> "!dest_dir!\!name!.bat"
exit /B 0

:MakeRelativeBatchShortcut
REM call win_helpers.bat :MakeRelativeBatchShortcut <name> <exe> <dest_dir>
REM ------------------------------------------------------------------------------------------------
REM NOTE we make a batch file instead of a symlink because symlinks require
REM admin privileges in windows ...
set name=%~1
set executable=%~2
set dest_dir=%~3

if not exist "!dest_dir!\!executable!" (
    echo - [MakeRelativeBatchShortcut] Executable for shortcut does not exist [exe=!dest_dir!\%executable%]
    exit /B 1
)

if not exist "!dest_dir!" (
    echo - [MakeRelativeBatchShortcut] Shortcut destination directory does not exist [dir=%dest_dir%]
    exit /B 1
)

echo - [MakeRelativeBatchShortcut] Create [name=!name!, exe=!dest_dir!\!executable!, dest=!dest_dir!]
echo @echo off> "!dest_dir!\!name!.bat"
echo %%~dp0!executable! %%*>> "!dest_dir!\!name!.bat"
exit /B 0

:MakeFileHardLink
REM call win_helpers.bat :MakeFileHardLink dest src
REM ------------------------------------------------------------------------------------------------
set dest=%~1
set src=%~2
if not exist "!src!" (
    echo - [MakeFileHardLink] Source file does not exist [src=!src!]
    exit /B 1
)

if exist "%dest%" (
    del "!dest!"
    if exist "!dest!" (
        echo - [MakeFileHardLink] Failed to delete destination file [dest=!dest!]
        exit /B 1
    )
)

mklink /H "!dest!" "!src!"
if not exist "!dest!" (
    echo - [MakeFileHardLink] Failed to make hard link at dest [src=!src!, dest=!dest!]
    exit /B 1
)
exit /B 0

:MakeDirHardLink
REM call win_helpers.bat :MakeDirHardLink dest src
REM ------------------------------------------------------------------------------------------------
set dest=%~1
set src=%~2
if not exist "!src!" (
    echo - [MakeDirHardLink] Source file does not exist [src=!src!]
    exit /B 1
)

if exist "%dest%" (
    rmdir /S /Q "!dest!"
    if exist "!dest!" (
        echo - [MakeDirHardLink] Failed to delete destination dir [dest=!dest!]
        exit /B 1
    )
)

mklink /J "!dest!" "!src!"
if not exist "!dest!" (
    echo - [MakeDirHardLink] Failed to make hard link at dest [src=!src!, dest=!dest!]
    exit /B 1
)
exit /B 0

:exit
exit /B
