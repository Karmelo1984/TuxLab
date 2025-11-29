---
title: "{{ title }}"
authors:
  - {{ author }}
date: {{ date }}
version: {{ version }}
---

# {{ title }}

![{{ title }}](./img/{{ image_header }})

**{{ title }}** es una plataforma {{ tipo_de_software }} que permite a los usuarios {{ descripcion_breve }}. 

A diferencia de {{ alternativas }}, {{ title }} {{ diferencias_clave }}. Ofrece una interfaz {{ caracteristicas_principales }}.

{{ title }} está basado en {{ base_tecnologica }} y ha sido adaptado para {{ detalles_tecnicos }}. {{ notas_extra }}.

🔹 **Página oficial**: [{{ url_oficial }}]({{ url_oficial }})

---

## Instalación

Todos los ficheros relacionados con nuestra instalación de **{{ title }}** se alojarán dentro de un directorio ubicado en `{{ ruta_instalacion }}`.

### Paso 1: Crear la estructura de directorios

```bash
{{ comandos_directorios }}
````

### Paso 2: Crear el archivo `docker-compose.yml`

```bash
$ vim {{ ruta_docker_compose }}
```

### Paso 3: Estructura de directorios esperada

```bash
$ tree ~

{{ estructura_directorios }}
```

---

## Despliegue de `docker-compose.yml`

```bash
$ docker-compose up -d
$ docker-compose down
$ docker logs -f <ID_CONTENEDOR>
```

### Contenido del archivo `docker-compose.yml`

```yaml
{{ contenido_docker_compose }}
```

---

## Acceso

Accede desde tu navegador a:

```
http://{{ ip }}:{{ puerto }}
```

---

## Personalización

### Cambiar apariencia

#### Opción 1: Importando CSS

Puedes usar temas como \[{{ nombre\_tema }}]\({{ enlace\_tema }}).
Configura importando el enlace aquí:

!\[Importar CSS]\(img/{{ imagen\_css }})

#### Opción 2: Usando plugin {{ plugin }}

1. Agregar el repositorio `{{ enlace_repositorio }}`
   !\[Importar Repositorio]\(img/{{ imagen\_repo1 }})
2. Instalar el repositorio
   !\[Instalar Repositorio]\(img/{{ imagen\_repo2 }})
3. Reiniciar el contenedor
4. Elegir tema en `Dashboard / {{ plugin }}`
   !\[Seleccionar Tema]\(img/{{ imagen\_repo3 }})

---

## Configuración de la biblioteca

```bash
{{ estructura_biblioteca }}
```
