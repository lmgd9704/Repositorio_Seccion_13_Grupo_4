# Reto 1 - mTLS MetroMIO (25 pts)

## Ejecutar (Windows 11, sin VM)
1. PowerShell como Admin: notepad C:\Windows\System32\drivers\etc\hosts -> agregar: 127.0.0.1 ingress.metromio.net
2. docker compose up -d
3. .\Probar-Matriz.ps1

## Resultados esperados
- A sin certificado: 400 No required SSL certificate was sent
- B certificado valido: 200 Acceso concedido
- C otra CA: 400 / 403
- D sin clientAuth: 400

## Seguridad
NO se sube certs/ (.key, .crt, .csr). Los certificados se generan en local con Generar-Certificados.ps1.
