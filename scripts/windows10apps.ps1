# Fix errors with Sysprep failing/hanging due to issues with Windows 10 code
#
# Win10 Sysprep fails to run due to temporarily provisioned Apps being
# installed for the setup user (admin, usually) silently failing on the
# command line, but logging the output of the failed command to the
# %WINDIR%\System32\Sysprep\Panther\sysprepact.log file

# TechNet's answer was to provision the computer without ever connecting it to
# the network; obviously that's a super great way to install updates. /s
# The real fix was found here:
# http://deploymentresearch.com/Research/Post/450/Sysprep-broken-in-Windows-10-Build-9926

# This fix is similar to the Metro apps removal process, but is much more
# comprehensive.

Import-Module Appx
Import-Module Dism
Get-AppxPackage -Name * | Remove-AppxPackage
