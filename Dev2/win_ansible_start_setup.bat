@echo off

REM Reference
REM https://stackoverflow.com/questions/58345011/setup-windows-10-workstation-using-ansible-installed-on-wsl

set script_dir_backslash=%~dp0
set script_dir=%script_dir_backslash:~0,-1%

powershell -Command "Enable-PSRemoting" || goto :cleanup
powershell -Command "Set-Item -Path WSMan:\localhost\Service\Auth\Basic -Value $true" || goto :cleanup
powershell -Command "Set-Item -Path WSMan:\localhost\Service\AllowUnencrypted -Value $true" || goto :cleanup
goto :eof

:cleanup
call %script_dir%\win_ansible_end_setup.bat

