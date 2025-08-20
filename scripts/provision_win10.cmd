@echo off
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION
REM **************************************************************************
REM Purpose    : Provision Windows 10 vagrant
REM Parameters : None
REM Comments   : None
REM References : None
REM **************************************************************************

REM **************************************************************************
REM Global (script local) 'defines'
REM **************************************************************************
SET CHOCO_PARAM_LIMITOUTPUT=--limitoutput
SET CHOCO_PARAM_NOOP=
SET RC_REBOOT_REQUIRED=3010
SET DO_REMOTE_TOOLS=
SET SCRIPT_NAME=%0

REM **************************************************************************
REM Global (script local) variables
REM **************************************************************************
set RC=0

REM **************************************************************************
REM Uncomment these for verbose/script debugging
REM **************************************************************************
REM SET CHOCO_PARAM_NOOP=--noop
REm SET CHOCO_PARAM_LIMITOUTPUT=

REM **************************************************************************
REM Check for priviledge escelation
REM **************************************************************************
net session >nul 2>&1 || ( ECHO ERROR: Administrator privileges required. Try again from an Administrative Command Prompt.&&GOTO ERR)

REM **************************************************************************
:MAIN
REM **************************************************************************

REM **************************************************************************
REM MARK: Set autologin
REM **************************************************************************
echo Adding registry keys for autologin...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v AutoAdminLogon /t REG_SZ /d 1 /f || ( ECHO ERROR: Failed to configure autologin.&&GOTO ERR)
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultUserName /t REG_SZ /d vagrant /f || ( ECHO ERROR: Failed to configure autologin Username.&&GOTO ERR)
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultPassword /t REG_SZ /d vagrant /f || ( ECHO ERROR: Failed to configure autologin Password.&&GOTO ERR)

REM **************************************************************************
REM MARK: Install Chocolatey
REM **************************************************************************
where choco.exe >nul 2>&1
if "%errorlevel%" EQU "0" (
    echo Chocolatey is already installed, skipping installation...
) else (
    echo Installing chocolatey...
    CALL "%~dp0install_choco.cmd"
    if "%errorlevel%" NEQ "0" GOTO ERR
)

REM **************************************************************************
REM MARK: Install packages
REM **************************************************************************
choco install -y chocolatey %CHOCO_PARAM_LIMITOUTPUT% %CHOCO_PARAM_NOOP%
if "%ERRORLEVEL%"=="%RC_REBOOT_REQUIRED%" GOTO REBOOT
if "%ERRORLEVEL%" NEQ "0" (ECHO ERROR: Chocolatey failed to install a package&&GOTO ERR)

REM The end
ECHO.
ECHO %SCRIPT_NAME% exection has completed successfully!
GOTO END

REM MARK: Error handling

REM **************************************************************************
:REBOOT
REM **************************************************************************
set RC=%RC_REBOOT_REQUIRED%
ECHO.
ECHO A reboot is required. Please reboot and run %SCRIPT_NAME% again to continue.
GOTO END

REM **************************************************************************
:ERR
REM **************************************************************************
set RC=1
ECHO.
ECHO An error ocurred. %SCRIPT_NAME% is halting.
GOTO END

REM **************************************************************************
:END
REM **************************************************************************
ENDLOCAL&&EXIT /B %RC%
