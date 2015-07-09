@echo off
:: Set up Powershell execution policy for current user (admin)
:: This allows provisioning scripts to be run as local admin during the setup phase
:: See: https://technet.microsoft.com/en-us/library/hh849812.aspx
powershell -Command "Set-ExecutionPolicy Bypass -Scope CurrentUser -Force"

:: Re-Run Windows Updates
:: This should be run LAST, so that any previous software installs (especially Office) get updates
:: Further, the win-updates script on %DeploymentServer is modified so that SSH doesn't get reinstalled.
echo %time% :: Starting WinUpdates powershell script in IT Tools Folder
powershell -Command "C:\IT Tools\win-updates.ps1"

:: One last restart before continuing with the process.
echo %time% :: Windows Updates complete, restarting.
shutdown.exe /r /f /t 30
