# Reto 2 - HospitValle (35 pts) - Quien lo hace y como

## Reparto
- 2a LUKS2: en WSL2 / Ubuntu (ver carpeta luks/)
- 2b SealedSecret: en el cluster, con kubectl + kubeseal (Generar-SealedSecret.ps1)
- 2c SecurityContext + RBAC + NetworkPolicy: en el cluster (Aplicar-Reto2.ps1)

## Requisitos del companero (NO tuyos si tu no tienes Docker)
- Docker Desktop con Kubernetes habilitado, o Minikube
- kubectl
- kubeseal
- WSL2 con Ubuntu (para LUKS2)

## Orden
1. kubectl apply -f k8s/namespace.yaml
2. SealedSecret: Generar-SealedSecret.ps1 (pide contrasena por teclado, NO queda en Git)
3. Aplicar-Reto2.ps1 (RBAC + Pod + NetworkPolicy)
4. LUKS2 en WSL2: luks/luks2-pasos-WSL2.sh
5. Gitleaks: gitleaks detect --source . --verbose  -> debe decir "no leaks found"

## NUNCA subir a Git
- La contrasena, pg-secret.yaml en claro, *.key, cabecera-uci.bak, disco-*.img
- Solo subir: *.yaml de k8s, sealed-pg-secret.yaml (ese SI, porque esta cifrado), scripts .ps1/.sh
