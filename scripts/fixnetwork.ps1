# Windows Powershell can not be enabled on a 'Public' network
#
# This script modifies all network locations and changes them from Public to Private
# http://msdn.microsoft.com/en-us/library/windows/desktop/aa370750(v=vs.85).aspx
# For more info, see:
# http://blogs.msdn.com/b/powershell/archive/2009/04/03/setting-network-location-to-private.aspx

# This feature was only introduced in Vista, so only run if OS is more recent than Vista
if([environment]::OSVersion.version.Major -lt 6) { return }

# Domains automatically set the network location, so don't bother if this is true
if(1,3,4,5 -contains (Get-WmiObject win32_computersystem).DomainRole) { return }

# Get the network connections and do it to it
$networkListManager = [Activator]::CreateInstance([Type]::GetTypeFromCLSID([Guid]"{DCB00C01-570F-4A9B-8D69-199FDBA5723B}"))
$connections = $networkListManager.GetNetworkConnections()
        $connections |foreach {
                Write-Host $_.GetNetwork().GetName()"category was previously set to"$_.GetNetwork().GetCategory()
                        $_.GetNetwork().SetCategory(1)
                        Write-Host $_.GetNetwork().GetName()"changed to category"$_.GetNetwork().GetCategory()
        }
$net = get-netconnectionprofile;Set-NetConnectionProfile -Name $net.Name -NetworkCategory Private
