@echo off
:: Install and configure most of the existing PM active directory software
set DeploymentServer=\\pmdc2.pennmanor.net\installs

:: Set up remote file mounts
net use %DeploymentServer% /user:pmsd_dj <PASSWORD>

:: Install Office 2013
start /wait %DeploymentServer%\msoffice2013\setup.exe
:: Custom Office Patch File
msiexec /p %DeploymentServer%\msoffice2013\updates\pmsdcustom.MSP /qn
echo "Office Setup Complete"

:: Install Frontmotion Firefox
msiexec /qn /i %DeploymentServer%\firefox\latest\FirefoxESR-latest.msi TRANSFORMS=%DeploymentServer%\firefox\latest\FirefoxESR-latest.mst
echo "Firefox Setup Complete"

:: Install Mimio
msiexec /qn /i %DeploymentServer%\mimiostudio\latest\mimio-studio-latest.msi TRANSFORMS=%DeploymentServer%\mimiostudio\latest\mimio-studio-latest.mst
echo "Mimio Studio Setup Complete"

:: Install Splashtop
msiexec /qn /i %DeploymentServer%\Splashtop\latest\Splashtop-latest.msi
echo "Splashtop Setup Complete"

:: Install ownCloud Client
msiexec /qn /i %DeploymentServer%\ownCloud\owncloud-1.8.0.msi
echo "ownCloud Setup Complete"

:: Install the various Ninite Apps
:: Use a pre-defined list of apps as input
set /p Selections=<%DeploymentServer%\ninite\selections.txt
echo "Installing Ninite Software"
echo "Selected: %Selections%"
start /wait %DeploymentServer%\ninite\NiniteOne.exe /silent /allusers /disableshortcuts /select %Selections%
echo "Installed Ninite Software"

:: Configure Comets Wireless
start %DeploymentServer%\comets\comets.bat
echo "Comets WiFi Setup Complete"

:: Create the IT Tools Folders in the main directory
if not exist "C:\IT_Tools" mkdir C:\IT_Tools
echo "IT Tools Folder Created"

:: Set up Powershell execution policy for current user (admin)
:: This allows provisioning scripts to be run as local admin during the setup phase
:: See: https://technet.microsoft.com/en-us/library/hh849812.aspx
powershell -Command "Set-ExecutionPolicy Bypass -Scope CurrentUser -Force"

:: Remove the useless Windows Apps
:: Photos and Video are not worth the hassle, so get them out of the base image.
powershell -Command "%DeploymentServer%\windowsMetroApps\windowsApps.ps1"

:: Re-Run Windows Updates
:: This should be run LAST, so that any previous software installs (especially Office) get updates
:: Further, the win-updates script on %DeploymentServer is modified so that SSH doesn't get reinstalled.
powershell -Command "%DeploymentServer%\win-updates.ps1"
