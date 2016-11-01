@echo off

:: INSTRUCTIONS:
:: Set "BackupDir" below to the directory you want to backup to.
:: Set "SteamDir" to the location of your main Steam folder (the one that contains "SteamApps")
:: Game detection is handled automatically.
SET BackupDir="%UserProfile%\ownCloud\savedata"
SET SteamDir="D:\Steam"

:: LIST OF SUPPORTED GAMES:
:: Final Fantasy XIV Online
:: Grand Theft Auto V
:: Euro Truck Simulator 2
:: Prepar3D v3
:: Flight Simulator X
:: iRacing
:: DiRT Rally
:: Killing Floor 2
:: Rocket League
:: Half-Life 2: Deathmatch
:: Sonic & All-Stars Racing Transformed
:: Assetto Corsa
:: Arma 3
:: Burnout Paradise
:: Kerbal Space Program
:: Half-Life 2
:: X-Plane 10

:: Final Fantasy XIV Online
IF EXIST "%UserProfile%\Documents\My Games\FINAL FANTASY XIV - A Realm Reborn" (
	IF NOT EXIST "%BackupDir%\Documents\My Games\FINAL FANTASY XIV - A Realm Reborn\" mkdir "%BackupDir%\Documents\My Games\FINAL FANTASY XIV - A Realm Reborn\"
	xcopy /vy "%UserProfile%\Documents\My Games\FINAL FANTASY XIV - A Realm Reborn\FFXIV.cfg" "%BackupDir%\Documents\My Games\FINAL FANTASY XIV - A Realm Reborn"
	xcopy /vy "%UserProfile%\Documents\My Games\FINAL FANTASY XIV - A Realm Reborn\FFXIV_BOOT.cfg" "%BackupDir%\Documents\My Games\FINAL FANTASY XIV - A Realm Reborn"
)

:: Grand Theft Auto V
IF EXIST "%UserProfile%\Documents\Rockstar Games\GTA V" (
	IF NOT EXIST "%BackupDir%\Documents\Rockstar Games\GTA V" mkdir "%BackupDir%\Documents\Rockstar Games\GTA V"
	xcopy /vys "%UserProfile%\Documents\Rockstar Games\GTA V\Profiles" "%BackupDir%\Documents\Rockstar Games\GTA V\Profiles\"
	xcopy /vy "%UserProfile%\Documents\Rockstar Games\GTA V\settings.xml" "%BackupDir%\Documents\Rockstar Games\GTA V\"
)
IF EXIST "%UserProfile%\Documents\Rockstar Games\Social Club" (
	IF NOT EXIST "%BackupDir%\Documents\Rockstar Games\Social Club" mkdir "%BackupDir%\Documents\Rockstar Games\Social Club"
	xcopy /vys "%UserProfile%\Documents\Rockstar Games\Social Club\Profiles" "%BackupDir%\Documents\Rockstar Games\Social Club\Profiles\"
)

:: Euro Truck Simulator 2
IF EXIST "%UserProfile%\Documents\Euro Truck Simulator 2" (
	IF NOT EXIST "%BackupDir%\Documents\Euro Truck Simulator 2" mkdir "%BackupDir%\Documents\Euro Truck Simulator 2"
	xcopy /vys "%UserProfile%\Documents\Euro Truck Simulator 2\profiles" "%BackupDir%\Documents\Euro Truck Simulator 2\profiles\"
	xcopy /vy "%UserProfile%\Documents\Euro Truck Simulator 2\config.cfg" "%BackupDir%\Documents\Euro Truck Simulator 2\"
)

:: Prepar3D v3
IF EXIST "%UserProfile%\Documents\Prepar3D v3 Files" (
	IF NOT EXIST "%BackupDir%\Documents\Prepar3D v3 Files" mkdir "%BackupDir%\Documents\Prepar3D v3 Files"
	xcopy /vys "%UserProfile%\Documents\Prepar3D v3 Files" "%BackupDir%\Documents\Prepar3D v3 Files\"
)
IF EXIST "%AppData%\Lockheed Martin\Prepar3D v3" (
	IF NOT EXIST "%BackupDir%\Appdata\Roaming\Prepar3D v3" mkdir "%BackupDir%\Appdata\Roaming\Prepar3D v3"
	xcopy /vys "%AppData%\Lockheed Martin\Prepar3D v3" "%BackupDir%\Appdata\Roaming\Prepar3D v3\"
)
IF EXIST "%UserProfile%\Documents\A2A" (
	IF NOT EXIST "%BackupDir%\Documents\A2A" mkdir "%BackupDir%\Documents\A2A"
	xcopy /vys "%UserProfile%\Documents\A2A" "%BackupDir%\Documents\A2A\"
)

:: Flight Simulator X
IF EXIST "%UserProfile%\Documents\Flight Simulator X Files" (
	IF NOT EXIST "%BackupDir%\Documents\Flight Simulator X Files" mkdir "%BackupDir%\Documents\Flight Simulator X Files"
	xcopy /vys "%UserProfile%\Documents\Flight Simulator X Files" "%BackupDir%\Documents\Flight Simulator X Files\"
)
IF EXIST "%Appdata%\Microsoft\FSX" (
	IF NOT EXIST "%BackupDir%\Appdata\Roaming\Microsoft\FSX" mkdir "%BackupDir%\Appdata\Roaming\Microsoft\FSX"
	xcopy /vys "%Appdata%\Microsoft\FSX" "%BackupDir%\Appdata\Roaming\Microsoft\FSX\"
)

:: iRacing
IF EXIST "%UserProfile%\Documents\iRacing" (
	IF NOT EXIST "%BackupDir%\Documents\iRacing" mkdir "%BackupDir%\Documents\iRacing"
	xcopy /vy "%UserProfile%\Documents\iRacing\*.ini" "%BackupDir%\Documents\iRacing\"
	xcopy /vy "%UserProfile%\Documents\iRacing\controls.cfg" "%BackupDir%\Documents\iRacing\"
	xcopy /vy "%UserProfile%\Documents\iRacing\joyCalib.yaml" "%BackupDir%\Documents\iRacing\"
	xcopy /vys "%UserProfile%\Documents\iRacing\setups" "%BackupDir%\Documents\iRacing\setups\"
)

:: DiRT Rally
IF EXIST "%UserProfile%\Documents\My Games\DiRT Rally" (
	IF NOT EXIST "%BackupDir%\Documents\My Games\DiRT Rally" mkdir "%BackupDir%\Documents\My Games\DiRT Rally"
	xcopy /vys "%UserProfile%\Documents\My Games\DiRT Rally" "%BackupDir%\Documents\My Games\DiRT Rally\"
)

:: Killing Floor 2
IF EXIST "%UserProfile%\Documents\My Games\KillingFloor2" (
	IF NOT EXIST "%BackupDir%\Documents\My Games\KillingFloor2" mkdir "%BackupDir%\Documents\My Games\KillingFloor2"
	xcopy /vys "%UserProfile%\Documents\My Games\KillingFloor2\KFGame\Config" "%BackupDir%\Documents\My Games\KillingFloor2\KFGame\Config\"
)

:: Rocket League
IF EXIST "%UserProfile%\Documents\My Games\Rocket League" (
	IF NOT EXIST "%BackupDir%\Documents\My Games\Rocket League" mkdir "%BackupDir%\Documents\My Games\Rocket League"
	xcopy /vys "%UserProfile%\Documents\My Games\Rocket League\TAGame\Config" "%BackupDir%\Documents\My Games\Rocket League\TAGame\Config\"
	xcopy /vys "%UserProfile%\Documents\My Games\Rocket League\TAGame\SaveData" "%BackupDir%\Documents\My Games\Rocket League\TAGame\SaveData\"
)

:: Half-Life 2: Deathmatch
IF EXIST "%SteamDir%\steamapps\common\Half-Life 2 Deathmatch" (
	IF NOT EXIST "%BackupDir%\Steam\steamapps\common\Half-Life 2 Deathmatch" mkdir "%BackupDir%\Steam\steamapps\common\Half-Life 2 Deathmatch"
	xcopy /vys "%SteamDir%\SteamApps\common\Half-Life 2 Deathmatch\hl2mp\cfg" "%BackupDir%\Steam\steamapps\common\Half-Life 2 Deathmatch\hl2mp\cfg\"
)

:: Sonic & All-Stars Racing Transformed
IF EXIST "%UserProfile%\Documents\SART" (
	IF NOT EXIST "%BackupDir%\Documents\SART" mkdir "%BackupDir%\Documents\SART"
	xcopy /vys "%UserProfile%\Documents\SART" "%BackupDir%\Documents\SART\"
)

:: Assetto Corsa
IF EXIST "%UserProfile%\Documents\Assetto Corsa" (
	IF NOT EXIST "%BackupDir%\Documents\Assetto Corsa" mkdir "%BackupDir%\Documents\Assetto Corsa"
	xcopy /vys "%UserProfile%\Documents\Assetto Corsa\cfg" "%BackupDir%\Documents\Assetto Corsa\cfg\"
)

:: Arma 3
IF EXIST "%UserProfile%\Documents\Arma 3" (
	IF NOT EXIST "%BackupDir%\Documents\Arma 3" mkdir "%BackupDir%\Documents\Arma 3"
	xcopy /vys "%UserProfile%\Documents\Arma 3" "%BackupDir%\Documents\Arma 3\"
)

:: Burnout Paradise
IF EXIST "%UserProfile%\AppData\local\criterion games\burnout paradise" (
	IF NOT EXIST "%BackupDir%\AppData\local\criterion games\burnout paradise" mkdir "%BackupDir%\AppData\local\criterion games\burnout paradise"
	xcopy /vys "%UserProfile%\AppData\local\criterion games\burnout paradise\save" "%BackupDir%\AppData\local\criterion games\burnout paradise\save\"
	REM I will backup the config.ini file as soon as I know the precise path
)

:: Kerbal Space Program
IF EXIST "%SteamDir%\SteamApps\common\Kerbal Space Program" (
	IF NOT EXIST "%Backupdir%\Steam\SteamApps\common\Kerbal Space Program" mkdir "%Backupdir%\Steam\SteamApps\common\Kerbal Space Program"
	xcopy /vys "%SteamDir%\SteamApps\common\Kerbal Space Program\saves" "%Backupdir%\Steam\SteamApps\common\Kerbal Space Program\saves\"
	xcopy /vy "%SteamDir%\SteamApps\common\Kerbal Space Program\settings.cfg" "%Backupdir%\Steam\SteamApps\common\Kerbal Space Program\"
)

:: Half-Life 2
IF EXIST "%SteamDir%\SteamApps\common\Half-Life 2" (
	IF NOT EXIST "%Backupdir%\Steam\SteamApps\common\Half-Life 2" mkdir "%Backupdir%\Steam\SteamApps\common\Half-Life 2"
	xcopy /vys "%SteamDir%\SteamApps\common\Half-Life 2\hl2\cfg" "%Backupdir%\Steam\SteamApps\common\Half-Life 2\hl2\cfg\"
	xcopy /vys "%SteamDir%\SteamApps\common\Half-Life 2\hl2\save" "%Backupdir%\Steam\SteamApps\common\Half-Life 2\hl2\save\"
)

:: X-Plane 10
IF EXIST "%SteamDir%\SteamApps\common\X-Plane 10" (
	IF NOT EXIST "%Backupdir%\Steam\SteamApps\common\X-Plane 10\Output\preferences" mkdir "%Backupdir%\Steam\SteamApps\common\X-Plane 10\Output\preferences"
	xcopy /vys "%SteamDir%\SteamApps\common\X-Plane 10\Output\preferences" "%BackupDir%\Steam\SteamApps\common\X-Plane 10\Output\preferences"
)

PAUSE
