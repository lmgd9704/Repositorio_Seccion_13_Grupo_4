# Reto 2 - HospitValle (35 pts)

## 2a LUKS2 (en WSL2/Ubuntu)
Ver luks/luks2-pasos-WSL2.sh: AES-256-XTS, 2 keyslots, respaldo de cabecera, prueba strings plano vs cifrado.

## 2b SealedSecret
Generar-SealedSecret.ps1: pide contrasena por teclado, crea Secret fuera del repo, lo sella con kubeseal y borra el archivo en claro. Solo sealed-pg-secret.yaml (cifrado) va al repo.

## 2c SecurityContext + RBAC + NetworkPolicy
Aplicar-Reto2.ps1: aplica namespace, RBAC, Pod y NetworkPolicy. Verifica kubectl auth can-i = no e internet bloqueada.
