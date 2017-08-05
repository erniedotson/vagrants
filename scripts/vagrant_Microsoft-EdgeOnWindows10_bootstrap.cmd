@echo off
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