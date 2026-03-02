@echo off
REM Pass PRTG host (%host) to the PS1 script
powershell.exe -ExecutionPolicy Bypass -File "%~dp0restart_spooler.ps1" %1
