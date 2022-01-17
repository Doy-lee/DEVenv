@echo off
set dest_dir="%~dp0Windows_Symbols_PDBs"
set symchk="C:\Program Files (x86)\Windows Kits\10\Debuggers\x64\symchk.exe"

if not exist %symchk% (
    echo Symchk binary not found but is required to run script [path=%symchk%]
    exit /b 1
)

if not exist %dest_dir% mkdir %dest_dir%
echo Downloading to %dest_dir% with %symchk%
%symchk% /r C:\Windows /s srv*%dest_dir%*https://msdl.microsoft.com/download/symbols
goto :eof
