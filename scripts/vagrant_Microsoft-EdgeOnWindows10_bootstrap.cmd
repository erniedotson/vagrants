@if "%DEBUG%" == "" (echo off) else (echo on)
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION
REM **************************************************************************
REM Purpose    : Bootstrap Microsoft/EdgeOnWindows10 vagrant
REM Parameters : None
REM Comments   : The vagrant box Microsoft/EdgeOnWindows10 v1.0 is not
REM              configured properly for Windows Remote Management (WinRM).
REM              Because of this 'vagrant up' command fails because vagrant is
REM              unable to manage the guest (to confirm boot status,
REM              provision, RDP, etc.). This script will be run once manually
REM              by the user at the guest console in order to configure the
REM              WinRM and RDP settings so that vagrant can do it's magic.
REM              This script has been written so that it is safe to run more
REM              than once.
REM              This script IS interactive with the user.
REM References : WinRM : https://msdn.microsoft.com/en-us/library/aa384372(v=vs.85).aspx
REM **************************************************************************

REM **************************************************************************
REM Global (script local) 'defines'
REM **************************************************************************
SET SCRIPT_NAME=%0
SET CHOCO_PARAM_LIMITOUTPUT=--limitoutput
SET CHOCO_PARAM_NOOP=
SET RC_REBOOT_REQUIRED=3010
SET PAUSE_ON_ERROR=1

REM **************************************************************************
REM Global (script local) variables
REM **************************************************************************
set RC=0

REM **************************************************************************
:main
REM **************************************************************************

REM **************************************************************************
REM Check for priviledge escelation
REM **************************************************************************
net session >nul 2>&1 || ( ECHO ERROR: Administrator privileges required. Try again from an Administrative Command Prompt.&&GOTO ERR)

REM **************************************************************************
REM Copy files from UNC vagrant folder to TEMP
REM **************************************************************************
echo Copying script files...
IF NOT EXIST "%TEMP%\scripts" MKDIR "%TEMP%\scripts" >nul 2>&1 || ( ECHO ERROR: Failed to create temp scripts dir.&&GOTO ERR)
copy /y \\vboxsvr\vagrant\scripts\* "%TEMP%\scripts\" >nul 2>&1 || ( ECHO ERROR: Failed to copy scripts to temp script dir.&&GOTO ERR)
pushd "%TEMP%\scripts\" || ( ECHO ERROR: Failed to pushd to temp script dir.&&GOTO ERR)
REM **************************************************************************

REM **************************************************************************
REM Set Network connection type to Private
REM **************************************************************************
echo Setting Network Connection Locations to Private (required for WinRM Firewall settings)...
REM TODO: Loop through all connection profiles (Get-NetConnectionProfile) and set for each, instead of hard-coded "Network" below
REM @powershell -NoProfile -ExecutionPolicy Bypass -Command 'Set-NetConnectionProfile -Name "Network" -NetworkCategory Private' || ( ECHO ERROR: Failed to change Network Profile type&&GOTO ERR )
echo $profiles = Get-NetConnectionProfile>"%TEMP%\set_network_locations_private.ps1"
echo foreach ($profile in $profiles) {>>"%TEMP%\set_network_locations_private.ps1"
echo     echo ^"Setting Network location to Private for network '$($profile.Name)'...^">>"%TEMP%\set_network_locations_private.ps1"
echo     Set-NetConnectionProfile -Name $profile.Name -NetworkCategory Private>>"%TEMP%\set_network_locations_private.ps1"
echo }>>"%TEMP%\set_network_locations_private.ps1"
@powershell -NoProfile -ExecutionPolicy Bypass -File "%TEMP%\set_network_locations_private.ps1" || ( ECHO ERROR: Failed to change Network Profile type&&GOTO ERR )

REM **************************************************************************
REM Turn on WinRM with handy winrm command in System folder
REM **************************************************************************
echo Enabling WinRM...
CALL winrm.cmd quickconfig -force
IF "%ERRORLEVEL%" NEQ "0" ECHO ERROR: Failed to enable WinRM&&GOTO ERR

REM **************************************************************************
REM Turn on Remote Desktop and add administrator and current user
REM **************************************************************************
echo Enabling Remote Desktop...
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f || ( ECHO ERROR: Failed to enable Remote Desktop&&GOTO ERR )

echo Adding RDP to Windows firewall exclusions...
netsh firewall set service remoteadmin enable || ECHO ERROR: Failed to grant current user Remote Desktop Permissions&&GOTO ERR
netsh firewall set service remotedesktop enable || ECHO ERROR: Failed to grant current user Remote Desktop Permissions&&GOTO ERR

echo Add current User to Remote Desktop Group...
REM Errorlevel 2 indicates failure to add because user already exists in group
net localgroup "Remote Desktop Users" %USERDOMAIN%\%USERNAME% /add 2>nul
if "%errorlevel%"=="2" goto REMOTE_TOOLS_END
if "%errorlevel%" NEQ "0" ECHO ERROR: Failed to grant current user Remote Desktop Permissions&&GOTO ERR
:REMOTE_TOOLS_END

REM **************************************************************************
REM Reset username and password
REM **************************************************************************

REM UN/PW that Microsoft used in their box
SET OLDUSER=IEUser
REM SET OLDPASS=Passw0rd!

REM What the UN/PW sould be
SET NEWUSER=vagrant
SET NEWPASS=vagrant

REM Hostname has not been set by vagrant the first time we run this script. Make
REM sure it matches the name defined in the Vagrantfile
SET VAGRANTNAME=win10

REM C:\vagrant folder may not be mounted yet. Safer to map a drive ourselves.
net use z: \\vboxsvr\vagrant || ( ECHO ERROR: Failed to map drive&&GOTO ERR )

REM Check our breadcrumbs to see if user has been changed
echo Checking username...
if exist "Z:\.vagrant\machines\%VAGRANTNAME%\virtualbox\username" goto USER_CHANGE_DONE

echo.
echo Changing '%OLDUSER%' Fullname to '%NEWUSER%'...
net user %OLDUSER% /fullname:"%NEWUSER%" || ( ECHO ERROR: Failed to change username&&GOTO ERR )

echo.
echo Renaming '%OLDUSER%' account to '%NEWUSER%'...
wmic useraccount where name='%OLDUSER%' rename %NEWUSER% || ( ECHO ERROR: Failed to change account name&&GOTO ERR )
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultUserName /t REG_SZ /d %NEWUSER% /f ||  ( ECHO ERROR: Failed to write account name to registry&&GOTO ERR )
echo %USERNAME% >"Z:\.vagrant\machines\%VAGRANTNAME%\virtualbox\username" ||  ( ECHO ERROR: Failed to write username breadcrumb&&GOTO ERR )

:USER_CHANGE_DONE
echo "Username is: %NEWUSER%"

rem See if we need to change the password or not
echo Checking password...
if exist "Z:\.vagrant\machines\%VAGRANTNAME%\virtualbox\userpass" goto PASS_CHANGE_DONE

echo.
echo Seting password for user '%NEWUSER%' to '%NEWPASS%'...
net user %NEWUSER% %NEWPASS% || ( ECHO ERROR: Failed to change password&&GOTO ERR )
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultPassword /t REG_SZ /d %NEWPASS% /f ||  ( ECHO ERROR: Failed to write password to registry&&GOTO ERR )
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v AutoAdminLogon /t REG_SZ /d "1" /f ||  ( ECHO ERROR: Failed to enable SSO in registry&&GOTO ERR )
echo %NEWPASS% >"Z:\.vagrant\machines\%VAGRANTNAME%\virtualbox\userpass" || ( ECHO ERROR: Failed to write password breadcrumb&&GOTO ERR )

:PASS_CHANGE_DONE
net use z: /delete
echo "Password is: %NEWPASS%"

REM **************************************************************************
REM Remove OpenSSH
REM **************************************************************************
if exist "%PROGRAMFILES%\OpenSSH\uninstall.exe" (
    echo.
    echo Removing OpenSSH...
    "%PROGRAMFILES%\OpenSSH\uninstall.exe" /S || ( ECHO ERROR: Failed to remove OpenSSH&&GOTO ERR )
)

REM **************************************************************************
REM Success
REM **************************************************************************
echo %SCRIPT_NAME% has completed successfully.
echo This guest will now be shutdown.
pause
shutdown /s /t 0
GOTO END


REM **************************************************************************
:ERR
REM **************************************************************************
set RC=1
ECHO.
ECHO An error ocurred. %SCRIPT_NAME% is halting.
IF "%PAUSE_ON_ERROR%"=="1" PAUSE
GOTO END

REM **************************************************************************
:END
REM **************************************************************************
popd
ENDLOCAL&&EXIT /B %RC%
