rem Sysprep the device
rem Runs sysprep with the unattend file for answers

cmd /c "c:\windows\system32\sysprep\sysprep /generalize /oobe /shutdown /unattend:C:\Windows\Temp\answer_files\sysprep\81\unattendSysprep.xml"
