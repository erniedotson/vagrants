@echo off
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION
REM **************************************************************************
REM Purpose    : Provision Win7
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
REM *** Install Windows Updates
REM **************************************************************************
REM echo Installing Windows Updates...
REM cscript %SCRIPT_NAME%\..\WUA_SearchDownloadInstall_unattended.vbs || GOTO ERR
REM CALL %SCRIPT_NAME%\..\vagrant_opentable-win-7-professional-amd64-nocm_bootstrap.cmd || GOTO ERR

REM **************************************************************************
REM *** Install Chocolatey
REM **************************************************************************
echo Installing chocolatey...
where /q choco && goto CHOCO_INSTALL_END
CALL %SCRIPT_NAME%\..\install_choco.cmd
REM It seems that suddenly after install of .Net framework, not only is a reboot
REM required for chocolatey to work, but also WinRM seems to stop working until
REM a reboot is done. Force a reboot since provisioner can no longer tell the VM
REM to reboot. This reboot shoudl be matched up with a provisoner:reload function
echo Chocolatey has installed .Net Framework which requires reboot to work correctly.
ECHO.
ECHO.
shutdown /r /t 0 /f
GOTO REBOOT
:CHOCO_INSTALL_END
echo Chocolatey installed!

REM **************************************************************************
REM *** Install packages using Chocolaty Package Manager (choco/cinst)...
REM **************************************************************************

REM Service Pack 1 (SP1) for Windows 7 and for Windows Server 2008 R2
cinst -y kb976932 %CHOCO_PARAM_LIMITOUTPUT% %CHOCO_PARAM_NOOP%
if "%ERRORLEVEL%"=="%RC_REBOOT_REQUIRED%" GOTO REBOOT
if "%ERRORLEVEL%" NEQ "0" (ECHO ERROR: Chocolatey failed to install a package&&GOTO ERR)

cinst -y git %CHOCO_PARAM_LIMITOUTPUT% %CHOCO_PARAM_NOOP%
if "%ERRORLEVEL%"=="%RC_REBOOT_REQUIRED%" GOTO REBOOT
if "%ERRORLEVEL%" NEQ "0" (ECHO ERROR: Chocolatey failed to install a package&&GOTO ERR)

REM Python is required by swig, but choco dependencies not configured correctly
cinst -y python2 %CHOCO_PARAM_LIMITOUTPUT% %CHOCO_PARAM_NOOP%
if "%ERRORLEVEL%"=="%RC_REBOOT_REQUIRED%" GOTO REBOOT
if "%ERRORLEVEL%" NEQ "0" (ECHO ERROR: Chocolatey failed to install a package&&GOTO ERR)

cinst -y swig %CHOCO_PARAM_LIMITOUTPUT% %CHOCO_PARAM_NOOP%
if "%ERRORLEVEL%"=="%RC_REBOOT_REQUIRED%" GOTO REBOOT
if "%ERRORLEVEL%" NEQ "0" (ECHO ERROR: Chocolatey failed to install a package&&GOTO ERR)

REM Visual C++ Build Tools 2015 required as add-on to support C++ in Visual Studio 2015
cinst -y vcbuildtools --execution-timeout=999999 %CHOCO_PARAM_LIMITOUTPUT% %CHOCO_PARAM_NOOP%
if "%ERRORLEVEL%"=="%RC_REBOOT_REQUIRED%" GOTO REBOOT
if "%ERRORLEVEL%" NEQ "0" (ECHO ERROR: Chocolatey failed to install a package&&GOTO ERR)

REM node-gyp requires vcbuild.exe (distributed with Visual Studio) instead of msbuild.exe (distributed with MS Build Tools AND Visual Studio)
cinst -y visualstudio2015community --execution-timeout=999999 %CHOCO_PARAM_LIMITOUTPUT% %CHOCO_PARAM_NOOP%
if "%ERRORLEVEL%"=="%RC_REBOOT_REQUIRED%" GOTO REBOOT
if "%ERRORLEVEL%" NEQ "0" (ECHO ERROR: Chocolatey failed to install a package&&GOTO ERR)

REM Chocolatey's nodejs 4.4.1 package was broken, using 4.4.2 instead
cinst -y nodejs --version 4.4.2 %CHOCO_PARAM_LIMITOUTPUT% %CHOCO_PARAM_NOOP%
if "%ERRORLEVEL%"=="%RC_REBOOT_REQUIRED%" GOTO REBOOT
if "%ERRORLEVEL%" NEQ "0" (ECHO ERROR: Failed to install nodejs&&GOTO ERR)

REM If npm is not found it may be because NodeJS was recently installed and we need to refresh our environment variables
where /q npm || CALL refreshenv.cmd

REM Install (global) packages using Node Package Manager (npm)...
REM Note, npm is a batch file, npm.cmd, this means:
REM 1. It must be called with CALL if we want to return execution to this script
REM 2. The conditionals && and || do not seem to work, check ERRORLEVEL instead
SET PACKAGES=
SET PACKAGES=%PACKAGES% jshint
SET PACKAGES=%PACKAGES% json
SET PACKAGES=%PACKAGES% node-gyp@3.3.1
CALL npm install -g %PACKAGES%
IF %ERRORLEVEL% NEQ 0 GOTO ( ECHO ERROR: Failed to install one or more npm packages&GOTO ERR)

REM The end
ECHO.
ECHO %SCRIPT_NAME% exection has completed successfully!
GOTO END

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