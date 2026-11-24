# Reto 1 - mTLS MetroMIO - Windows 11 (SIN maquina virtual)

## Por que no se necesita VM
La VM se pegaba porque Docker dentro de VM + Windows es doble virtualizacion.
En Windows 11 se hace directo: Docker Desktop usa WSL2, y PowerShell trae todo lo necesario.
NO usar VirtualBox / VMware para este reto.

## Requisitos (una sola vez)
1. Docker Desktop instalado y en modo Linux containers (el que viene por defecto)
2. Git for Windows instalado (trae openssl para PowerShell) - o usar Docker Desktop que tambien lo trae
3. En PowerShell como Administrador, verificar:
   docker --version
   openssl version
   Si openssl no se reconoce: $env:Path += ";C:\Program Files\Git\usr\bin"

## Paso 1 - Certificados (YA GENERADOS en esta carpeta, no hay que regenerarlos)
La carpeta certs/ ya contiene todo, generado y verificado:
- ca.crt / ca.key - CA propia MetroMIO-Lab-CA
- server.crt / server.key - SAN DNS:ingress.metromio.net, serverAuth
- client.crt / client.key - clientAuth (caso B, el valido)
- cliente-malo.crt / cliente-malo.key - firmado por CA-Atacante (caso C)
- client-sin-auth.crt / client-sin-auth.key - firmado por CA correcta pero con serverAuth, SIN clientAuth (caso D)
Si el docente pide regenerarlos en vivo: clic derecho > Ejecutar con PowerShell > Generar-Certificados.ps1

## Paso 2 - Hosts
PowerShell como Administrador:
  notepad C:\Windows\System32\drivers\etc\hosts
Agregar al final:  127.0.0.1 ingress.metromio.net
Guardar. Sin esto curl no resuelve el nombre.

## Paso 3 - Levantar Nginx
En esta carpeta, en PowerShell:
  docker compose up -d
  docker compose ps
  docker logs reto1-mtls-windows-nginx-1

## Paso 4 - Probar la matriz A-D
  .\Probar-Matriz.ps1
Resultados esperados:
  A sin certificado: 400 No required SSL certificate was sent
  B certificado valido: 200 ¡Acceso concedido!
  C otra CA: 400 / 403
  D sin clientAuth: 400

## Paso 5 - Evidencias para el informe
- Captura de Probar-Matriz.ps1 con los 4 casos = Figuras 1A-1D
- Archivo evidencias/VERIFICACION-COMPLETA.txt = verificacion openssl (SAN, clientAuth, verify OK / failed)
- Si les piden demostrar que el D falla aunque la firma sea valida: mostrar que
  openssl verify -CAfile ca.crt client-sin-auth.crt dice OK (firma valida)
  pero curl da 400 (proposito incorrecto). Esa es la trampa del reto.

## NUNCA subir a Git
*.key, ca.crt, server.crt, client.crt -> NO van al repo. Solo nginx.conf, docker-compose.yml y los scripts .ps1
