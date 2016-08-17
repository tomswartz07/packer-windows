:: Fix various Windows 10 'features' and options

:: Disable Telemetry
::
echo "" > C:\ProgramData\Microsoft\Diagnosis\ETLLogs\AutoLogger\AutoLogger-Diagtrack-Listener.etl
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f

:: Disable WiFi Sense
:: WiFi Sense is a 'feature' that will share Wireless Network information
:: with those in the user's address book.
::
:: Great idea, folks.
::
reg add "HKLM\SOFTWARE\Policies\Microsoft\WcmSvc\wifinetworkmanager\config" /v PowerDelayLowPowerScan /t REG_DWORD /d 00124f80 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\WcmSvc\wifinetworkmanager\config" /v WiFiPhoneBlueOEMMigrationDone /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\WcmSvc\wifinetworkmanager\config" /v RequestedNdccConfig /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\WcmSvc\wifinetworkmanager\config" /v NotificationCleanupNeeded /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\WcmSvc\wifinetworkmanager\config" /v AutoConnectAllowedOEM /t REG_DWORD /d 0 /f

:: Disable Diagnosics Tracking Service
::
sc stop "dmwappushservice"
sc config "dwmappushservice" start= disabled
sc stop "DiagTrack"
sc config "DiagTrack" start= disabled

:: Disable Touch Screen Keyboard
::
sc stop "TabletInputService"
sc config "TabletInputService" start= disabled

:: Disable P2P Updates
:: Options are:
:: 0: Off, disabled
:: 1: PCs on LAN
:: 3: PCs on LAN and Internet
::
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" /v DODownloadMode /t REG_DWORD /d 1 /f
