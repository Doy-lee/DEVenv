@echo off

REM Reference
REM https://stackoverflow.com/questions/58345011/setup-windows-10-workstation-using-ansible-installed-on-wsl
REM https://4sysops.com/wiki/disable-powershell-remoting-disable-psremoting-winrm-listener-firewall-and-localaccounttokenfilterpolicy/

powershell -Command "Set-Item -Path WSMan:\localhost\Service\Auth\Basic -Value $false"
powershell -Command "Set-Item -Path WSMan:\localhost\Service\AllowUnencrypted -Value $false"
powershell -Command "Disable-PSRemoting"

powershell -Command "Stop-Service WinRM -PassThru"
powershell -Command "Set-Service WinRM -StartupType Disabled -PassThru"
powershell -Command "Set-NetFirewallRule -DisplayName 'Windows Remote Management (HTTP-In)' -Enabled False -PassThru | Select -Property DisplayName, Profile, Enabled"
