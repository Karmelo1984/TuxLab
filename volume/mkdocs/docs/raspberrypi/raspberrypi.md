---
title: "Raspberry Pi"
authors:
  - Carmelo Molero Castillo
date: 2026-10-12
version: 1.2.0
---

# Raspberry Pi

![Raspberry Pi](img/img-raspberrypi-header-02.svg)

## Introducción
Raspberry Pi es una serie de computadoras de placa única (SBC) desarrolladas por la Raspberry Pi Foundation en el Reino Unido. Su bajo costo, consumo eficiente de energía y tamaño compacto las hacen ideales para una amplia gama de proyectos de electrónica y programación.

## Características Principales

- **Tamaño Pequeño:** Su tamaño similar al de una tarjeta de crédito la hace extremadamente compacta.
- **Bajo Costo:** Diseñada para fomentar la educación en informática a bajo costo.
- **Puertos y Conectividad:** Incluye USB, HDMI, Ethernet y GPIO, facilitando su integración en proyectos.
- **Flexibilidad:** Compatible con varios sistemas operativos como Raspbian, Ubuntu y versiones especializadas de Windows.

## Usos Comunes

- **Educación:** Utilizada ampliamente en escuelas para enseñar informática y programación.
- **Proyectos de Electrónica y Robótica:** Ideal para proyectos DIY, automatización del hogar y vigilancia.
- **Servidores y Aplicaciones Web:** Se emplea como servidor web o para alojar aplicaciones ligeras.
- **Media Center:** Con software como Kodi, se convierte en un centro multimedia.

## Configuración Personalizada de la Instalación
Para optimizar la funcionalidad, se configuraron dos equipos:

1. **Equipo 1:** Responsable de los servicios DNS y DHCP.
2. **Equipo 2:** Actúa como DNS secundario y aloja servicios adicionales como Plex y Samba.

### Equipo 1: Raspberry Pi 3 Model B Rev 1.2

#### Características del sistema
```bash
$ neofetch

  `.::///+:/-.        --///+//-:``    pi@raspberrypi 
 `+oooooooooooo:   `+oooooooooooo:    -------------- 
  /oooo++//ooooo:  ooooo+//+ooooo.    OS: Raspbian GNU/Linux 12 (bookworm) armv7l 
  `+ooooooo:-:oo-  +o+::/ooooooo:     Host: Raspberry Pi 3 Model B Rev 1.2 
   `:oooooooo+``    `.oooooooo+-      Kernel: 6.6.28+rpt-rpi-v7 
     `:++ooo/.        :+ooo+/.`       Uptime: xx hours 
        ...`  `.----.` ``..           Packages: yyy (dpkg) 
     .::::-``:::::::::.`-:::-`        Shell: bash 5.2.15 
    -:::-`   .:::::::-`  `-:::-       Terminal: /dev/pts/0 
   `::.  `.--.`  `` `.---.``.::`      CPU: BCM2835 (4) @ 1.200GHz 
       .::::::::`  -::::::::` `       Memory: 267MiB / 920MiB 
 .::` .:::::::::- `::::::::::``::.      
-:::` ::::::::::.  ::::::::::.`:::-   MicroSD: 8GB                        
::::  -::::::::.   `-::::::::  ::::                           
-::-   .-:::-.``....``.-::-.   -::-
 .. ``       .::::::::.     `..`..
   -:::-`   -::::::::::`  .:::::`
   :::::::` -::::::::::` :::::::.
   .:::::::  -::::::::. ::::::::
    `-:::::`   ..--.`   ::::::.
      `...`  `...--..`  `...`
            .::::::::::
             `.-::::-`
```

#### Respaldo y Mantenimiento
Se utiliza `pishrink` para optimizar el tamaño de la imagen de respaldo de la tarjeta MicroSD. Se puede apagar el sistema sin afectar la red gracias a la redundancia de DNS.

#### Software Instalado
- **Docker:** Permite la gestión de aplicaciones en contenedores. [`Configuración`](./utilidades/docker/docker.md).
- **PiHole:** Servidor DNS que bloquea anuncios y rastreadores. [`Configuración`](../self-hosting/pihole/pihole.md).

### Equipo 2: Raspberry Pi 4 Model B Rev 1.4

#### Características del sistema
```bash
$ neofetch

       _,met$$$$$gg.          naspicar@naspicar 
    ,g$$$$$$$$$$$$$$$P.       ----------------- 
  ,g$$P"     """Y$$.".        OS: Debian GNU/Linux 12 (bookworm) aarch64 
 ,$$P'              `$$$.     Host: Raspberry Pi 4 Model B Rev 1.4 
',$$P       ,ggs.     `$$b:   Kernel: 6.6.28+rpt-rpi-v8 
`d$$'     ,$P"'   .    $$$    Uptime: xxx mins 
 $$P      d$'     ,    $$P    Packages: yyy (dpkg) 
 $$:      $$.   -    ,d$$'    Shell: bash 5.2.15 
 $$;      Y$b._   _,d$P'      Terminal: /dev/pts/0 
 Y$$.    `.`"Y$$$$P"'         CPU: (4) @ 1.800GHz 
 `$$b      "-.__              Memory: 358MiB / 1846MiB
  `Y$$                        
   `Y$$.                      MicroSD: 32GB ó 64GB                        
     `$$b.                                            
       `Y$$b.
          `"Y$b._
              `"""
```
#### Respaldo y Mantenimiento
Al igual que el Equipo 1, se utiliza `pishrink` para generar una imagen optimizada de la MicroSD.

#### Software Instalado
- **Docker:** Permite la gestión de aplicaciones en contenedores. [`Configuración`](./utilidades/docker/docker.md).
- **Homarr:** Panel de inicio para gestionar aplicaciones web. [`Configuración`](../self-hosting/homarr/homarr.md).
- **Homebridge:** Integración con Apple HomeKit. [`Configuración`](../self-hosting/homebridge/homebridge.md).
- **PiHole:** Servidor DNS que bloquea anuncios y rastreadores. [`Configuración`](../self-hosting/pihole/pihole.md).
- **Plex:** Servidor multimedia. [`Configuración`](../self-hosting/plex/plex.md).
- **Portainer:** Gestión visual de contenedores Docker. [`Configuración`](../self-hosting/portainer/portainer.md).
- **Samba:** Compartición de archivos en red. [`Configuración`](../self-hosting/samba/samba.md).
---

## Raspberry Pi 4: laboratorio de cámara NoIR (octubre de 2026)

Se documentó otra instalación en **Raspberry Pi 4 Model B Rev. 1.4, 2 GiB, Debian 13 (Trixie) ARM64**, con cámara IMX708 Wide NoIR y administración desde Linux Mint. La documentación está dividida en guías reutilizables según su función:

| Área | Procedimiento | Estado |
|---|---|---|
| Acceso remoto | [SSH y recuperación](acceso-conectividad/ssh/acceso-recuperacion.md) | Probado |
| Red inalámbrica | [NetworkManager e IP fija](acceso-conectividad/red/wifi-ip-estatica.md) | Probado |
| Paquetes y sistema | [Mantenimiento y diagnóstico](utilidades/sistema/mantenimiento-diagnostico.md) | Probado |
| Contenedores | [Docker y Compose](utilidades/docker/docker.md) | Probado |
| HDD USB | [Añadir un HDD](utilidades/pi-hdd/pi-hdd.md) y [alimentación/USB](utilidades/pi-hdd/diagnostico-usb.md) | Pruebas cortas, pendiente de supervisión prolongada |
| Cámara | [IMX708, fotos y vídeo](camara/camara-video.md) | Probado |
| Procesado de imagen | [HDR, nocturnas y reflejos](camara/calibracion-reflejos.md) | CLAHE probado; corrección automática pendiente |
| Capturas periódicas | [Timelapse y MP4](camara/timelapse.md) | Prueba de 676 JPEG y MP4 |
| Acceso a archivos desde el NUC | [SSHFS en Linux Mint](../linux/sistemas-archivos/sshfs/sshfs.md) | Montaje manual probado, automontaje pendiente |

!!! important "Estado del disco externo"
    El HDD Toshiba de 1 TB quedó **desmontado intencionadamente** al terminar la sesión. Comprobar `findmnt /mnt/capturas` y el UUID correcto antes de grabar capturas.


## Criterio de mantenimiento de esta documentación

Los procedimientos de **SSH, red, Docker, discos y SSHFS** pertenecen a guías reutilizables, no a un proyecto de cámara aislado. Las incidencias de una instalación concreta aparecen como recuadros de compatibilidad, tablas de errores o casos prácticos en el mismo lugar donde se resuelve el problema.

- Antes de copiar una orden, comprobar distribución, versión, arquitectura y gestor de red.
- Conservar los ejemplos históricos solo si se identifican como pertenecientes a otros sistemas.
- Mantener un registro de **probado / pendiente / propuesto** para no convertir hipótesis en instrucciones obligatorias.
- Contrastar operaciones destructivas (`mkfs`, `fsck`, borrado de volúmenes Docker) con una copia de seguridad y el dispositivo correcto.
- Revisar la [tabla de incidencias y las pruebas verificadas](utilidades/sistema/mantenimiento-diagnostico.md) tras modificaciones relevantes.
