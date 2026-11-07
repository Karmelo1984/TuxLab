# TuxLab

Documentación técnica personal sobre **Self-Hosting**, **Docker**, **Linux** y **Raspberry Pi**, construida con [MkDocs Material](https://squidfunnel.github.io/mkdocs-material/).

## Contenido

Todo el contenido vive en `volume/mkdocs/docs/`:

| Sección         | Contenido                                                  |
|-----------------|------------------------------------------------------------|
| `self-hosting/` | Jellyfin, Nextcloud, Pi-hole, Portainer, Plex, Samba, etc. |
| `docker/`       | Contenedores, imágenes, volúmenes, redes, troubleshooting  |
| `linux/`        | Redes (SSH, DHCP, DDNS), sistemas de archivos, scripts     |
| `raspberrypi/`  | Instalación, utilidades, cámara, servidor NAS              |
| `dev/`          | Git y desarrollo                                           |
| `proyectos/`    | Proyectos propios                                          |

## Ejecutar en local

Requiere Docker.

```bash
docker compose up -d
```

El sitio queda en <http://localhost:8000> con recarga automática. La configuración está en `volume/mkdocs/mkdocs.yml`.

## Publicación

El workflow `.github/workflows/pages.yml` publica el sitio en GitHub Pages en cada push a `main` (o manualmente con `workflow_dispatch`).

## Plantillas

Para añadir páginas nuevas, parte de estas plantillas de la raíz:

- `example-self-hosting.md`: aplicación autoalojada.
- `example.generico.md`: página genérica.
- `example.script.md`: script.

## Autor

Carmelo Molero Castillo
