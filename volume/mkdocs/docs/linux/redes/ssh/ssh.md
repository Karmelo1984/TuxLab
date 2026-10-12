---
title: "Guía de SSH"
authors:
  - Carmelo Molero Castillo
date: 2025-03-21
version: 1.2.0
---

# Guía de SSH

![SSH](img/img-ssh-header-02.svg)

**Descripción**:  
SSH (Secure Shell) es un protocolo de red que permite a los usuarios acceder de forma segura a una computadora remota a través de una conexión encriptada. Proporciona un canal seguro sobre una red no segura, como Internet, para realizar tareas como ejecutar comandos, transferir archivos y gestionar sistemas de forma remota.

SSH es una herramienta fundamental para la administración remota de sistemas y la transferencia segura de archivos en redes no seguras. Proporciona una capa adicional de seguridad al encriptar las comunicaciones entre el cliente y el servidor, lo que protege los datos sensibles de posibles ataques.

**Características principales**:  
- ✅ **Acceso Remoto** - Permite administrar servidores y solucionar problemas en sistemas remotos.  
- ✅ **Transferencia de Archivos** - Usa SCP y SFTP para transferir archivos de forma segura.  
- ✅ **Túneles Seguros** - Cifra el tráfico entre dos puntos en una red para acceso seguro.  
- ✅ **Automatización de Tareas** - Se integra en scripts para ejecución de comandos remotos.  

---

## Instalación

Antes de usar SSH, asegúrate de cumplir con los **requisitos previos**:

### Requisitos previos
- 📌 **Sistema operativo compatible**: Linux, macOS y Windows (con OpenSSH).  
- 📌 **Dependencias**: OpenSSH instalado tanto en cliente como en servidor.  
- 📌 **Acceso**: Se requieren permisos de administrador para la configuración del servidor SSH.  

### Instalación en Linux / macOS

```bash
# Instalar OpenSSH en Debian/Ubuntu
sudo apt update && sudo apt install openssh-server -y

# Verificar estado del servicio
sudo systemctl status ssh
```

### Instalación en Windows

En Windows 10/11, el cliente OpenSSH suele venir instalado. Comprobarlo desde PowerShell:

```powershell
ssh -V
Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH*'
```

Para instalar el **cliente** si falta, desde PowerShell con privilegios de administrador:

```powershell
Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0
```

Para habilitar el **servidor** en Windows, seguir el procedimiento oficial correspondiente a su edición; `Get-WindowsFeature` es específico de Windows Server, no el procedimiento general de Windows 10/11. También puede usarse PuTTY como cliente.

---

## Uso de SSH

### Conectarse a un servidor remoto

```bash
ssh usuario@servidor
```

Si el puerto SSH ha sido cambiado:

```bash
ssh -p PUERTO usuario@servidor
```

---

## Configurar SSH para el acceso a servidor mediante clave pública

SSH permite autenticarse sin contraseña mediante claves públicas. Para configurarlo:

```bash
# Paso 1: Revisar si ya existe una clave pública (no sobrescribirla)
ls -l ~/.ssh/*.pub

# Si no hay claves, crear una nueva ED25519
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519

# Paso 2: Copiar la clave pública elegida al servidor remoto
ssh-copy-id -i ~/.ssh/id_ed25519.pub usuario@servidor

# Paso 3: Verificar el inicio de sesión
ssh usuario@servidor
```

**Nota:** si el cliente ya dispone de una clave RSA válida, **se puede reutilizar** sin crear ED25519. En el NUC del ejemplo existía `~/.ssh/id_rsa.pub` y se copió mediante `ssh-copy-id -i ~/.ssh/id_rsa.pub pi@192.168.1.20`. Nunca publicar la clave privada.

Si `ssh-copy-id` no está disponible, puedes copiar manualmente la clave pública:

```bash
cat ~/.ssh/id_ed25519.pub | ssh usuario@servidor 'umask 077; mkdir -p ~/.ssh; cat >> ~/.ssh/authorized_keys; chmod 600 ~/.ssh/authorized_keys' 
```

---

## Configuración Avanzada

Para mejorar la seguridad, puedes modificar la configuración de SSH editando:

```bash
sudo nano /etc/ssh/sshd_config
```

Recomendaciones:
- **No permitir entrada directa como root** (`PermitRootLogin no`).
- **Priorizar autenticación mediante claves**. Antes de aplicar `PasswordAuthentication no`, verificar el acceso con clave desde otra terminal y disponer de un mecanismo de recuperación.
- Cambiar el puerto puede reducir ruido de escaneos automáticos, pero **no reemplaza** la autenticación segura ni un firewall.

Validar sintaxis antes de recargar la configuración:

```bash
sudo sshd -t
sudo systemctl reload ssh
```

Mantener una sesión SSH abierta hasta comprobar que la nueva configuración funciona.

---

## Solución de Problemas

| Síntoma | Interpretación habitual | Comprobación |
|---|---|---|
| `Name or service not known` / `.local` no resuelve | DNS/mDNS, no necesariamente equipo apagado | Router, `getent hosts`, ARP |
| `Connection refused` | La IP responde, pero el puerto 22 rechaza conexiones | Servidor SSH, firewall y escucha TCP |
| `Connection timed out` | Ruta, dispositivo desconectado o cortafuegos silencioso | `ping`, IP y redes |
| `Permission denied (publickey)` | Falta autorización de la clave o permisos correctos | `~/.ssh/authorized_keys`, `ssh -v` |
| `REMOTE HOST IDENTIFICATION HAS CHANGED` | Cambió la clave de host: puede ser reinstalación **o ataque** | Confirmar huella por canal seguro antes de modificar `known_hosts` |

**Error: "Connection refused"**  
🔹 Solución: Verifica que el servicio SSH esté activo con:

```bash
sudo systemctl status ssh
```

**Error: "Permission denied (publickey)"**  
🔹 Solución: Asegúrate de que la clave pública esté en `~/.ssh/authorized_keys` en el servidor.

---

## **Aplicaciones Prácticas de SSH**  

SSH permite muchas aplicaciones avanzadas más allá del acceso remoto. Aquí te mostramos algunos ejemplos útiles:  

### **Montar una carpeta remota con SSHFS**  
Si necesitas acceder a archivos de un servidor como si fueran locales, puedes usar **SSHFS**.  

#### **Ejemplo: Acceder a una base de datos SQLite con DBeaver**  

1. **Instala SSHFS en tu máquina local:**  
   ```bash
   sudo apt install sshfs
   ```  
2. **Monta la carpeta remota en tu máquina local:**  
   ```bash
   mkdir ~/jellyfin_db
   sshfs mediauser@192.168.1.140:/home/mediauser/docker/jellyfin/volume/config/data ~/jellyfin_db
   ```  
3. **Abre DBeaver y selecciona el archivo:**  
   - Ve a `~/jellyfin_db/jellyfin.db` y ábrelo como base de datos SQLite.  
4. **Desmontar la carpeta cuando termines:**  
   ```bash
   fusermount3 -u ~/jellyfin_db
   ```  
   
---

## Otras guías sobre SSH

- [SSHFS: montar sistemas de archivos remotos desde Linux Mint](../../sistemas-archivos/sshfs/sshfs.md).
- [Primer acceso y recuperación SSH en Raspberry Pi](../../../raspberrypi/acceso-conectividad/ssh/acceso-recuperacion.md).

!!! note "Autenticación por clave en un equipo de pruebas"
    En la Raspberry Pi 4 se reutilizó una clave pública RSA existente (`~/.ssh/id_rsa.pub`) mediante `ssh-copy-id`. No es necesario regenerar claves si se dispone de una válida. Nunca publicar la clave privada en una documentación.


### Comprobación de SSH sin interacción (scripts y montajes)

Para automatizaciones se necesita evitar prompts de contraseñas o aceptación de claves inesperadas:

```bash
ssh -o BatchMode=yes -o ConnectTimeout=3 \
    -o StrictHostKeyChecking=yes usuario@servidor true
```

El comando solo funcionará cuando la clave SSH del usuario ya esté autorizada y la clave de host se haya verificado y aceptado previamente. Un error de conexión no implica necesariamente que el servidor esté mal configurado: puede estar apagado.

En Linux Mint, [SSHFS](../../sistemas-archivos/sshfs/sshfs.md) utiliza esta comprobación en la propuesta de montaje bajo demanda de la Raspberry (pendiente de probar con el equipo desconectado).
