Reto 2a - LUKS2 no se hace en PowerShell, se hace en WSL2/Ubuntu.
Pasos: PowerShell Admin -> wsl --install -> reiniciar -> escribir 'wsl' -> copiar luks2-pasos-WSL2.sh y pegarlo.
Evidencias: Figura 2A = luksDump (LUKS2, AES-256-XTS, 2 keyslots). Figura 2B = strings en disco plano SI lee. Figura 2C = strings en disco cifrado NO lee.
