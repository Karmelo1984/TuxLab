---
title: "Media Stack + Monitoring + Portainer"
authors:
  - Tu Nombre
date: 2025-08-06
version: 1.0.0
---

# Media Stack + Monitoring + Portainer

![Media Stack](./img/media-stack-header.png)

**Media Stack + Monitoring + Portainer** es una plataforma **autohospedada** que permite a los usuarios descargar, organizar, visualizar y administrar contenido multimedia, todo desde una misma infraestructura Docker.

A diferencia de soluciones separadas o dependientes de servicios en la nube, esta configuración reúne en un solo lugar:
- Clientes de descarga torrent
- Organizadores automáticos de contenido
- Servidor de streaming local
- Monitorización del sistema
- Administración centralizada

Está basado en **Docker Swarm** y adaptado para despliegues locales o en servidores NAS o VPS. Es ideal para entusiastas del autoservicio multimedia.

---

## Instalación

Todos los ficheros relacionados con nuestra instalación de **Centro multimedia** se alojarán dentro de un directorio ubicado en `~/docker`, a fin de tener organizado nuestro sistema de ficheros.


### Paso 1: Crear la estructura de directorios

```bash
mkdir -p ~/media-stack/{transmission/config,bazarr/config,homarr/config,prowlarr/config,radarr/config,sonarr/config,jellyfin/config,grafana/data,prometheus/data,portainer/data}

mkdir -p /mnt/media/{downloads,movies,tv}
cd ~/media-stack
```

### Paso 2: Crear archivo `docker-compose.yml`

Luego, crea y edita el archivo `docker-compose.yml` en el directorio correspondiente:

```bash
vim ~/docker/media-stack/docker-compose.yml
```

### Paso 3: Estructura de directorios esperada

```bash
$ tree ~/media-stack

~/media-stack
├── docker-compose.yml
└── volume
    ├── transmission
    │   └── config
    ├── bazarr
    │   └── config
    ├── homarr
    │   └── config
    ├── prowlarr
    │   └── config
    ├── radarr
    │   └── config
    ├── sonarr
    │   └── config
    ├── jellyfin
    │   └── config
    ├── grafana
    │   └── data
    ├── prometheus
    │   └── data
    └── portainer
        └── data
```

---

## Despliegue de `docker-compose.yml`

Para desplegar todos los contenedores de **Centro multimedia**, puedes hacerlo tanto desde **Portainer** como desde la línea de comandos usando Docker Compose. Si optas por la segunda opción, ejecuta el siguiente comando para levantar el contenedor:


```bash
$ docker-compose up -d

# Puedes 'bajar' el contenedor mediante
$ docker-compose down
```

---

## Acceso a servicios

| Servicio     | Puerto | URL de acceso                                  |
| ------------ | ------ | ---------------------------------------------- |
| Grafana      | 3000   | [http://localhost:3000](http://localhost:3000) |
| Bazarr       | 6767   | [http://localhost:6767](http://localhost:6767) |
| Homarr       | 7575   | [http://localhost:7575](http://localhost:7575) |
| Radarr       | 7878   | [http://localhost:7878](http://localhost:7878) |
| Jellyfin     | 8096   | [http://localhost:8096](http://localhost:8096) |
| Sonarr       | 8989   | [http://localhost:8989](http://localhost:8989) |
| Portainer    | 9000   | [http://localhost:9000](http://localhost:9000) |
| Transmission | 9091   | [http://localhost:9091](http://localhost:9091) |
| Prowlarr     | 9696   | [http://localhost:9696](http://localhost:9696) |

---

## Servicios incluidos

### 🎞️ Transmission

* Cliente BitTorrent para descargar archivos `.torrent` y `magnet`.
* Esencial para obtener contenido que luego será gestionado y visualizado.

### 🎬 Radarr

* Automatiza la búsqueda y organización de películas.
* Descarga según calidad y renombra archivos.

### 📺 Sonarr

* Lo mismo que Radarr, pero para series de televisión.
* Controla episodios, temporadas y calidad.

### 🈂️ Bazarr

* Añade subtítulos automáticamente para tus series y películas.
* Compatible con múltiples idiomas.

### 🔍 Prowlarr

* Conecta Radarr/Sonarr con múltiples indexadores de torrents o usenet.
* Centraliza y optimiza las búsquedas.

### 🧩 Homarr

* Dashboard personalizable para acceder a todos los servicios desde un solo lugar.

### 🎥 Jellyfin

* Servidor de streaming local. Tu propio "Netflix casero".
* Compatible con múltiples dispositivos (TV, móvil, navegador).

### 📊 Grafana

* Dashboard para visualizar el uso de CPU, memoria, red, etc.

### 📈 Prometheus

* Recolector de métricas para alimentar a Grafana.

### 🖥 Node Exporter

* Proporciona métricas del sistema operativo.

### 📦 cAdvisor

* Monitoriza en tiempo real los recursos consumidos por cada contenedor.

### ⚙️ Portainer

* Interfaz gráfica para gestionar tus contenedores, redes, stacks y más.
* Ideal para administración sin terminal.

---

### Contenido del archivo `docker-compose.yml`

Este es el contenido del archivo `docker-compose.yml` que necesitas para configurar tu contenedor de **Centro multimedia**:

```yaml
version: "3.8"

services:
  transmission:
    container_name: cmp_transmission
    image: lscr.io/linuxserver/transmission:latest
    ports:
      - "9091:9091"
      - "51413:51413"
      - "51413:51413/udp"
    volumes:
      - transmission_config:/config
      - downloads:/downloads
    deploy:
      mode: replicated
      replicas: 1
    networks:
      - media

  bazarr:
    container_name: cmp_bazarr
    image: lscr.io/linuxserver/bazarr:latest
    ports:
      - "6767:6767"
    volumes:
      - bazarr_config:/config
      - media:/media
    deploy:
      mode: replicated
      replicas: 1
    networks:
      - media

  homarr:
    container_name: cmp_homarr
    image: ghcr.io/homarr-labs/homarr:latest
    ports:
      - "7575:7575"
    volumes:
      - homarr_config:/app/data/configs
    deploy:
      mode: replicated
      replicas: 1
    networks:
      - media

  prowlarr:
    container_name: cmp_prowlarr
    image: lscr.io/linuxserver/prowlarr:latest
    ports:
      - "9696:9696"
    volumes:
      - prowlarr_config:/config
    deploy:
      mode: replicated
      replicas: 1
    networks:
      - media

  radarr:
    container_name: cmp_radarr
    image: lscr.io/linuxserver/radarr:latest
    ports:
      - "7878:7878"
    volumes:
      - radarr_config:/config
      - movies:/movies
      - downloads:/downloads
    deploy:
      mode: replicated
      replicas: 1
    networks:
      - media

  sonarr:
    container_name: cmp_sonarr
    image: lscr.io/linuxserver/sonarr:latest
    ports:
      - "8989:8989"
    volumes:
      - sonarr_config:/config
      - tv:/tv
      - downloads:/downloads
    deploy:
      mode: replicated
      replicas: 1
    networks:
      - media

  jellyfin:
    container_name: cmp_jellyfin
    image: jellyfin/jellyfin:latest
    ports:
      - "8096:8096"
    volumes:
      - jellyfin_config:/config
      - media:/media
    deploy:
      mode: replicated
      replicas: 1
    networks:
      - media

  cadvisor:
    container_name: cmp_cadvisor
    image: gcr.io/cadvisor/cadvisor:v0.47.0
    volumes:
      - /:/rootfs:ro
      - /var/run:/var/run:ro
      - /sys:/sys:ro
      - /var/lib/docker/:/var/lib/docker:ro
    deploy:
      mode: global
    networks:
      - monitor

  grafana:
    container_name: cmp_grafana
    image: portainer/template-swarm-monitoring:grafana-9.5.2
    ports:
      - "3000:3000"
    volumes:
      - grafana_data:/var/lib/grafana
    deploy:
      mode: replicated
      replicas: 1
    networks:
      - monitor

  node_exporter:
    container_name: cmp_node_exporter
    image: prom/node-exporter:v1.5.0
    volumes:
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
      - /:/rootfs:ro
    deploy:
      mode: global
    networks:
      - monitor

  prometheus:
    container_name: cmp_prometheus
    image: portainer/template-swarm-monitoring:prometheus-v2.44.0
    volumes:
      - prometheus_data:/prometheus
    deploy:
      mode: replicated
      replicas: 1
    networks:
      - monitor

  portainer_agent:
    container_name: cmp_portainer_agent
    image: portainer/agent:2.16.2
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - /var/lib/docker/volumes:/var/lib/docker/volumes
    deploy:
      mode: global
    networks:
      - portainer

  portainer:
    container_name: cmp_portainer
    image: portainer/portainer-ce:latest
    ports:
      - "8000:8000"
      - "9000:9000"
      - "9443:9443"
    volumes:
      - portainer_data:/data
    deploy:
      mode: replicated
      replicas: 1
    networks:
      - portainer

networks:
  media:
  monitor:
  portainer:

volumes:
  transmission_config:
    driver_opts:
      type: none
      device: ~/docker/transmission/config
      o: bind

  bazarr_config:
    driver_opts:
      type: none
      device: ~/docker/bazarr/config
      o: bind

  homarr_config:
    driver_opts:
      type: none
      device: ~/docker/homarr/config
      o: bind

  prowlarr_config:
    driver_opts:
      type: none
      device: ~/docker/prowlarr/config
      o: bind

  radarr_config:
    driver_opts:
      type: none
      device: ~/docker/radarr/config
      o: bind

  sonarr_config:
    driver_opts:
      type: none
      device: ~/docker/sonarr/config
      o: bind

  jellyfin_config:
    driver_opts:
      type: none
      device: ~/docker/jellyfin/config
      o: bind

  grafana_data:
    driver_opts:
      type: none
      device: ~/docker/grafana/data
      o: bind

  prometheus_data:
    driver_opts:
      type: none
      device: ~/docker/prometheus/data
      o: bind

  portainer_data:
    driver_opts:
      type: none
      device: ~/docker/portainer/data
      o: bind

  downloads:
    driver_opts:
      type: none
      device: /mnt/media/downloads
      o: bind

  media:
    driver_opts:
      type: none
      device: /mnt/media
      o: bind

  movies:
    driver_opts:
      type: none
      device: /mnt/media/movies
      o: bind

  tv:
    driver_opts:
      type: none
      device: /mnt/media/tv
      o: bind
```

---
