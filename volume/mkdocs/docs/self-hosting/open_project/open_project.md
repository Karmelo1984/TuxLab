---
title: "OpenProject"
authors:
  - Carmelo Molero Castillo
date: 2025-05-24
version: 1.0.0
---

# OpenProject

![OpenProject](./img/img-open_project-header-01.jpg)

**OpenProject** es una plataforma de gestión de proyectos de código abierto que permite a los usuarios planificar, coordinar, realizar seguimiento y colaborar en proyectos complejos.

A diferencia de herramientas propietarias como Jira o Asana, **OpenProject** es completamente libre, puede desplegarse localmente y ofrece control total sobre los datos y la configuración del sistema. Ofrece una interfaz amigable, colaborativa y basada en la web.

**OpenProject** está basado en Ruby on Rails y ha sido adaptado para funcionar en múltiples entornos mediante contenedores Docker. No requiere licencias comerciales y es mantenido activamente por la comunidad y OpenProject GmbH.

🔹 **Página oficial**: [https://www.openproject.org/es/](https://www.openproject.org/es/)

---

## Instalación

Todos los ficheros relacionados con nuestra instalación de **OpenProject** se alojarán dentro de un directorio ubicado en `~/docker/openproject`.

### Paso 1: Crear la estructura de directorios

```bash
$ mkdir -p ~/docker/open_project/volume/{pgdata,openproject}
```

### Paso 2: Crear el archivo `docker-compose.yml`

```bash
$ vim ~/docker/open_project/docker-compose.yml
```

### Paso 3: Estructura de directorios esperada

```bash
$ tree ~

~/docker/open_project
├── docker-compose.yml
└── volume
    ├── openproject
    └── pgdata
```

---

## Despliegue de `docker-compose.yml`

```bash
$ docker-compose up -d
$ docker-compose down
$ docker logs -f openproject
```

### Contenido del archivo `docker-compose.yml`

```yaml
services:
  openproject:
    image: openproject/openproject:16
    container_name: openproject
    restart: unless-stopped
    ports:
      - "8080:80"
    environment:
      - SECRET_KEY_BASE=randomsecretkey
      - DATABASE_URL=postgres://postgres:password@db/openproject
      - OPENPROJECT_HTTPS=false
      - OPENPROJECT_HSTS=false
      - OPENPROJECT_DEFAULT__LANGUAGE=es
    volumes:
      - opdata:/var/openproject/assets

  db:
    image: postgres:13
    container_name: openproject_db
    restart: unless-stopped
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: password
      POSTGRES_DB: openproject
    volumes:
      - pgdata:/var/lib/postgresql/data

volumes:
  opdata:
    driver: local
    driver_opts:
      type: none
      device: ~/docker/open_project/volume/openproject
      o: bind
  pgdata:
    driver: local
    driver_opts:
      type: none
      device: ~/docker/open_project/volume/pgdata
      o: bind
```

---

## Acceso

Accede desde tu navegador a:

```
http://ip-servidor:8080
```

Sustituye `ip-servidor` por la IP de tu máquina anfitriona.

---

## Personalización

### Cambiar apariencia

#### Opción 1: Importando CSS

Actualmente OpenProject no soporta directamente estilos personalizados mediante CSS externo. Sin embargo, se pueden modificar los colores y logotipos desde la administración.

#### Opción 2: Usando plugin **Enterprise Branding**

Esta funcionalidad está limitada a la versión Enterprise. Puedes revisar más información aquí:
[https://docs.openproject.org/de/system-admin-guide/custom-logo-color-theme/](https://docs.openproject.org/de/system-admin-guide/custom-logo-color-theme/)

---

## Configuración de la biblioteca

```bash
~/docker/open_project/volume/
├── openproject
│   ├── attachments
│   ├── avatars
│   └── logs
└── pgdata
    ├── base
    ├── global
    └── pg_wal
```

