@if "%DEBUG%" == "" (echo off) else (echo on)
SETLOCAL
REM See https://www.diskpart.com/diskpart/resize-partition-powershell-8523.html
ECHO Extending file system to full capacity of disk...

REM Create script file to be ingested by diskpart
SET TMPFILE=%TEMP%\extend_winfs_%RANDOM%.txt
ECHO list volume >"%TMPFILE%"
REM TODO: We are assuming volume 0 is correct here
ECHO select volume 0 >>"%TMPFILE%"
ECHO extend >>"%TMPFILE%"
REM exit

REM Call diskpart
CALL diskpart /s "%TMPFILE%"
REM TODO: How can we tell if this fails?

IF EXIST "%TMPFILE%" DEL "%TMPFILE%"
ENDLOCAL
