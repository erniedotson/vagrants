@echo off
set RC=0
set SCRIPT_NAME=%0

REM **************************************************************************
REM *** Install Chocolatey
REM **************************************************************************
where /q choco && goto CHOCO_INSTALL_END
echo Installing Chocolatey Package Manager...
@powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin
where /q choco || ( ECHO ERROR: Failed to find or install Chocolatey&&GOTO END )
:CHOCO_INSTALL_END
CALL refreshenv.cmd
REM On Win7, Chocolatey will install .Net Framework 4.0 if it's not already installed,
REM but IF it does this, a restart is required for chocolatey executables to
REM run correctly.
REM IF we are here, chocolatey was installed and choco.exe exists, lets see
REM if it runs!
choco list -lo >NUL && GOTO CHOCO_END
ECHO.
ECHO Cholatey failed to run. This is usually caused by pending reboot after installing .Net Framework.
GOTO REBOOT
:CHOCO_END

rem Let Chocolatey manage itself
cinst -y chocolatey %CHOCO_PARAM_LIMITOUTPUT% %CHOCO_PARAM_NOOP%
if "%ERRORLEVEL%"=="%RC_REBOOT_REQUIRED%" GOTO REBOOT
if "%ERRORLEVEL%" NEQ "0" (ECHO ERROR: Failed to install one or more packages&&GOTO ERR)

REM **************************************************************************
REM Success
REM **************************************************************************
REM NO output on success
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
ECHO An error ocurred. %SCRIPT_NAME% is halting. If new packages were recently
ECHO installed it may be necessary to close an reopen your shell and try again.
ECHO If that does not work it may be necessary to reboot and try again.
GOTO END

REM **************************************************************************
:END
REM **************************************************************************
ENDLOCAL&&EXIT /B %RC%