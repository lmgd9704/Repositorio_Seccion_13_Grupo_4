# Ataque-Etiqueta.ps1 - Demostracion del ataque y su correccion
# PASO A: SIN correccion - el intruso se pone la etiqueta app=sensor y PASA
Set-Location $PSScriptRoot
Write-Host "=== ATAQUE: intruso con etiqueta app=sensor ===" -ForegroundColor Red
kubectl run intruso-falso --image=busybox:1.36 -n agrosugar --labels="app=sensor" -- sleep 3600
kubectl wait --for=condition=Ready pod/intruso-falso -n agrosugar --timeout=60s
kubectl exec -n agrosugar intruso-falso -- nc -vz -w 3 broker 1883
Write-Host "Si CONECTO = ataque exitoso, la NetworkPolicy sola NO basta. Esa es la evidencia Figura 3E." -ForegroundColor Yellow
Write-Host ""
Write-Host "Limpiando intruso falso..." -ForegroundColor Cyan
kubectl delete pod intruso-falso -n agrosugar
Write-Host ""
Write-Host "=== CORRECCION: aplicar RBAC + Kyverno ===" -ForegroundColor Green
kubectl apply -f k8s/rbac-sensores.yaml
Write-Host "Si Kyverno esta instalado:"
kubectl apply -f k8s/kyverno-solo-sensores.yaml
Write-Host "Ahora intenta crear de nuevo el intruso falso - debe ser RECHAZADO por admision / RBAC."
Write-Host "Esa captura es la Figura 3F."
