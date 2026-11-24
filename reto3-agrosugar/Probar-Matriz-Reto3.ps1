# Probar-Matriz-Reto3.ps1 - Matriz de 4 casos
Set-Location $PSScriptRoot
Write-Host "=== CASO 1: sensor -> broker:1883  (debe PASAR) ===" -ForegroundColor Yellow
kubectl exec -n agrosugar sensor -- nc -vz -w 3 broker 1883
Write-Host ""
Write-Host "=== CASO 2: sensor -> internet  (debe BLOQUEARSE) ===" -ForegroundColor Yellow
kubectl exec -n agrosugar sensor -- wget -qO- --timeout=3 https://8.8.8.8
Write-Host "Si dio error/timeout = BLOQUEADO = correcto"
Write-Host ""
Write-Host "=== CASO 3: sensor -> db:5432  (debe BLOQUEARSE) ===" -ForegroundColor Yellow
kubectl exec -n agrosugar sensor -- nc -vz -w 3 db 5432
Write-Host "Si dio error/timeout = BLOQUEADO = correcto"
Write-Host ""
Write-Host "=== CASO 4: intruso -> broker:1883  (debe BLOQUEARSE) ===" -ForegroundColor Yellow
kubectl exec -n agrosugar intruso -- nc -vz -w 3 broker 1883
Write-Host "Si dio error/timeout = BLOQUEADO = correcto"
