# Sesión 13 - Zero Trust - Grupo 4 - UNIAJC

Arquitectura integrada: MetroMIO (transporte), HospitValle (salud) y AgroSugar (agricultura).
Principio: nunca confiar, siempre verificar.

## Estructura
- `reto1-mtls/` - mTLS en MetroMIO: Nginx + Docker + scripts PowerShell
- `reto2-hospitvalle/` - LUKS2 + SealedSecret + SecurityContext + RBAC + NetworkPolicy
- `reto3-agrosugar/` - default-deny-all + políticas 2, 3, 4 + corrección ataque de etiqueta
- `evidencias/` - Capturas de verificación (Figuras 1A-1D, 2A-2H, 3A-3F)

## Cómo ejecutar
Ver LEEME en cada carpeta de reto. En resumen:
- Reto 1: `docker compose up -d` y `.\Probar-Matriz.ps1`
- Reto 2: `.\Generar-SealedSecret.ps1` y `.\Aplicar-Reto2.ps1`, LUKS2 en WSL2
- Reto 3: `.\Aplicar-Reto3.ps1`, `.\Probar-Matriz-Reto3.ps1`, `.\Ataque-Etiqueta.ps1`

## Seguridad
Este repositorio NO contiene secretos. Verificación:
```
gitleaks detect --source . --verbose
# Resultado esperado: no leaks found
```
Nunca se suben: `.key`, `.crt`, contraseñas, `pg-secret.yaml` en claro, cabecera LUKS ni discos `.img`.
El único secreto permitido es `sealed-pg-secret.yaml`, porque está cifrado y solo el controlador del clúster puede abrirlo.

## Equipo - Grupo 4
Leonardo Ángel Gómez, Lidny Julieth Manzano Garcia, Jadith Milena Sáenz Magallanes, Shalom Sofía Vargas Muñoz
UNIAJC - Arquitectura de Sistemas Computacionales S641B - Ing. Alkigner Cuesta Rodríguez
