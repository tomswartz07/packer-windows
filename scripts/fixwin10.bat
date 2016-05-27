:: Disable Telemetry
::
echo "" > C:\ProgramData\Microsoft\Diagnosis\ETLLogs\AutoLogger\AutoLogger-Diagtrack-Listener.etl
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f

:: Disable Diagnosics Tracking Service
::
sc config "dwmappushservice" start= disabled
sc stop "dmwappushservice"
sc config "DiagTrack" start= disabled
sc stop "DiagTrack"

:: Disable Touch Screen Keyboard
::
sc config "TabletInputService" start= disabled
sc stop "TabletInputService"

:: Disable P2P Updates
:: Options are:
:: 0: Off, disabled
:: 1: PCs on LAN
:: 3: PCs on LAN and Internet
::
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" /v DODownloadMode /t REG_DWORD /d 1 /f
