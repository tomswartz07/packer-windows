rem Sysprep the device
rem Runs sysprep with the unattend file for answers

cmd /c "c:\windows\system32\sysprep\sysprep /generalize /oobe /quit /unattend:A:\unattendSysprep.xml"
