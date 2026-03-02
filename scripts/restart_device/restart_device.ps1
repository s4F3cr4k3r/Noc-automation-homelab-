param(
    [string]$Target,           # Target computer name
    [ValidateSet("restart","shutdown")]
    [string]$Action            # Action: "restart" or "shutdown"
)

# ===== CONFIG =====
$LogFolder = "C:\PRTGLogs"
$LogFile = Join-Path $LogFolder "restartlog.txt"
$Time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

# ===== ENSURE LOG PATH EXISTS =====
if (!(Test-Path $LogFolder)) {
    New-Item -ItemType Directory -Path $LogFolder | Out-Null
}

# ===== ENSURE LOG FILE EXISTS =====
if (!(Test-Path $LogFile)) {
    New-Item -ItemType File -Path $LogFile | Out-Null
}

# ===== LOG ATTEMPT =====
Add-Content $LogFile "$Time - $Target - $Action - Attempting"

# ===== EXECUTE COMMAND =====
try {
    if ($Action -eq "restart") {
        Restart-Computer -ComputerName $Target -Force -ErrorAction Stop
    }
    elseif ($Action -eq "shutdown") {
        Stop-Computer -ComputerName $Target -Force -ErrorAction Stop
    }

    # ===== LOG SUCCESS =====
    $Time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content $LogFile "$Time - $Target - $Action - Success"
}
catch {
    # ===== LOG FAILURE =====
    $Time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content $LogFile "$Time - $Target - $Action - Failed - $($_.Exception.Message)"
}
