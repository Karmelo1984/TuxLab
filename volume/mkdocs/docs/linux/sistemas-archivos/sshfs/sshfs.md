---
title: "SSHFS: montar carpetas remotas en Linux Mint"
authors:
  - Carmelo Molero Castillo
date: 2026-10-12
version: 1.2.0
---

# SSHFS: montar carpetas remotas en Linux Mint

![SSHFS](img/img-sshfs-header-01.svg)

**Descripción**: montar por SSH un directorio remoto para utilizarlo desde el explorador de archivos de Linux Mint. El ejemplo real utiliza una Raspberry Pi, pero el procedimiento es reutilizable con otros equipos Linux que dispongan de servidor SSH. El **automontaje opcional está documentado, pero no probado en este NUC**.

---

## Requisitos

- Cliente Linux con `sshfs`, `fusermount3` y `systemd --user`.
- Servidor remoto con SSH y un usuario con permisos.
- Clave de anfitrión SSH verificada antes de automatizar.

Para preparar el servidor de ejemplo: [acceso SSH en Raspberry Pi](../../../raspberrypi/acceso-conectividad/ssh/acceso-recuperacion.md) y [guía SSH genérica](../../redes/ssh/ssh.md).

## Sintaxis reutilizable para otros equipos

Desde el cliente Linux, sustituir los valores de ejemplo según el servidor, la ruta y el usuario:

```bash
mkdir -p ~/remoto
sshfs usuario@servidor:/ruta/remota ~/remoto \
  -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3,idmap=user

# Al terminar:
fusermount3 -u ~/remoto
```

Para automatizar el acceso sin contraseñas se recomienda autenticación SSH por clave pública. El ejemplo siguiente conserva las rutas reales de la instalación documentada.

## Ejemplo práctico: Raspberry Pi desde Linux Mint

### Esquema de directorios

En el NUC se preparó:

```text
/home/carmelo/RaspberryPi/
├── raiz/            # SSHFS: / de la Raspberry
└── pi -> raiz/home/pi # Enlace simbólico, sin segundo montaje SSHFS
```

La Raspberry permanece accesible en `pi@192.168.1.20`. El montaje de `/` **no concede privilegios administrativos**: SSHFS opera con los permisos del usuario remoto `pi`.

### Instalar SSHFS

```bash
# En Linux Mint, NO en la Raspberry
sudo apt update
sudo apt install -y sshfs
mkdir -p ~/RaspberryPi/raiz
```

Si existía un montaje anterior directamente en `~/RaspberryPi`, desmontarlo primero:

```bash
if mountpoint -q ~/RaspberryPi; then
  fusermount3 -u ~/RaspberryPi
fi
```

### Montar manualmente la raíz

```bash
sshfs pi@192.168.1.20:/ ~/RaspberryPi/raiz \
  -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3,idmap=user
```

Crear el enlace al directorio personal:

```bash
ln -s raiz/home/pi ~/RaspberryPi/pi
```

**No repetir `ln -s` si el enlace ya existe.** Verificar:

```bash
findmnt ~/RaspberryPi/raiz
ls -la ~/RaspberryPi/
ls ~/RaspberryPi/pi
xdg-open ~/RaspberryPi
```

El resultado real de `tree -L 2` mostró `pi -> raiz/home/pi` y los directorios `bin`, `etc`, `home`, `mnt`, `usr`, `var`, etc. bajo `raiz`.

### Desmontar de forma segura

```bash
fusermount3 -u ~/RaspberryPi/raiz
```

No desmontar mientras se están guardando archivos desde Mint. Evitar editar archivos críticos del sistema remoto directamente a través de un gestor de archivos sin copia de seguridad.

---

## Acceso sin contraseña mediante clave SSH (verificado)

En el NUC existía `~/.ssh/id_rsa.pub`, reutilizada:

```bash
ssh-copy-id -i ~/.ssh/id_rsa.pub pi@192.168.1.20
ssh pi@192.168.1.20
```

La autenticación posterior se comprobó **sin contraseña**. No copiar la clave privada a la Raspberry ni al sitio MkDocs. Para claves nuevas se recomienda ED25519; no es necesario reemplazar una clave RSA existente que funcione correctamente.

---

## Cuando la Raspberry está apagada o desconectada

**Condición real del montaje:** durante las pruebas la Raspberry se encontraba encendida. Se confirmó un montaje manual de `/` y el acceso mediante el enlace `pi`, así como la autenticación sin contraseña. **No se completó la prueba con la Raspberry apagada ni se desplegó el automontaje**.

Se deben distinguir tres casos:

| Caso | Resultado esperado | Precaución |
|---|---|---|
| El NUC inicia y la Raspberry está apagada | Sin montaje ni fallo de arranque | Script en segundo plano y sondeo limitado |
| La Raspberry se enciende después | El temporizador detecta SSH y monta | Retardo de hasta el siguiente sondeo |
| El HDD o la Raspberry se desconectan con SSHFS activo | El acceso FUSE puede quedar bloqueado/obsoleto mientras intenta recuperar | Evitar abrir directorios remotos en tareas críticas; desmontar manualmente cuando proceda |

Una caída de red no se puede convertir en "acceso sin errores" para programas que ya mantienen abiertos archivos remotos. Usar disco local para trabajo importante y sincronizar cuando regrese el servidor.

### Diagnosticar sin bloquear el explorador

```bash
# En Linux Mint, sin abrir carpetas remotas
ssh -o BatchMode=yes -o ConnectTimeout=3 pi@192.168.1.20 true
findmnt --mountpoint "$HOME/RaspberryPi/raiz" || echo "Raspberry no montada"
# Si hay un montaje obsoleto, cerrar aplicaciones y desmontar:
fusermount3 -u ~/RaspberryPi/raiz
```

Si el desmontaje normal está impedido por el proceso desconectado, `fusermount3 -uz` es un último recurso para desacoplar el montaje FUSE, **no garantiza que las escrituras pendientes se hayan conservado**.

---

## Automontaje tolerante a desconexiones — pendiente de desplegar

**Requisito:** la Raspberry no está siempre encendida. No conviene bloquear el inicio de Linux Mint o generar errores continuos cuando no responde.

Se documenta una solución de **script + servicio/temporizador systemd de usuario**; se propone como siguiente paso y **no se ha ejecutado aún**.

### 1. Instalar el script de comprobación

El archivo [`scripts/montar-raspberrypi-sshfs.sh`](scripts/montar-raspberrypi-sshfs.sh) hace lo siguiente:

1. Comprueba si hay un montaje SSHFS previo.
2. Si ya está accesible, sale sin hacer nada.
3. Si es un montaje obsoleto, intenta desmontarlo sin bloquear.
4. Si la Raspberry no responde por SSH con clave, sale **correctamente sin montar**.
5. Si responde, ejecuta SSHFS con opciones de reconexión y tiempo limitado.

```bash
# Desde el directorio del paquete de documentación, copiar a ~/.local/bin en Mint
mkdir -p ~/.local/bin
cp scripts/montar-raspberrypi-sshfs.sh ~/.local/bin/montar-raspberrypi-sshfs.sh
chmod +x ~/.local/bin/montar-raspberrypi-sshfs.sh
```

El comando `cp` requiere estar en una copia local de esta carpeta de documentación. Si trabajas directamente con el proyecto MkDocs, ajustar la ruta completa.

### 2. Crear el servicio de usuario

Archivo `~/.config/systemd/user/raspberrypi-sshfs.service`:

```ini
[Unit]
Description=Comprobar y montar Raspberry Pi por SSHFS

[Service]
Type=oneshot
ExecStart=%h/.local/bin/montar-raspberrypi-sshfs.sh
```

### 3. Crear el temporizador de usuario

Archivo `~/.config/systemd/user/raspberrypi-sshfs.timer`:

```ini
[Unit]
Description=Reintento periódico de montaje SSHFS de Raspberry Pi

[Timer]
OnStartupSec=20s
OnUnitInactiveSec=60s
AccuracySec=15s
Unit=raspberrypi-sshfs.service

[Install]
WantedBy=timers.target
```

Crear directorio e instalar archivos:

```bash
mkdir -p ~/.config/systemd/user
cp scripts/raspberrypi-sshfs.service ~/.config/systemd/user/
cp scripts/raspberrypi-sshfs.timer ~/.config/systemd/user/
systemctl --user daemon-reload
systemctl --user enable --now raspberrypi-sshfs.timer
systemctl --user list-timers raspberrypi-sshfs.timer
```

Antes de automatizar, ejecutar manualmente el script y comprobar el montaje:

```bash
~/.local/bin/montar-raspberrypi-sshfs.sh
findmnt ~/RaspberryPi/raiz
```

!!! info "Comportamiento con la Raspberry apagada"
    El script sale con código 0 si la Pi está desconectada. El temporizador sigue ejecutando comprobaciones periódicas al **iniciar sesión** en Mint. Cuando la Pi se encienda, el montaje debe aparecer. Si una aplicación intenta leer el montaje FUSE durante una caída, aún podría experimentar espera/errores; no prometer disponibilidad absoluta.

!!! warning "Antes de desplegar"
    Asegurarse de que no existe un SSHFS manual activo en `~/RaspberryPi/raiz`; comprobar el script local y sus permisos. El servicio no debe ejecutarse como root. Usar un cliente y un destino confiables; `StrictHostKeyChecking=yes` presupone que ya se ha validado y registrado la clave del host remoto.

## Guías relacionadas

- [Guía general de SSH](../../redes/ssh/ssh.md).
- [Recuperación de acceso SSH en Raspberry Pi](../../../raspberrypi/acceso-conectividad/ssh/acceso-recuperacion.md).
- [HDD externo y montajes persistentes en Raspberry Pi](../../../raspberrypi/utilidades/pi-hdd/pi-hdd.md).

## Referencias

- [Proyecto SSHFS](https://github.com/libfuse/sshfs).
- [Timers de systemd](https://www.freedesktop.org/software/systemd/man/latest/systemd.timer.html).
