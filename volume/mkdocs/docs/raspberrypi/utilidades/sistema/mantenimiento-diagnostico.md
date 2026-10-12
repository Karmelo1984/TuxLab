---
title: "Mantenimiento y diagnóstico de Raspberry Pi"
authors:
  - Carmelo Molero Castillo
date: 2026-10-12
version: 1.2.0
---

# Mantenimiento y diagnóstico de Raspberry Pi

![Mantenimiento y Diagnóstico](img/img-mantenimiento-diagnostico-header-01.svg)

**Descripción**: actualización de Debian/Raspberry Pi OS, herramientas de administración y localización de fallos de red, cámara, USB y Docker. Caso de referencia: Raspberry Pi 4, Debian 13 ARM64 (octubre de 2026).

## Actualizar el sistema

Sistema observado: **Debian GNU/Linux 13 (Trixie), ARM64**. En el momento de la prueba solo se actualizaron `liblzma5` y `xz-utils`.

```bash
sudo apt-get update
sudo apt-get full-upgrade
sudo apt-get autoremove
sudo apt-get autoclean
```

Herramientas básicas instaladas/comprobadas:

```bash
sudo apt-get install -y htop vim tree fastfetch ca-certificates curl
```

Alias del usuario `pi`:

```bash
echo "alias ll='ls -lh'" >> ~/.bashrc
source ~/.bashrc
```

Tras actualizar, `upgrade` y `dist-upgrade` devolvieron 0 paquetes pendientes. Evitar `rpi-update` salvo diagnóstico específico: puede instalar componentes no considerados una actualización estable ordinaria.

---


---

## Diagnóstico rápido

```bash
# Sistema
hostnamectl
cat /etc/os-release
vcgencmd get_throttled
uptime -s
journalctl --list-boots --no-pager

# Red
nmcli device status
nmcli radio all
ip -4 addr show wlan0

# Cámara
rpicam-hello --list-cameras
pgrep -af 'rpicam-(vid|still)'

# HDD
lsblk -o NAME,SIZE,FSTYPE,LABEL,UUID,MOUNTPOINTS
findmnt /mnt/capturas
sudo journalctl -k --since '30 minutes ago' --no-pager \
  | grep -Ei 'over-current|disconnect|I/O error|EXT4-fs error|voltage'

# Docker
systemctl is-active docker
docker ps
docker compose version
```

---

## Incidencias registradas

| Síntoma | Diagnóstico observado | Resolución / siguiente paso |
|---|---|---|
| `raspberrypi.local: Nombre o servicio desconocido` | No se resolvía mDNS | Buscar IPv4 por ARP, router o Ethernet directo |
| `ssh: connect ... Connection refused` | Puerto 22 no aceptaba conexiones | Crear archivo `ssh` en `bootfs`; completar usuario inicial |
| `pi` con `/usr/sbin/nologin` | Usuario incompleto en primera configuración | Se creó `userconf.txt` cifrado en la partición de arranque |
| `nmcli`: `wlan0 unavailable` | `WIFI disabled` (hardware habilitado) | `sudo nmcli radio wifi on` |
| SSHFS pide contraseña | Clave pública ausente en Raspberry | `ssh-copy-id -i ~/.ssh/id_rsa.pub pi@192.168.1.20` |
| `docker ps`: `permission denied` | Usuario fuera del grupo `docker` | `sudo usermod -aG docker pi`; `newgrp docker` |
| `rpicam-still`: `Device or resource busy` | `rpicam-vid` ocupaba la cámara | Parar la sesión de vídeo antes de tomar fotos |
| `ffplay`: `unspecified size` por tubería SSH | Flujo sin inicialización decodificable en ese intento | Transmisión H.264 por TCP directo (`--listen`) |
| `--codec libav` no reconocido | La versión instalada no ofrece ese códec | Volver a `--codec h264` |
| HDD `sda 0B` | USB reconocido, pero sin bloques disponibles | Revisar alimentación/cable; posteriores pruebas dieron 931,5 GiB |
| `throttled=0x50005` | Subtensión y limitación de frecuencia, actual e histórica | Corregir fuente/cable y comprobar un nuevo arranque |
| `over-current change`, `USB disconnect` | Sobrecorriente USB y desconexiones | En las pruebas mejoró usando USB 2.0; vigilar logs |
| Capturas nocturnas verdes/lavadas | NoIR + luz artificial + reflejos de cristales | Perfil nocturno; corrección digital solo parcial |
| CLAHE apenas altera reflejos | Información exterior superpuesta/oculta | Oscurecer interior, bloquear luz lateral, detector de calidad |

---

## Matriz de diagnóstico: primera comprobación segura

| Si ocurre... | Empezar por... | Evitar... |
|---|---|---|
| No hay acceso por SSH | `ping`, router/ARP, estado de `ssh`, Wi-Fi habilitada | Reinstalar el sistema sin localizar primero el fallo |
| No aparece la cámara | `rpicam-hello --list-cameras` y `pgrep -af rpicam` | Abrir dos procesos libcamera simultáneos |
| H.264 por SSH no abre en `ffplay` | Guardar 5 s a archivo, comprobar con `ffprobe`; probar TCP `--inline --listen` | Atribuir sin pruebas el fallo al sensor |
| HDD se desconecta | `journalctl -k`, `lsblk`, `get_throttled` | Formatear, reiniciar en bucle o usar `fsck` sobre volumen montado |
| Carpeta `/mnt/capturas` vacía | `findmnt /mnt/capturas` y UUID | Guardar imágenes en la microSD por accidente |
| SSHFS no aparece en Mint | `ssh -o BatchMode=yes ... true`, `findmnt` | Configurar montaje obligatorio al arranque si la Raspberry suele estar apagada |
| Imagen nocturna con reflejos | Reducir luz interior y bloquear reflexiones | Intentar recuperar píxeles saturados solo con CLAHE |

Las comprobaciones son orientativas y distinguen **resultado observado** de hipótesis. Repetirlas después de cambios de fuente de alimentación, cable, sistema o periféricos.

---

## Alimentación: interpretar `get_throttled`

- `0x0`: ningún indicador de throttling registrado desde el último arranque.
- `0x1`: subtensión actual.
- `0x4`: reducción de frecuencia actual.
- `0x10000`: hubo subtensión desde el arranque.
- `0x40000`: hubo reducción de frecuencia desde el arranque.

Los bits pueden sumarse. `0x50005` combinaba `0x1`, `0x4`, `0x10000` y `0x40000`. **No extrapolar que `0x0` significa ausencia de problemas de sobrecorriente USB.**

### Arranque frente a reconexión USB

```bash
uptime -s
journalctl --list-boots --no-pager
```

El registro analizado mostraba **un arranque disponible en el journal** y varias desconexiones/reconexiones del HDD. Un solo arranque registrado no permite excluir reinicios más antiguos si no se conserva el journal persistente.

---

## Seguridad y operaciones habituales

- Mantener SSH con clave pública y acceso limitado a la LAN.
- No exponer el puerto TCP `8888` de la cámara a Internet; el H.264 transmitido no está cifrado.
- No añadir cuentas no confiables al grupo `docker`.
- No escribir capturas sobre `/mnt/capturas` si el HDD está desmontado.
- No forzar `fsck` sobre `ext4` montado en lectura/escritura.
- No asumir que `nofail` preserva datos ante un corte eléctrico o del USB; únicamente flexibiliza el arranque.
- Hacer copias de seguridad de fotografías y de `/etc/fstab`, configuración de NetworkManager y scripts.

### Comprobar espacio, memoria y temperatura

```bash
df -h /
free -h
vcgencmd measure_temp
docker stats --no-stream
```

### Desactivar servicios innecesarios

Antes de instalar otro servicio de cámara, buscar los procesos activos y liberar el sensor:

```bash
pgrep -af 'rpicam-(vid|still)'
# Parada manual preferente: Ctrl+C en la terminal que lo inició
```

#### Diagnóstico de cámara por SSH

```bash
rpicam-hello --list-cameras
rpicam-still --nopreview -t 2000 -o /tmp/camara-test.jpg
ls -lh /tmp/camara-test.jpg
```

---


## Continuar según el problema

- [Recuperar SSH y el usuario inicial](../../acceso-conectividad/ssh/acceso-recuperacion.md).
- [Wi-Fi e IP fija con NetworkManager](../../acceso-conectividad/red/wifi-ip-estatica.md).
- [Docker y Docker Compose](../docker/docker.md).
- [Añadir un HDD](../pi-hdd/pi-hdd.md) y [fallos USB / alimentación](../pi-hdd/diagnostico-usb.md).
- [Cámara IMX708 y H.264](../../camara/camara-video.md).
- [Reflejos nocturnos](../../camara/calibracion-reflejos.md).

## Registro de pruebas: qué quedó realmente validado

| Componente | Validación realizada | Lo que NO garantiza |
|---|---|---|
| SSH | Acceso con usuario `pi` y clave pública RSA desde Mint | Acceso desde redes externas o arranque con servidor apagado |
| Red | `wlan0` con IP fija y conexión SSH | Ausencia absoluta de conflictos futuros |
| Docker | Demonio activo, Compose disponible, `hello-world` | Compatibilidad de todas las imágenes de terceros |
| Cámara | Fotografía, archivo H.264 y streaming TCP 1080p | Funcionamiento continuo 24/7 o captura simultánea |
| HDD | Montaje ext4 por UUID, reinicio y transferencia de 512 MiB en USB 2.0 | Fiabilidad a largo plazo; USB 3.0 seguía fallando |
| SSHFS | Raíz montada en Mint y enlace `pi` operativo | Reconexión/automontaje con Raspberry apagada (pendiente) |
| CLAHE | Original y corregida comparadas visualmente | Eliminación de reflejos; fue insuficiente |

---

## Tareas pendientes para el equipo de pruebas

- Ensayar HDD USB 2.0 varias horas y supervisar registros de E/S.
- Validar el temporizador de automontaje SSHFS cuando la Raspberry esté apagada.
- Implementar captura continua y selección de perfiles día/noche desde un solo proceso de cámara.

## Referencias

- [Documentación Raspberry Pi](https://www.raspberrypi.com/documentation/).
- [Documentación Debian](https://www.debian.org/doc/).
