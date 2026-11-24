# Generar-SealedSecret.ps1 - Reto 2b - LO HACE EL COMPANERO CON KUBERNETES
# Requisitos: kubectl + kubeseal instalados, cluster corriendo (Minikube / Docker Desktop Kubernetes)
# NUNCA escribir la contrasena en un archivo que vaya a Git. Este script la pide por teclado y la borra.
$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot
Write-Host "=== Reto 2b - SealedSecret ===" -ForegroundColor Cyan
Write-Host "1. Verificar cluster y controlador sealed-secrets..." -ForegroundColor Yellow
kubectl get pods -n kube-system | Select-String sealed
kubectl get sealedsecret -n hospitvalle
Write-Host ""
Write-Host "2. Demostracion: base64 NO es cifrado (evidencia Figura 2D)" -ForegroundColor Yellow
$demo = "MiClaveUCI-2026"
$bytes = [System.Text.Encoding]::UTF8.GetBytes($demo)
$b64 = [Convert]::ToBase64String($bytes)
Write-Host "   base64 de MiClaveUCI-2026 = $b64"
Write-Host "   Cualquiera lo decodifica con: echo $b64 | base64 -d"
Write-Host ""
Write-Host "3. Crear Secret FUERA del repo y sellarlo" -ForegroundColor Yellow
$secure = Read-Host "Escribe la contrasena de Postgres (no se muestra, no queda en Git)" -AsSecureString
$plain = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure))
$tmp = Join-Path $env:TEMP "pg-secret.yaml"
kubectl create secret generic pg-uci-pass --from-literal=password=$plain --dry-run=client -o yaml | Out-File -Encoding ascii $tmp
$plain = $null; $secure = $null
# Sellar: solo el controlador del cluster puede abrirlo
Get-Content $tmp | kubeseal --format yaml --cert cert.pem | Out-File -Encoding ascii .\k8s\sealed-pg-secret.yaml
# Borrar el Secret en claro
Remove-Item $tmp -Force
Write-Host "Listo: k8s/sealed-pg-secret.yaml creado. Verificar que NO tiene la contrasena en claro:" -ForegroundColor Green
Get-Content .\k8s\sealed-pg-secret.yaml
Write-Host ""
Write-Host "4. Aplicar y verificar" -ForegroundColor Yellow
kubectl apply -f .\k8s\sealed-pg-secret.yaml
kubectl get sealedsecret -n hospitvalle
kubectl get secret pg-uci-pass -n hospitvalle
