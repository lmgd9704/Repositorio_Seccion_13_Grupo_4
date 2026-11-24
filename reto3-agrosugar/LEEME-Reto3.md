# Reto 3 - AgroSugar (40 pts)

## Orden obligatorio
1. Aplicar-Reto3.ps1 (namespace + pods demo + politicas 1-2-3-4 EN ORDEN)
2. Probar-Matriz-Reto3.ps1 (4 casos: solo el 1 pasa)
3. Ataque-Etiqueta.ps1 (demuestra que intruso con app=sensor PASA, luego correccion con RBAC + Kyverno lo BLOQUEA)

## Requisitos del companero
- Docker Desktop con Kubernetes, o Minikube
- kubectl
- (Opcional pero recomendado) Kyverno para la correccion del ataque

## Causa raiz - para decirla en la sustentacion
La NetworkPolicy selecciona por ETIQUETA, no por identidad.
Cualquiera que pueda crear pods puede ponerse la etiqueta app=sensor.
Por eso la correccion NO es cambiar la etiqueta, es controlar con RBAC + admision QUIEN puede ponerla.

## Evidencias
Figura 3A: caso 1 sensor->broker PASA
Figura 3B: caso 2 sensor->internet BLOQUEADO
Figura 3C: caso 3 sensor->db BLOQUEADO
Figura 3D: caso 4 intruso->broker BLOQUEADO
Figura 3E: ataque etiqueta - intruso-falso CONECTA
Figura 3F: despues de correccion - intruso-falso RECHAZADO
