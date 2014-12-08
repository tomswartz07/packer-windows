rem Sysprep the device
rem Runs sysprep with the unattend file for answers

cmd /c "c:\windows\system32\sysprep\sysprep /generalize /oobe /shutdown /unattend:A:\unattendSysprep.xml"
