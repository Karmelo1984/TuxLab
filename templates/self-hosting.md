---
title: "{{ title }}"
description: "Descripción breve del contenido."
---

# {{ title }}

![{{ title }}](./img/{{ image_header }})

Describe qué resuelve el servicio, en qué escenarios resulta útil y qué alcance tiene el despliegue documentado. Evita texto promocional y comparaciones que no estén justificadas.

**Documentación oficial:** [NOMBRE DEL PROYECTO](URL_OFICIAL)

## Requisitos

| Elemento     | Requisito                                      |
|--------------|------------------------------------------------|
| Entorno      | SISTEMA OPERATIVO Y ARQUITECTURA COMPATIBLES   |
| Software     | DOCKER Y DOCKER COMPOSE, O DEPENDENCIAS REALES |
| Recursos     | CPU, MEMORIA Y ALMACENAMIENTO NECESARIOS       |
| Red          | PUERTOS, DNS Y CONECTIVIDAD REQUERIDOS         |
| Persistencia | DATOS QUE DEBEN CONSERVARSE                    |

<!-- Elimina las filas que no aporten información. No inventes requisitos ni cantidades. -->

## Despliegue

### Preparación

Indica la ruta de trabajo y crea únicamente los directorios necesarios para los volúmenes persistentes.

```bash
mkdir -p RUTA_DE_INSTALACION
cd RUTA_DE_INSTALACION
```

### Configuración de Docker Compose

Guarda el siguiente contenido como `docker-compose.yml`. Fija una versión de imagen identificable, documenta cada volumen y evita incluir contraseñas en el archivo.

```yaml
services:
  servicio:
    image: REPOSITORIO/IMAGEN:VERSION
    restart: unless-stopped
    # Añade solo los puertos, volúmenes, redes y variables que requiera el servicio.
```

<!-- Sustituye el Compose de ejemplo por uno completo, válido y probado para el servicio concreto. No impongas rootless ni read_only sin verificar compatibilidad. -->

### Inicio

```bash
docker compose config
docker compose up -d
docker compose ps
docker compose logs --tail=100 servicio
```

## Acceso y configuración inicial

Indica la URL de acceso, el procedimiento de primera configuración y cualquier ajuste obligatorio de autenticación o conectividad. Aclara si el acceso es local, por VPN o público.

**Dirección de acceso:** `URL_DEL_SERVICIO`

## Verificación

| Comprobación          | Resultado esperado                                |
|-----------------------|---------------------------------------------------|
| Estado del contenedor | EN EJECUCIÓN, SIN REINICIOS INESPERADOS           |
| Servicio HTTP O TCP   | RESPUESTA CORRECTA DEL ENDPOINT O PUERTO          |
| Persistencia          | LOS DATOS SE CONSERVAN TRAS RECREAR EL CONTENEDOR |
| Función principal     | OPERACIÓN REALIZADA CORRECTAMENTE                 |

<!-- Ajusta las pruebas al servicio. No presentes como realizadas comprobaciones que todavía no hayas ejecutado. -->

## Operación y mantenimiento

### Comandos habituales

```bash
docker compose logs -f servicio
docker compose restart servicio
docker compose down
```

### Copias de seguridad y restauración

Identifica los volúmenes, las bases de datos y los archivos de configuración que requieren copia de seguridad. Describe el procedimiento específico para obtener una copia consistente y comprobar que puede restaurarse.

### Actualización y reversión

Documenta cómo actualizar a una versión concreta, verificar la compatibilidad y recuperar la versión anterior si falla la actualización. No utilices `latest` como estrategia de control de versiones.

## Seguridad

Describe los permisos necesarios, la gestión de secretos, la exposición de puertos y el uso de TLS o de un proxy inverso cuando corresponda. No publiques servicios administrativos sin controles de acceso.

## Resolución de problemas

| Síntoma            | Comprobación        | Solución                     |
|--------------------|---------------------|------------------------------|
| ERROR REPRODUCIBLE | COMANDO O EVIDENCIA | ACCIÓN CORRECTIVA COMPROBADA |

<!-- Elimina secciones opcionales que no puedas completar con información específica y verificada. -->
