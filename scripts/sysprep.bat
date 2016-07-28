:: Sysprep the device
:: Runs sysprep with the unattend file for answers

echo %time% :: Starting Sysprep
cmd /c "C:\Windows\System32\Sysprep\sysprep.exe /generalize /quiet /oobe /quit /unattend:A:\unattendSysprep.xml"
echo %time% :: Finished Sysprep
