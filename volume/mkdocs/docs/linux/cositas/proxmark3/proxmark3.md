---
title: "Configuración e instalación de Proxmark3"
authors:
  - Carmelo Molero Castillo
date: 2025-08-09
version: 1.0.0
---

# Configuración e instalación de Proxmark3

![Proxmark3](https://github.com/RfidResearchGroup/proxmark3/raw/master/docs/images/pm3-logo.png)

**Descripción**:  

Esta guía resume la instalación y configuración básica de Proxmark3 con firmware actualizado al 09/08/2025. Se incluyen referencias a recursos clave y pasos claros para flashear y conectar el dispositivo.

---

## Instalación

### Requisitos previos

- Repositorio oficial y snapshot actualizado:  
  - [RfidResearchGroup/proxmark3](https://github.com/RfidResearchGroup/proxmark3)
  - Archivo snapshot: [proxmark3-master.zip](./files/proxmark3-master.zip)

- Guía introductoria recomendada:  
  - [thehackingday](https://blog.thehackingday.com/2021/02/primeros-pasos-con-la-proxmark3-en-kali.html)


>Nota importante: Al actualizar el cliente es obligatorio actualizar también el firmware del Proxmark3 para evitar incompatibilidades.

---

### Instalación en Linux

```bash
sudo apt update
sudo apt install -y build-essential pkg-config cmake git libreadline-dev libbz2-dev liblz4-dev libusb-1.0-0-dev libssl-dev python3-dev lua5.3 liblua5.3-dev gcc-arm-none-eabi

git clone https://github.com/RfidResearchGroup/proxmark3
cd proxmark3

make clean && make PLATFORM=PM3GENERIC all

cd client

sudo ./proxmark3 /dev/ttyACM0 --flash --unlock-bootloader --image ../bootrom/obj/bootrom.elf --image ../armsrc/obj/fullimage.elf

sudo ./proxmark3 /dev/ttyACM0
```

---

## Uso de Proxmark3 para análisis de tarjetas

## Configuración Básica

* Verifica que el firmware y hardware estén sincronizados con:

```bash
hw version
```

* Comprueba el estado con:

```bash
hw status
```

---




















## Uso de Proxmark3 para análisis de tarjetas

## Configuración Básica

* Verifica que el firmware y hardware estén sincronizados con:

```bash
hw version
```

* Comprueba el estado con:

```bash
hw status
```

---

## Secuencia para clonar una tarjeta Mifare Classic

1. **Preparación:**
   Ten a mano la tarjeta original (la que quieres clonar) y la tarjeta en blanco (donde harás la copia).

2. **Detectar y analizar la tarjeta original:**
   Coloca la tarjeta original en el lector y ejecuta:

   ```bash
   hf search
   ```

   Esto identifica el tipo de tarjeta.

3. **Automatizar la búsqueda de claves, volcado y almacenamiento:**
   Con la tarjeta original aún en el lector, ejecuta:

   ```bash
   hf mf autopwn
   ```

   Este comando intentará encontrar automáticamente las claves de acceso, realizará el volcado de la tarjeta, y guardará:

   * Las claves en un archivo `.key.bin`
   * El volcado en un archivo `.dump.bin` (el volcado binario para restaurar)

4. **Preparar la tarjeta para la copia:**
   Retira la tarjeta original del lector y coloca la tarjeta en blanco o destino.

5. **Escribir la imagen en la tarjeta destino:**
   Ejecuta (usando el nombre del archivo `.dump.bin` generado):

   ```bash
   hf mf restore -f /ruta/al/archivo-dump.bin
   ```

   Esto escribirá el contenido del volcado en la tarjeta en blanco.

6. **Verificar clonación (opcional):**
   Puedes hacer un nuevo `hf search` o incluso un `hf mf dump` para comprobar que la clonación fue exitosa.

---

**Notas importantes:**

* Algunas tarjetas tienen protecciones avanzadas que pueden impedir la clonación completa.
* La tarjeta destino debe ser compatible (misma familia y tamaño).
* Siempre realiza estas operaciones respetando la legalidad y la ética.











































## Configuración Avanzada

(Por definir según necesidades específicas y proyectos.)

---

## Solución de Problemas

**Error: Device / Firmware mismatch**
🔹 Solución: Actualiza el firmware y el cliente asegurándote de compilar para la plataforma correcta (`PLATFORM=PM3GENERIC`) y flashea ambos: bootrom y fullimage.

---


hf mf autopwn