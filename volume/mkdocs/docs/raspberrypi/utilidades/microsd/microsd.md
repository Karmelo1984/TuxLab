---
title: "Reducir imagen de MicroSD en Raspberry Pi"
authors:
  - Carmelo Molero Castillo
date: 2025-03-21
version: 1.0.0
---

# Reducir imagen de MicroSD

![MicroSD](img/img-microsd-header-01.svg)

**Descripción**:

Este documento explica cómo reducir el tamaño de una imagen de MicroSD en una Raspberry Pi usando la herramienta **PiShrink**.

- [PiShrink en GitHub](https://github.com/Drewsif/PiShrink)

**Características principales**:

- ✅ **Optimiza espacio** - Reduce el tamaño de las imágenes de sistema.
- ✅ **Automatización** - No requiere configuración manual del sistema de archivos.
- ✅ **Compresión opcional** - Admite compresión con `gzip` y `xz` para ahorrar aún más espacio.

---

## Instalación

Antes de comenzar, asegúrate de tener acceso a una terminal con permisos de administrador.

### Descarga e instalación de PiShrink

Ejecuta los siguientes comandos:

```bash
$ wget https://raw.githubusercontent.com/Drewsif/PiShrink/master/pishrink.sh
$ chmod +x pishrink.sh
$ sudo mv pishrink.sh /usr/local/bin
```

---

## Uso

Para reducir una imagen de Raspberry Pi, usa el siguiente comando:

```bash
$ sudo pishrink.sh imagen-original.img imagen-reducida.img
```

**Opciones disponibles:**

```
$ pishrink.sh $0 [-adhrsvzZ] imagen-original.img [imagen-reducida.img]
    -s  No expandir el sistema de archivos cuando la imagen se inicia por primera vez
    -v  Activar 'verbose'
    -r  Usar opción avanzada de reparación del sistema de archivos si falla la normal
    -z  Comprimir imagen con gzip
    -Z  Comprimir imagen con xz
    -a  Comprimir imagen en paralelo usando múltiples núcleos
    -d  Registrar mensajes de depuración
    imagen-reducida.img, el script hará una copia de imagen-original.img y trabajará a partir de esa copia
```

---

## Solución de problemas

**Error: **`e2fsck`** y **`metadata_csum`** está desactualizado**

- Solución: Usa Ubuntu 16.10 o superior para evitar problemas de compatibilidad.

**Error: Problemas con "Carpetas compartidas" en VirtualBox**

- Solución: Copia la imagen a una ubicación local antes de procesarla.
