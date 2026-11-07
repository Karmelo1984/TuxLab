# TuxLab

**TuxLab** es un repositorio de documentación técnica personal sobre **self-hosting, Docker, Linux, Raspberry Pi, desarrollo de software e IA**. Reúne procedimientos, configuraciones, scripts y notas de proyectos para poder consultarlos y mantenerlos en un único lugar.

- **Sitio web:** <https://karmelo1984.github.io/TuxLab/>
- **Código fuente:** <https://github.com/Karmelo1984/TuxLab>

## Contenido

La documentación se organiza por áreas temáticas:

| Sección         | Contenido                                                                          |
|-----------------|------------------------------------------------------------------------------------|
| `self-hosting/` | Servicios autoalojados como Jellyfin, Nextcloud, Pi-hole, Portainer, Plex o Samba. |
| `docker/`       | Contenedores, imágenes, redes, volúmenes y solución de problemas.                  |
| `linux/`        | Administración, redes, sistemas de archivos y scripts.                             |
| `raspberrypi/`  | Instalación, configuración, cámara, utilidades y NAS.                              |
| `dev/`          | Git y herramientas de desarrollo.                                                  |
| `proyectos/`    | Proyectos y experimentos propios.                                                  |
| `ia/`           | Fundamentos de IA, ChatGPT y Claude Code.                                          |

Los artículos, recursos e imágenes están en [`mkdocs/docs/`](mkdocs/docs/). La navegación del sitio se ordena con los archivos `.pages` de cada sección.

## Plataforma

El sitio está generado con [MkDocs](https://www.mkdocs.org/) y [Material for MkDocs](https://squidfunk.github.io/mkdocs-material/). Utiliza, entre otras herramientas:

- **Awesome Pages:** organización de la navegación por secciones.
- **Mermaid:** diagramas incluidos en las páginas Markdown.
- **PyMdown Extensions:** bloques avanzados, pestañas, resaltado e iconos SVG.
- **Git Revision Date Localized:** fechas de creación y modificación basadas en Git durante las compilaciones de publicación.

La web publicada es **HTML estático**. No requiere un servidor Python en producción.

## Entornos y publicación

| Rama   | Propósito                         | Publicación                                                     |
|--------|-----------------------------------|-----------------------------------------------------------------|
| `dev`  | Edición, desarrollo y validación. | No publica automáticamente en GitHub Pages.                     |
| `main` | Versión estable del contenido.    | Publicación automática en GitHub Pages mediante GitHub Actions. |

La **producción actual** se encuentra en GitHub Pages. Docker se utiliza para previsualizar el proyecto en local; existe también una opción de producción autoalojada que genera el sitio y lo sirve con Caddy. Esta última **no sustituye** el despliegue actual mientras no se decida migrar.

## Colaboración y mantenimiento

La guía [**CONTRIBUTING.md**](CONTRIBUTING.md) contiene los procedimientos técnicos:

- Preparar el entorno local con Docker.
- Crear artículos, imágenes, diagramas y entradas de navegación.
- Ejecutar validaciones, linters y pruebas de compilación.
- Trabajar con las ramas `dev` y `main`.
- Publicar con GitHub Pages o desplegar en un servidor propio.
- Aplicar las medidas de seguridad y resolver problemas habituales.

## Autor

Carmelo Molero Castillo.
