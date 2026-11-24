# Reto 3 - AgroSugar (40 pts)

## Orden obligatorio
1. Aplicar-Reto3.ps1: namespace + pods demo + politicas 1-2-3-4 EN ORDEN
2. Probar-Matriz-Reto3.ps1: solo caso 1 pasa, casos 2, 3 y 4 bloqueados
3. Ataque-Etiqueta.ps1: intruso con app=sensor SI conecta (ataque), luego con RBAC + Kyverno es RECHAZADO

## Causa raiz
La NetworkPolicy selecciona por etiqueta, no por identidad. La correccion es controlar con RBAC + admision QUIEN puede poner la etiqueta, no cambiar la etiqueta.
