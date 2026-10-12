---
authors:
  - Carmelo Molero Castillo
date: 2025-03-19
---

# Introducción a Docker

![Docker](img/img-docker-header-02.svg)

Docker es una plataforma de código abierto que facilita la creación, despliegue y gestión de aplicaciones mediante contenedores, los cuales empaquetan la aplicación junto con sus dependencias para asegurar su ejecución uniforme en cualquier entorno. Además, Docker resuelve problemas de compatibilidad de sistemas operativos al proporcionar entornos virtualizados ligeros para administrar estas aplicaciones.

La interfaz de línea de comandos (CLI) de Docker ofrece a los desarrolladores potentes herramientas para trabajar con contenedores, incluyendo alrededor de 60 subcomandos que abordan una variedad de tareas a través de argumentos de línea de comandos. Esto permite a los desarrolladores gestionar eficientemente el ciclo de vida de sus aplicaciones y entornos de desarrollo.

---

## **Esquema Conceptual de Docker**
```
                       +------------------------+
                       |      Docker CLI        |
                       |  (Interfaz de Línea)   |
                       +----------+------------+
                                  |
                                  v
                       +------------------------+
                       |      Docker Engine     |  << Núcleo de Docker >>
                       |  (Daemon + API REST)   |
                       +----------+------------+
                                  |
        ----------------------------------------------------------
        |                    |                   |               |
        v                    v                   v               v
+---------------+   +----------------+   +---------------+   +--------------+
|   Imágenes    |   |  Contenedores  |   |  Volúmenes    |   |    Redes     |
|   (Images)    |   |  (Containers)  |   |  (Volumes)    |   |  (Networks)  |
+---------------+   +----------------+   +---------------+   +--------------+
        |                    |                   |               |
        v                    v                   v               v
+---------------+   +----------------+   +---------------+   +--------------+
|   Docker Hub  |   |   Dockerfile   |   |  Bind Mounts  |   |  Bridge/NAT  |
|   (Registro)  |   |  (Build Rules) |   |  Named Volumes|   |  Overlay     |
+---------------+   +----------------+   +---------------+   +--------------+
```

---

### **Explicación de los Componentes**
#### **1️⃣ Docker CLI (Interfaz de Línea de Comandos)**
   - Permite interactuar con Docker desde la terminal mediante comandos como `docker run`, `docker build`, `docker ps`, etc.

#### **2️⃣ Docker Engine (Motor de Docker)**
   - Es el núcleo de Docker, compuesto por:
     - **Daemon (`dockerd`)**: Gestiona la creación y ejecución de contenedores.
     - **API REST**: Permite a herramientas externas comunicarse con Docker.

#### **3️⃣ Imágenes (`Images`)**
   - Son plantillas inmutables que contienen el sistema operativo y las aplicaciones necesarias.
   - Se almacenan en **Docker Hub** u otros registros privados.
   - Se crean a partir de un **Dockerfile** (archivo de instrucciones para construir imágenes).

#### **4️⃣ Contenedores (`Containers`)**
   - Son instancias en ejecución de una imagen.
   - Se administran con comandos como `docker run`, `docker stop`, `docker rm`.

#### **5️⃣ Volúmenes (`Volumes`)**
   - Permiten persistir datos de contenedores.
   - Tipos:
     - **Named Volumes**: Gestionados por Docker.
     - **Bind Mounts**: Montajes directos del host.

#### **6️⃣ Redes (`Networks`)**
   - Permiten la comunicación entre contenedores y el exterior.
   - Tipos:
     - **Bridge** (Red local entre contenedores).
     - **Overlay** (Para clústeres de Docker Swarm).
     - **Host** (Usa la red del sistema anfitrión).
