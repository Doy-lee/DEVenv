@echo off
set dest_dir="%~dp0Windows_Symbols_PDBs"
set symchk="C:\Program Files (x86)\Windows Kits\10\Debuggers\x64\symchk.exe"

if "%~1"=="" goto :usage

if not exist %symchk% (
    echo Symchk binary not found but is required to run script [path=%symchk%]
    exit /b 1
)
goto :eof

if not exist %dest_dir% mkdir %dest_dir%
echo Downloading to %dest_dir% with %symchk%
%symchk% /r "%1" /s srv*%dest_dir%*https://msdl.microsoft.com/download/symbols
goto :eof

:usage
echo Usage: download_windows_symbol_pdb.bat executable_to_check
