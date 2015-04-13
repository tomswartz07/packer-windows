# Remove the default Windows Apps from the image
#
# Seriously, who uses these dumb things?
#
# To get the name of the packages:
# - Dism.exe /online /get-ProvisionedAppxPackages 
#
# Alternately, on a live machine, you can run:
# - Dism.exe /online /Remove-ProvisionedAppxPackage /PackageName:microsoft.windowsphotos_16.4.4396.311_x64__8wekyb3d8bbwe
# - Dism.exe /online /Remove-ProvisionedAppxPackage /PackageName:Microsoft.ZuneVideo_1.5.802.0_x64__8wekyb3d8bbwe
#
$AppList = "Microsoft.Reader",
           "Microsoft.WindowsScan",
           "microsoft.windowscommunicationsapps",
           "Microsoft.WindowsReadingList",
           "Microsoft.XboxLIVEGames",
           "Microsoft.ZuneMusic",
           "microsoft.windowsphotos",
           "Microsoft.bingTravel",
           "Microsoft.bingMaps",
           "Microsoft.bingFinance",
           "Microsoft.bingFoodAndDrink",
           "Microsoft.bingHealthAndFitness",
           "Microsoft.ZuneVideo"

ForEach ($App in $AppList) {
   $AppxPackage = Get-AppxProvisionedPackage -online | Where {$_.DisplayName -eq $App}
   Remove-AppxProvisionedPackage -online -packagename ($AppxPackage.PackageName) -ErrorAction SilentlyContinue
   Remove-AppxPackage ($AppxPackage.PackageName) -ErrorAction SilentlyContinue
}

# Also remove the Photos App, which is (conveniently) part of the OS, as of Win8.1
attrib "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\PhotosApp.lnk" -S
attrib "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\PhotosApp.lnk" -R
del /Q "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\PhotosApp.lnk"
