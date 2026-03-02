@echo off
REM Pass PRTG host (%1) and action (%2) to the PS1 script
REM Example: script.bat SERVER01 restart

powershell.exe -ExecutionPolicy Bypass -File "%~dp0restart_shutdown_logger.ps1" -Target %1 -Action %2
