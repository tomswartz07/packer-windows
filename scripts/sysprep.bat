:: Sysprep the device
:: Runs sysprep with the unattend file for answers

echo %time% :: Starting Sysprep
start /wait "C:\Windows\System32\Sysprep\sysprep.exe /generalize /oobe /quit"
echo %time% :: Finished Sysprep
