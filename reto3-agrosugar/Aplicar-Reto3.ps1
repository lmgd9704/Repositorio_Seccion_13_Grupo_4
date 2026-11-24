# Aplicar-Reto3.ps1 - LO HACE EL COMPANERO CON KUBERNETES
$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/pods-demo.yaml
Write-Host "Esperando pods..." -ForegroundColor Yellow
kubectl wait --for=condition=Ready pod --all -n agrosugar --timeout=120s
Write-Host "Aplicando politicas EN ORDEN 1-2-3-4..." -ForegroundColor Cyan
kubectl apply -f k8s/01-default-deny-all.yaml
kubectl apply -f k8s/02-allow-dns-egress.yaml
kubectl apply -f k8s/03-sensor-to-broker.yaml
kubectl apply -f k8s/04-broker-to-db.yaml
kubectl get networkpolicy -n agrosugar
Write-Host "Listo. Ahora corre: .\Probar-Matriz-Reto3.ps1" -ForegroundColor Green
