@if "%DEBUG%" == "" (echo off) else (echo on)
SETLOCAL

SET SCRIPTNAME=%~nx0
SET "TAB=	"
SET RC=0

IF "%1"=="" (
    CALL :PrintUsage
    CALL :PrintErr Missing param 1: volume
    GOTO ERR
)
SET VOLUME=%1


REM See https://www.diskpart.com/diskpart/resize-partition-powershell-8523.html
ECHO Extending file system to full capacity of disk...

REM Create script file to be ingested by diskpart
SET TMPFILE=%TEMP%\extend_winfs_%RANDOM%.txt
ECHO list volume >"%TMPFILE%"
REM TODO: We are assuming volume 0 is correct here
ECHO select volume %VOLUME% >>"%TMPFILE%"
ECHO extend >>"%TMPFILE%"
REM exit

REM Call diskpart
CALL diskpart /s "%TMPFILE%"
REM TODO: How can we tell if this fails?

:CLEANUP
IF EXIST "%TMPFILE%" DEL "%TMPFILE%"
ENDLOCAL & EXIT /B 0

:ERR
SET RC=1
GOTO CLEANUP

:PrintUsage
echo Extends a filesystem to fill the capacity of the disk.
echo.
echo %SCRIPTNAME% volume
echo.
echo   volume %TAB% Specifies the volumne number to extend.
echo.
EXIT /B 1

:PrintErr
echo ERROR: %* 1>&2
EXIT /B 0
