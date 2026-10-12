---
title: "Plex"
authors:
  - Carmelo Molero Castillo
date: 2025-03-21
version: 1.0.0
---

# Plex

![Plex](img/img-plex-header-02.svg)

**Plex** es un **servidor multimedia** que te permite organizar, transmitir y reproducir tu contenido (películas, series, música, fotos, etc.) en diferentes dispositivos, tanto dentro de tu red local como de forma remota.  

---

### 🎬 **¿Qué hace Plex?**  
✅ **Organiza tu biblioteca multimedia** automáticamente con metadatos (portadas, sinopsis, subtítulos).  
✅ **Transmite contenido en cualquier dispositivo** (TVs, móviles, PC, consolas, Chromecast, etc.).  
✅ **Accede a tu contenido desde cualquier lugar** con una cuenta de Plex y conexión a Internet.  
✅ **Comparte tu biblioteca con amigos y familiares**.  
✅ **Plex Pass (opcional)** desbloquea funciones premium como descargas offline y transcodificación mejorada.  
✅ **Incluye Plex Free TV & Movies**, una selección gratuita con publicidad.  

### 📡 **Dispositivos compatibles**  
🖥 **PC/Mac** (navegador o app).  
📱 **Android & iOS**.  
📺 **Smart TVs (Samsung, LG, Android TV, Roku, Fire TV, Apple TV, Chromecast, Nvidia Shield)**.  
🎮 **Consolas (PS5, Xbox Series X/S, etc.)**.

🔹 **Página oficial**:  [https://www.plex.tv](https://www.plex.tv)

---

## Instalación

Todos los ficheros relacionados con nuestra instalación de **Plex** se alojarán dentro de un directorio ubicado en `~/docker`, a fin de tener organizado nuestro sistema de ficheros.

### Paso 1: Crear la estructura de directorios

Para comenzar, crea la estructura de directorios necesaria en tu sistema:

```bash
mkdir -p ~/docker/plex/volume/config
$ sudo mkdir -p /mnt/server
$ sudo chown $(whoami):$(whoami) /mnt/server 
```

### Paso 2: Crear el archivo `docker-compose.yml`

Luego, crea y edita el archivo `docker-compose.yml` en el directorio correspondiente:

```bash
vim ~/docker/plex/docker-compose.yml
```

### Paso 3: Estructura de directorios esperada

Antes de iniciar el contenedor, la estructura del sistema de ficheros debería quedar organizada de la siguiente manera:

```bash
$ tree ~

~/docker/plex
├── docker-compose.yml
└── volume
    └── config

/
├── ...
├── mnt
│   └── server
└── ...
```

---

## Despliegue de `docker-compose.yml`

Para desplegar el contenedor de **Plex**, puedes hacerlo tanto desde **Portainer** como desde la línea de comandos usando Docker Compose. Si optas por la segunda opción, ejecuta el siguiente comando para levantar el contenedor:

```bash
$ docker-compose up -d

# Puedes 'bajar' el contenedor mediante
$ docker-compose down

# Puedes ver la salida de log usando
$ docker logs -f <ID_CONTENEDOR>
```

### Contenido del archivo `docker-compose.yml`

Este es el contenido del archivo `docker-compose.yml` que necesitas para configurar tu contenedor de **Plex**:

Antes de continuar, debes visitar [https://www.plex.tv/claim/](https://www.plex.tv/claim/) y obtener un `Claim Code`.

```yaml
services:

  #================== Plex
  plex:
    image: greensheep/plex-server-docker-rpi:latest
    container_name: plex              # Nombre del contenedor
    restart: unless-stopped           # Política de reinicio del contenedor
      
    volumes:
      - config:/config
      - data:/data

    ports:
      - "32400:32400"

# Definición de volúmenes
volumes:
  config: 
    driver_opts:
      type: none
      device: ~/docker/plex/volume/config
      o: bind

  data:
    driver_opts:
      type: none
      device: /mnt/server 
      o: bind
```

---

## Acceso

Una vez que el contenedor esté desplegado y funcionando, podrás acceder a la interfaz web de **Plex** a través de tu navegador. Simplemente ingresa la siguiente URL en la barra de direcciones:

```
http://ip-server:32400/web
```

Sustituye `ip-server` por la IP de tu dispositivo.