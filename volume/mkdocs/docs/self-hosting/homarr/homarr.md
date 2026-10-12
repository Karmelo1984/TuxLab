---
title: "Homarr"
authors:
  - Carmelo Molero Castillo
date: 2025-03-21
version: 1.0.0
---

# Homarr

![Homarr](img/img-homarr-header-02.svg)

**Homarr** es un **dashboard personalizable** y de código abierto diseñado para administrar y acceder fácilmente a aplicaciones autoalojadas. Se usa principalmente en servidores personales o domésticos para tener un **panel centralizado** donde gestionar aplicaciones como Jellyfin, Sonarr, Radarr, Home Assistant, etc.  

### 🔥 **Características principales de Homarr**  
✅ **Interfaz limpia y moderna** con diseño personalizable.  
✅ **Widgets dinámicos** (para clima, noticias, consumo de CPU/RAM, etc.).  
✅ **Integración con múltiples aplicaciones** (Jellyfin, Plex, Sonarr, Radarr, etc.).  
✅ **Soporte para Docker y despliegue fácil**.  
✅ **Modo oscuro y responsivo**.  
✅ **Edición en vivo** sin necesidad de modificar archivos manualmente.  
### 🔧 **¿Para qué sirve?**  
📌 **Acceder rápidamente** a todas tus aplicaciones autoalojadas desde un solo panel.  
📌 **Monitorizar el estado de tus servicios** (RAM, CPU, espacio en disco, etc.).  
📌 **Centralizar enlaces e información útil** (como IPs, URLs de acceso, etc.).  
📌 **Automatizar tareas** gracias a su integración con Home Assistant.  

🔹 **Página oficial**: [https://homarr.dev/](https://homarr.dev/)

---

## Instalación

Todos los ficheros relacionados con nuestra instalación de **Homarr** se alojarán dentro de un directorio ubicado en `~/docker`, a fin de tener organizado nuestro sistema de ficheros.

### Paso 1: Crear la estructura de directorios

Para comenzar, crea la estructura de directorios necesaria en tu sistema:

```bash
mkdir -p ~/docker/homarr/volume/{config,data,icons}
```

### Paso 2: Crear el archivo `docker-compose.yml`

Luego, crea y edita el archivo `docker-compose.yml` en el directorio correspondiente:

```bash
vim ~/docker/homarr/docker-compose.yml
```

### Paso 3: Estructura de directorios esperada

Antes de iniciar el contenedor, la estructura del sistema de ficheros debería quedar organizada de la siguiente manera:

```bash
tree ~

~/docker/homarr
├── docker-compose.yml
└── volume
    ├── config
    ├── data
    └── icons
```

---

## Despliegue de `docker-compose.yml`

Para desplegar el contenedor de **Homarr**, puedes hacerlo tanto desde **Portainer** como desde la línea de comandos usando Docker Compose. Si optas por la segunda opción, ejecuta el siguiente comando para levantar el contenedor:

```bash
$ docker-compose up -d

# Puedes 'bajar' el contenedor mediante
$ docker-compose down

# Puedes ver la salida de log usando
$ docker logs -f <ID_CONTENEDOR>
```

### Contenido del archivo `docker-compose.yml`

Este es el contenido del archivo `docker-compose.yml` que necesitas para configurar tu contenedor de **Homarr**:

```yaml
services:

  # ================== Homarr
  homarr:
    image: ghcr.io/ajnart/homarr:latest
    container_name: homarr
    restart: unless-stopped

    ports:
      - '8002:7575'

    volumes:
      - /var/run/docker.sock:/var/run/docker.sock # Optional, only if you want docker integration
      - config:/app/data/configs
      - data:/data
      - icons:/app/public/icons

volumes:
  config:
    driver_opts:
      type: none
      device: ~/docker/homarr/volume/config
      o: bind
  data:
    driver_opts:
      type: none
      device: ~/docker/homarr/volume/data
      o: bind
  icons:
    driver_opts:
      type: none
      device: ~/docker/homarr/volume/icons
      o: bind
```

---

## Acceso

Una vez que el contenedor esté desplegado y funcionando, podrás acceder a la interfaz web de **Homarr** a través de tu navegador. Simplemente ingresa la siguiente URL en la barra de direcciones:

```
http://ip-server:7575
```

Sustituye `ip-server` por la IP de tu dispositivo.

---

## Configuración

Revisa el siguiente [https://homarr.dev/docs/getting-started/after-the-installation](https://homarr.dev/docs/getting-started/after-the-installation) para la configuración inicial.