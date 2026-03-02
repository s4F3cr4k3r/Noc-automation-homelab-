@echo off
REM Pass PRTG host (%host) to the PS1 script
powershell.exe -ExecutionPolicy Bypass -File "%~dp0defender_restart_wmi.ps1" %1
