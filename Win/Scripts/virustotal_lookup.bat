@echo off

:: Check if an argument is provided
if "%~1"=="" (
    echo Usage: %0 FILE_PATH
    exit /b
)

:: Calculate SHA256 hash using PowerShell and store it in a variable
for /f "delims=" %%a in ('powershell -Command "(Get-FileHash \"%~1\" -Algorithm SHA256).Hash"') do set HASH=%%a

:: Open browser with VirusTotal URL
start https://www.virustotal.com/gui/file/%HASH%
