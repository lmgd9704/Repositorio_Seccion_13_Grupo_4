#!/bin/bash
# Reto 2a - LUKS2 - SE HACE EN WSL2 / UBUNTU, NO en PowerShell directo
# En Windows 11: wsl  -> entras a Ubuntu -> pegas estos comandos
# Si no tienes WSL: en PowerShell como Admin -> wsl --install  -> reiniciar -> wsl
set -e
echo "=== 1. Crear disco de laboratorio 100 MB ==="
fallocate -l 100M disco-uci.img
fallocate -l 100M disco-plano.img
echo "=== 2. Formatear LUKS2 AES-256-XTS ==="
sudo cryptsetup luksFormat --type luks2 --cipher aes-xts-plain64 --key-size 512 --hash sha256 disco-uci.img
echo "=== 3. Verificar formato y keyslots ==="
sudo cryptsetup luksDump disco-uci.img | head -n 40
echo "=== 4. Segundo keyslot (segunda contrasena) ==="
sudo cryptsetup luksAddKey disco-uci.img
sudo cryptsetup luksDump disco-uci.img | grep -A 2 "Key Slot"
echo "=== 5. Respaldo de cabecera (OBLIGATORIO) ==="
sudo cryptsetup luksHeaderBackup disco-uci.img --header-backup-file cabecera-uci.bak
ls -lh cabecera-uci.bak
echo "=== 6. Abrir, formatear, escribir dato de prueba ==="
sudo cryptsetup open disco-uci.img uci-cifrado
sudo mkfs.ext4 /dev/mapper/uci-cifrado
sudo mount /dev/mapper/uci-cifrado /mnt/uci || (sudo mkdir -p /mnt/uci && sudo mount /dev/mapper/uci-cifrado /mnt/uci)
echo "Paciente: HV-AMB-012 - Signos vitales simulados" | sudo tee /mnt/uci/paciente.txt
cat /mnt/uci/paciente.txt
echo "=== 7. Disco plano para comparar ==="
sudo mkfs.ext4 disco-plano.img
sudo mount -o loop disco-plano.img /mnt/uci-plano 2>/dev/null || (sudo mkdir -p /mnt/uci-plano && sudo mount -o loop disco-plano.img /mnt/uci-plano)
echo "Paciente: HV-AMB-012 - Signos vitales simulados" | sudo tee /mnt/uci-plano/paciente.txt
echo "=== 8. Cerrar volumnes ==="
sudo umount /mnt/uci; sudo cryptsetup close uci-cifrado
sudo umount /mnt/uci-plano
echo "=== 9. PRUEBA CLAVE: strings ==="
echo "--- Disco PLANO (SI debe leerse el texto) ---"
strings disco-plano.img | grep Paciente || echo "No se encontro"
echo "--- Disco CIFRADO (NO debe leerse el texto) ---"
strings disco-uci.img | grep Paciente || echo "No se encontro el texto = CORRECTO, cifrado funciona"
