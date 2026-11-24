# Probar-Matriz.ps1 - Reto 1 - Windows 11
# Ejecutar DESPUES de: docker compose up -d   y de agregar 127.0.0.1 ingress.metromio.net al hosts
# En PowerShell como Administrador:
#   notepad C:\Windows\System32\drivers\etc\hosts   -> agregar: 127.0.0.1 ingress.metromio.net
$ErrorActionPreference = "Continue"
Set-Location $PSScriptRoot
Write-Host "=== CASO A: sin certificado -> debe dar 400 ===" -ForegroundColor Yellow
curl.exe -k https://ingress.metromio.net:8443/
Write-Host ""
Write-Host "=== CASO B: certificado valido -> debe dar 200 / Acceso concedido ===" -ForegroundColor Yellow
curl.exe --cert certs/client.crt --key certs/client.key --cacert certs/ca.crt https://ingress.metromio.net:8443/
Write-Host ""
Write-Host "=== CASO C: otra CA -> debe dar 400 / 403 ===" -ForegroundColor Yellow
curl.exe --cert certs/cliente-malo.crt --key certs/cliente-malo.key --cacert certs/ca.crt https://ingress.metromio.net:8443/
Write-Host ""
Write-Host "=== CASO D: sin clientAuth -> debe dar 400 ===" -ForegroundColor Yellow
curl.exe --cert certs/client-sin-auth.crt --key certs/client-sin-auth.key --cacert certs/ca.crt https://ingress.metromio.net:8443/
Write-Host ""
Write-Host "Copiar toda la salida de esta ventana como evidencia (Figuras 1A-1D)." -ForegroundColor Green
