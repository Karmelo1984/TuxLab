---
authors:
  - Carmelo Molero Castillo
date: 2025-03-19
---

# Gestión de imágenes en Docker

![Imágenes Docker](img/img-docker-header-imagenes-02.svg)

Las imágenes en Docker son plantillas inmutables utilizadas para crear contenedores. Se pueden construir, etiquetar y compartir con facilidad. Las imágenes son esenciales en el proceso de creación y distribución de aplicaciones basadas en contenedores, permitiendo que el entorno de ejecución se mantenga consistente en diferentes sistemas.

Las imágenes en Docker son la base para crear contenedores y permiten que las aplicaciones sean fácilmente transportables y reproducibles en diferentes entornos. Aprender a construir, almacenar y compartir imágenes es crucial para optimizar el uso de Docker en proyectos de desarrollo y despliegue. Almacenarlas en Docker Hub o en registros privados facilita el trabajo colaborativo y el despliegue eficiente en entornos de producción.


## ¿Qué es una imagen de Docker?

Una **imagen de Docker** es una capa de un sistema de archivos y un conjunto de instrucciones necesarias para ejecutar un contenedor. Las imágenes son inmutables y contienen todo lo necesario para ejecutar una aplicación: desde el sistema operativo base hasta las dependencias y la configuración de la aplicación.

## Construcción de una imagen

Para construir una imagen de Docker, necesitas crear un archivo llamado `Dockerfile`, que contiene instrucciones sobre cómo construir la imagen. Aquí tienes un ejemplo básico de un **Dockerfile** para crear una imagen que ejecute una aplicación web simple con **nginx**:

### Ejemplo de Dockerfile:
```dockerfile
# Usar una imagen base oficial de nginx
FROM nginx:latest

# Copiar los archivos de configuración al contenedor
COPY ./html /usr/share/nginx/html

# Exponer el puerto 80
EXPOSE 80

# Comando que ejecuta nginx
CMD ["nginx", "-g", "daemon off;"]
```

Una vez que tienes el `Dockerfile` listo, puedes construir la imagen ejecutando el siguiente comando:

```bash
docker build -t nombre_imagen:etiqueta .
```

Donde:

- `nombre_imagen` es el nombre que le darás a la imagen.
- `etiqueta` es una versión o identificador para la imagen (por ejemplo, `v1`, `latest`, etc.).
- `.` es el contexto del directorio donde se encuentra el `Dockerfile`.

### Listar imágenes

Una vez que la imagen ha sido creada, puedes listar todas las imágenes disponibles localmente con el siguiente comando:

```bash
docker images
```

Este comando te mostrará una lista de imágenes almacenadas en tu sistema local, junto con detalles como el nombre, la etiqueta, el ID de la imagen, el tamaño y la fecha de creación.

### Eliminar imágenes sin uso

Para eliminar imágenes que ya no se están utilizando, puedes ejecutar el siguiente comando:

```bash
docker rmi nombre_imagen
```

Este comando eliminará la imagen especificada. Si la imagen está siendo utilizada por un contenedor, primero tendrás que detener y eliminar el contenedor asociado antes de poder eliminar la imagen.

---

## Almacenamiento de imágenes

Las imágenes de Docker se pueden almacenar de dos maneras principales: localmente en tu máquina y de forma remota en un registro de imágenes, como **Docker Hub**.

### Almacenamiento local

Cuando construyes una imagen, Docker la guarda localmente en tu máquina. Para ver las imágenes almacenadas en tu sistema, puedes usar el comando `docker images`, como se mencionó anteriormente. 

Las imágenes locales se almacenan en una caché y ocupan espacio en el disco de tu máquina. Si deseas eliminar una imagen para liberar espacio, puedes usar el comando `docker rmi`.

### Almacenamiento en Docker Hub

**Docker Hub** es un servicio de registro de imágenes Docker que te permite compartir y almacenar imágenes de manera pública o privada. Puedes **subir** tus imágenes a Docker Hub para que estén disponibles en cualquier lugar, o **descargar** imágenes de otros usuarios para utilizarlas en tus proyectos.

#### 1. **Subir una imagen a Docker Hub**

Para subir una imagen a Docker Hub, sigue estos pasos:

1. **Inicia sesión en Docker Hub**:
   Primero, asegúrate de estar autenticado en Docker Hub desde la línea de comandos:

   ```bash
   docker login
   ```
   Este comando te pedirá tu nombre de usuario y contraseña de Docker Hub.

2. **Etiquetar la imagen**:
   Antes de subir la imagen, es necesario etiquetarla con el nombre de tu repositorio de Docker Hub:

   ```bash
   docker tag nombre_imagen:etiqueta tu_usuario/nombre_imagen:etiqueta
   ```

   Ejemplo:
   ```bash
   docker tag mi_imagen:v1 carmelomolero/mi_imagen:v1
   ```

   Este comando etiquetará la imagen con el nombre `tu_usuario/nombre_imagen:etiqueta`, lo cual es necesario para subirla a Docker Hub.

3. **Subir la imagen**:
   Luego, puedes subir la imagen utilizando el siguiente comando:

   ```bash
   docker push tu_usuario/nombre_imagen:etiqueta
   ```

   Ejemplo:
   ```bash
   docker push carmelomolero/mi_imagen:v1
   ```

   Docker comenzará a subir la imagen a Docker Hub. Una vez completado el proceso, podrás acceder a ella desde cualquier lugar y descargarla utilizando el nombre y la etiqueta asignados.

#### 2. **Descargar una imagen de Docker Hub**

Para descargar una imagen desde Docker Hub, utiliza el siguiente comando:

```bash
docker pull nombre_imagen:etiqueta
```

Por ejemplo, para descargar la imagen oficial de `nginx`, puedes ejecutar:

```bash
docker pull nginx:latest
```

Este comando descarga la imagen desde Docker Hub y la almacena localmente en tu máquina.

---

## Ejemplo de Flujo Completo: Crear, Almacenar y Compartir una Imagen

Aquí tienes un flujo completo de cómo crear, almacenar y compartir una imagen en Docker:

1. **Crea un Dockerfile** para una aplicación simple.
2. **Construye la imagen**:
   ```bash
   docker build -t mi_imagen:v1 .
   ```
3. **Inicia sesión en Docker Hub**:
   ```bash
   docker login
   ```
4. **Etiqueta la imagen**:
   ```bash
   docker tag mi_imagen:v1 carmelomolero/mi_imagen:v1
   ```
5. **Sube la imagen a Docker Hub**:
   ```bash
   docker push carmelomolero/mi_imagen:v1
   ```
6. Ahora, la imagen está disponible en Docker Hub y puede ser descargada por otros usuarios con el comando `docker pull`.
