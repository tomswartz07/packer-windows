# Windows Templates for Packer

### Introduction

This repository contains Windows templates that can be used to create boxes for Vagrant using Packer ([Website](http://www.packer.io)) ([Github](http://github.com/mitchellh/packer)).

This repo began by borrowing bits from the VeeWee Windows templates (https://github.com/jedi4ever/veewee/tree/master/templates). Modifications were made to work with Packer and the VMware Fusion / VirtualBox providers for Packer and Vagrant.
Further work has been done based upon Joe Fitzgerald's original [Packer Windows](https://github.com/joefitzgerald/packer-windows) code.

### Packer Version

[Packer](https://github.com/mitchellh/packer/blob/master/CHANGELOG.md) `0.5.1` or greater is required.

### Windows Versions

The following Windows versions are known to work (built with VMware Fusion 6.0.4 and VirtualBox 4.3.12):

 * Windows 2012 R2
 * Windows 2012 R2 Core
 * Windows 2012
 * Windows 8.1
 * Windows 7

### Windows Editions

All Windows Server versions are defaulted to the Server Standard edition. You can modify this by editing the Autounattend.xml file, changing the `ImageInstall`>`OSImage`>`InstallFrom`>`MetaData`>`Value` element (e.g. to Windows Server 2012 R2 SERVERDATACENTER).

The standard configurations will generally install the Professional edition.

### Product Keys

The `Autounattend.xml` files are configured to work correctly with trial ISOs (which will be downloaded and cached for you the first time you perform a `packer build`). If you would like to use retail or volume license ISOs, you need to update the `UserData`>`ProductKey` element as follows:

* Uncomment the `<Key>...</Key>` element
* Insert your product key into the `Key` element

If you are going to configure your VM as a KMS client, you can use the product keys at http://technet.microsoft.com/en-us/library/jj612867.aspx. These are the default values used in the `Key` element.

The trial keys are encouraged for use during the 'build' phase, as they are guaranteed to work and be valid.
Individual 'private' activation keys can be added to the image following the initial configuration and Sysprep of the image.

### Windows Updates

The scripts in this repo will install all Windows updates – by default – during Windows Setup.

This is a _very_ time consuming process, depending on the age of the OS and the quantity of updates released since the last service pack.

If you have a local WSUS, it's possible to direct Windows to use this server instead.
This will exponentially speed up the setup process.

```dosbatch
net stop wuauserv
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v EnableFeaturedSoftware /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v IncludeRecommendedUpdates /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v WUServer /t REG_SZ /d http://hydrogen.pennmanor.net:8530 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v WUStatusServer /t REG_SZ /d http://hydrogen.pennmanor.net:8530 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v UseWUServer /t REG_DWORD /d 1 /f
echo Set ServiceManager = CreateObject("Microsoft.Update.ServiceManager") > C:\temp.vbs
echo Set NewUpdateService = ServiceManager.AddService2("7971f918-a847-4430-9279-4a52d1efe18d",7,"") >> C:\temp.vbs
cscript C:\temp.vbs
net start wuauserv
```

If you do not have a local WSUS, you might want to do yourself a favor during development and disable this functionality, by commenting out the `WITH WINDOWS UPDATES` section and uncommenting the `WITHOUT WINDOWS UPDATES` section in `Autounattend.xml`:

```xml
<!-- WITHOUT WINDOWS UPDATES -->
<SynchronousCommand wcm:action="add">
    <CommandLine>cmd.exe /c C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -File a:\openssh.ps1 -AutoStart</CommandLine>
    <Description>Install OpenSSH</Description>
    <Order>99</Order>
    <RequiresUserInput>true</RequiresUserInput>
</SynchronousCommand>
<!-- END WITHOUT WINDOWS UPDATES -->
<!-- WITH WINDOWS UPDATES -->
<!--
<SynchronousCommand wcm:action="add">
    <CommandLine>cmd.exe /c a:\microsoft-updates.bat</CommandLine>
    <Order>98</Order>
    <Description>Enable Microsoft Updates</Description>
</SynchronousCommand>
<SynchronousCommand wcm:action="add">
    <CommandLine>cmd.exe /c C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -File a:\openssh.ps1</CommandLine>
    <Description>Install OpenSSH</Description>
    <Order>99</Order>
    <RequiresUserInput>true</RequiresUserInput>
</SynchronousCommand>
<SynchronousCommand wcm:action="add">
    <CommandLine>cmd.exe /c C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -File a:\win-updates.ps1</CommandLine>
    <Description>Install Windows Updates</Description>
    <Order>100</Order>
    <RequiresUserInput>true</RequiresUserInput>
</SynchronousCommand>
-->
<!-- END WITH WINDOWS UPDATES -->
```

Doing so will give you hours back in your day, which is a good thing.


### OpenSSH / WinRM

Currently, [Packer](http://packer.io) has a single communicator that uses SSH. This means we need an SSH server installed on Windows - which is not optimal as we could use WinRM to communicate with the Windows VM. In the short term, everything works well with SSH; in the medium term, work is underway on a WinRM communicator for Packer.

There is a build step in the post-image answer files that will remove the SSH program.

### Using .box Files With Vagrant

The generated box files include a Vagrantfile template that is suitable for
use with Vagrant 1.6.2+, which includes native support for Windows and uses
WinRM to communicate with the box.

### Getting Started

1. Clone this repo to a local directory
4. Move the ISO to the `iso` directory
5. Update the .json file setting `iso_url` accordingly.
6. Update the .json file setting `iso_checksum` accordingly.
7. Run `packer build <windows_version>.json`

### Setting up Jenkins for Automatic Building
Jenkins is a Continuous Integration program, that can be used for regularly scheduling builds of the image.
Regularly building the image has the boon of always assuring that the available image is up to date.

#### Jenkins Slave
Following the Packer-io build, this process will be working with 'raw' hard drive images.
Because of this, you'll need a very large amount of free drive space.

The 'slave', or the box that will build the image must have the following:

- Packer-IO
- At minimum, 70GB Drive space (for the in-progress image build)
- At minimum, 8GB of free RAM

#### Jenkins Job Configuration
The current job to build the WDS Image is: `District - WDS Image Build`.

The image will build if either of the two following conditions are met:
1. Midnight on 17th of the month
2. Midnight on 26th of the month
3. A Git Commit has been merged to the packer-windows git project

The job has two distinct build steps:
1. Image creation via Packer
2. Image distribution via 'shell commands'

The images are distributed as a post-build step to the main WDS Server(s); currently `Selenium` and `2012WDS`.
Each of the WDS servers has a distinct definition in the slave's /etc/fstab.
```
//selenium/w$ /media/files cifs users,rw,credentials=$JENKINSHOME 0 0
```
Where $JENKINSHOME is the path to the home directory accessed via Jenkins' SSH user.
**NOTE:** Be sure to mark this credentials file with limited permissions. Perhaps `chmod 0400`?


### Contributing

Pull requests welcomed. Please ensure you create your edits in a branch off of the `develop` branch, not the `master` branch.
Code will be merged from `develop` into `master` after review and testing.
