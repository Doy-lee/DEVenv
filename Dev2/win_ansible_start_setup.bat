@echo off

REM Reference
REM https://stackoverflow.com/questions/58345011/setup-windows-10-workstation-using-ansible-installed-on-wsl

set script_dir_backslash=%~dp0
set script_dir=%script_dir_backslash:~0,-1%

REM Disable the virtual adapter for WSL. Virtual adapters for WSL2 are created
REM using Hyper-V and are forced to the public profile. PSRemoting can not be
REM enabled if there are any adapters with a public profile for security
REM reasons. Here we disable the adapter and re-enable it afterwards.
powershell -Command "Disable-NetAdapter -Name \"vEthernet (WSL)\" -Confirm:$false"

REM Enable remote control capabilities
powershell -Command "Enable-PSRemoting" || goto :cleanup

REM Allow basic unencrypted authentication
powershell -Command "Set-Item -Path WSMan:\localhost\Service\Auth\Basic -Value $true" || goto :cleanup
powershell -Command "Set-Item -Path WSMan:\localhost\Service\AllowUnencrypted -Value $true" || goto :cleanup

REM Re-enable the adapter after setting up all the options
powershell -Command "Enable-NetAdapter -Name \"vEthernet (WSL)\" -Confirm:$false" || goto :cleanup
goto :eof

:cleanup
REM Ensure the adapter is re-enabled.
powershell -Command "Enable-NetAdapter -Name \"vEthernet (WSL)\" -Confirm:$false" || goto :cleanup
call %script_dir%\win_ansible_end_setup.bat

