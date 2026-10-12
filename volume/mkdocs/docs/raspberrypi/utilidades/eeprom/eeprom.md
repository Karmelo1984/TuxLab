---
title: "Flashear EEPROM en Raspberry Pi"
authors:
  - Carmelo Molero Castillo
date: 2025-03-21
version: 1.0.0
---

# Flashear EEPROM

![EEPROM](img/img-eeprom-header-01.svg)

**Descripción**:

Este documento describe el proceso de flasheo de la EEPROM en una Raspberry Pi para actualizar el firmware del sistema.

- [Documentación oficial de Raspberry Pi](https://www.raspberrypi.org/documentation/)

**Características principales**:

- ✅ **Actualización de firmware** - Instala la última versión disponible del firmware de Raspberry Pi.  
- ✅ **Compatibilidad** - Compatible con diferentes versiones de Raspberry Pi.  
- ✅ **Comprobación de versión** - Verifica que la actualización se haya realizado correctamente.  

---

## Instalación

Antes de actualizar la EEPROM, asegúrate de contar con los permisos de administrador y tener una conexión a internet estable.

### Actualización del firmware

Ejecuta los siguientes comandos:

```bash
# Actualizar Raspbian
sudo apt-get -y update && sudo apt-get -y upgrade

# Instalar rpi-eeprom y rpi-eeprom-images
sudo apt-get -y install rpi-eeprom rpi-eeprom-images

# Reiniciar el sistema para aplicar cambios
sudo shutdown -r now
```

### Verificación de la versión del firmware
Tras el reinicio, verifica la versión instalada con:

```bash
sudo rpi-eeprom-update
```

---

## Solución de problemas

**Error: La actualización no se aplica correctamente**  

- Solución: Asegúrate de ejecutar los comandos con permisos de superusuario (`sudo`).  

**Error: No se puede instalar `rpi-eeprom`**  

- Solución: Verifica tu conexión a internet e intenta nuevamente con `sudo apt-get update`.
