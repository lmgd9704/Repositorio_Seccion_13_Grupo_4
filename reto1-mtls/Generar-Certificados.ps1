# Generar-Certificados.ps1 - Reto 1 MetroMIO - Windows 11
# Requisito: Docker Desktop instalado (ya trae openssl) O Git for Windows (Git Bash trae openssl)
# Ejecutar en PowerShell como Administrador, desde la carpeta reto1-mtls-windows
# Si openssl no se reconoce, usar: $env:Path += ";C:\Program Files\Git\usr\bin"  y volver a ejecutar

$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot
New-Item -ItemType Directory -Force -Name certs | Out-Null
Set-Location certs

Write-Host "1/6 CA propia..." -ForegroundColor Cyan
openssl req -x509 -newkey rsa:2048 -keyout ca.key -out ca.crt -days 3650 -nodes -subj "/CN=MetroMIO-Lab-CA"

Write-Host "2/6 Servidor con SAN ingress.metromio.net..." -ForegroundColor Cyan
@"
[req]
distinguished_name = dn
req_extensions = ext
[dn]
[ext]
subjectAltName = DNS:ingress.metromio.net
basicConstraints = CA:FALSE
keyUsage = digitalSignature, keyEncipherment
extendedKeyUsage = serverAuth
"@ | Out-File -Encoding ascii server.cnf
openssl req -newkey rsa:2048 -keyout server.key -out server.csr -nodes -subj "/CN=ingress.metromio.net" -config server.cnf
openssl x509 -req -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out server.crt -days 365 -extensions ext -extfile server.cnf

Write-Host "3/6 Cliente valido con clientAuth (caso B)..." -ForegroundColor Cyan
@"
[req]
distinguished_name = dn
req_extensions = ext
[dn]
[ext]
basicConstraints = CA:FALSE
keyUsage = digitalSignature
extendedKeyUsage = clientAuth
"@ | Out-File -Encoding ascii client.cnf
openssl req -newkey rsa:2048 -keyout client.key -out client.csr -nodes -subj "/CN=cliente-metromio" -config client.cnf
openssl x509 -req -in client.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out client.crt -days 365 -extensions ext -extfile client.cnf

Write-Host "4/6 Certificado de otra CA (caso C)..." -ForegroundColor Cyan
openssl req -x509 -newkey rsa:2048 -keyout ca-mala.key -out ca-mala.crt -days 3650 -nodes -subj "/CN=CA-Atacante"
openssl req -newkey rsa:2048 -keyout cliente-malo.key -out cliente-malo.csr -nodes -subj "/CN=cliente-malo"
openssl x509 -req -in cliente-malo.csr -CA ca-mala.crt -CAkey ca-mala.key -CAcreateserial -out cliente-malo.crt -days 365

Write-Host "5/6 Certificado sin clientAuth (caso D)..." -ForegroundColor Cyan
@"
[req]
distinguished_name = dn
req_extensions = ext
[dn]
[ext]
basicConstraints = CA:FALSE
keyUsage = digitalSignature
extendedKeyUsage = serverAuth
"@ | Out-File -Encoding ascii client-sin-auth.cnf
openssl req -newkey rsa:2048 -keyout client-sin-auth.key -out client-sin-auth.csr -nodes -subj "/CN=cliente-sin-auth" -config client-sin-auth.cnf
openssl x509 -req -in client-sin-auth.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out client-sin-auth.crt -days 365 -extensions ext -extfile client-sin-auth.cnf

Write-Host "6/6 Verificacion..." -ForegroundColor Cyan
openssl x509 -in server.crt -noout -text | Select-String -Pattern "DNS:ingress","TLS Web Server"
openssl x509 -in client.crt -noout -text | Select-String -Pattern "TLS Web Client"
openssl verify -CAfile ca.crt server.crt
openssl verify -CAfile ca.crt client.crt
openssl verify -CAfile ca.crt cliente-malo.crt
Write-Host "Listo. Certificados en .\certs" -ForegroundColor Green
