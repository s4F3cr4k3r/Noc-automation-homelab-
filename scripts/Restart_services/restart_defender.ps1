param(
    [string]$Target
)

# ===== CONFIG =====
$ServiceName = "WinDefend"

# Safe folder for logging that all accounts (including PRTG service) can write to
$LogFolder = "C:\PRTGLogs"
$LogFile = Join-Path $LogFolder "defender_log.txt"
$Time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

# ===== ENSURE LOG PATH EXISTS =====
if (!(Test-Path $LogFolder)) {
    New-Item -ItemType Directory -Path $LogFolder | Out-Null
}

# ===== ENSURE LOG FILE EXISTS =====
if (!(Test-Path $LogFile)) {
    New-Item -ItemType File -Path $LogFile | Out-Null
}

# ===== GET SERVICE =====
$svc = Get-WmiObject -Class Win32_Service `
                     -ComputerName $Target `
                     -Filter "Name='$ServiceName'"

if ($svc) {
    try {
        $svc.StopService() | Out-Null
        Start-Sleep 2
        $svc.StartService() | Out-Null

        # Log success (append mode)
        Add-Content $LogFile "$Time - $Target - Windows Defender stopped - Service restarted - Success"
    }
    catch {
        # Log failure (append mode)
        Add-Content $LogFile "$Time - $Target - Windows Defender stopped - Restart failed - Error"
    }
}
else {
    # Log service not found (append mode)
    Add-Content $LogFile "$Time - $Target - Windows Defender not found - No action taken - Failed"
}

# ===== PRTG SENSOR OUTPUT =====
try {
    if ($svc.State -eq 'Running') { Write-Host "0: Windows Defender is Running" }
    else { Write-Host "2: Windows Defender is Stopped" }
} catch {
    Write-Host "2: Cannot query Windows Defender - $($_.Exception.Message)"
}
