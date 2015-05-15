@echo off
:: Install and configure most of the existing PM active directory software
set DeploymentServer=\\pmdc2.pennmanor.net\installs

:: Set up remote file mounts
net use %DeploymentServer% /user:pmsd_dj <PASSWORD>
echo %time% :: Using Deployment Server %DeploymentServer%

:: Install Office 2013
echo %time% :: Starting Office Setup
start /wait %DeploymentServer%\msoffice2013\setup.exe
echo %time% :: Office Setup Complete

:: Install the various Ninite Apps
:: Use a pre-defined list of apps as input
set /p Selections=<%DeploymentServer%\ninite\selections.txt
echo %time% :: Installing Ninite Software
echo Selected: %Selections%
start /wait %DeploymentServer%\ninite\NiniteOne.exe /silent /disableautoupdate /allusers /disableshortcuts /select %Selections%
echo %time% :: Installed Ninite Software

:: Install Frontmotion Firefox
echo %time% :: Starting Firefox Setup
msiexec /qn /i %DeploymentServer%\firefox\latest\FirefoxESR-latest.msi TRANSFORMS=%DeploymentServer%\firefox\latest\FirefoxESR-latest.mst
echo %time% :: Firefox Setup Complete

:: Install Mimio
echo %time% :: Starting Mimio Setup
msiexec /qn /i %DeploymentServer%\mimiostudio\latest\mimio-studio-latest.msi TRANSFORMS=%DeploymentServer%\mimiostudio\latest\mimio-studio-latest.mst
echo %time% :: Mimio Studio Setup Complete

:: Install Splashtop
echo %time% :: Starting Splashtop Setup
msiexec /qn /i %DeploymentServer%\Splashtop\latest\Splashtop-latest.msi
echo %time% :: Splashtop Setup Complete

:: Install ownCloud Client
echo %time% :: Starting ownCloud Setup
msiexec /qn /i %DeploymentServer%\ownCloud\owncloud-1.8.0.msi
echo %time% :: ownCloud Setup Complete

:: Configure Comets Wireless
start %DeploymentServer%\comets\comets.bat
echo %time% :: Comets WiFi Setup Complete

:: Create the IT Tools Folders in the main directory
if not exist "C:\IT Tools" mkdir "C:\IT Tools"
echo %time% :: IT Tools Folder Created

:: Populate the IT Tools folder with the handy-dandy Windows Update Script
xcopy /y "%DeploymentServer%\win-updates.ps1" "C:\IT Tools"
echo %time% :: Created WinUpdates powershell script in IT Tools Folder

:: Set up Powershell execution policy for current user (admin)
:: This allows provisioning scripts to be run as local admin during the setup phase
:: See: https://technet.microsoft.com/en-us/library/hh849812.aspx
powershell -Command "Set-ExecutionPolicy Bypass -Scope CurrentUser -Force"

:: Re-Run Windows Updates
:: This should be run LAST, so that any previous software installs (especially Office) get updates
:: Further, the win-updates script on %DeploymentServer is modified so that SSH doesn't get reinstalled.
powershell -Command "%DeploymentServer%\win-updates.ps1"
