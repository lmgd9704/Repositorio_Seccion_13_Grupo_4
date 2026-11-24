# Aplicar-Reto2.ps1 - Reto 2c - LO HACE EL COMPANERO CON KUBERNETES
$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/rbac.yaml
kubectl apply -f k8s/securitycontext.yaml
kubectl apply -f k8s/networkpolicy.yaml
kubectl apply -f k8s/sealed-pg-secret.yaml
Write-Host "=== Verificacion ===" -ForegroundColor Cyan
kubectl get pods -n hospitvalle
kubectl get networkpolicy -n hospitvalle
kubectl get sealedsecret -n hospitvalle
Write-Host "RBAC - debe decir NO (no puede listar pods de kube-system):" -ForegroundColor Yellow
kubectl auth can-i list pods --as=system:serviceaccount:hospitvalle:app-uci-sa -n kube-system
Write-Host "Red - desde el pod, internet debe fallar (BLOQUEADO):" -ForegroundColor Yellow
kubectl exec -n hospitvalle app-uci -- wget -qO- --timeout=3 https://8.8.8.8
Write-Host "Si wget falla / timeout = correcto, NetworkPolicy esta bloqueando." -ForegroundColor Green
