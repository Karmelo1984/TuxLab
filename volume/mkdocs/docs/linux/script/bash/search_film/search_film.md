---
title: "search_film.sh"
authors:
  - Carmelo Molero Castillo
date: 2025-03-21
version: 1.0.0
---

# search_film

![Search Film](img/img-search_film-header-01.svg)

## Descripción
Este script busca archivos en un directorio específico y verifica su existencia en un archivo de registro.  
Elimina la extensión de los archivos y cualquier contenido entre corchetes, dejando solo el nombre y el año.  
Los resultados se presentan en un formato ordenado, separando los archivos encontrados de los no encontrados.

---

## Uso
```bash
./search_film.sh -d <directorio_archivos> -f <fichero_busqueda>
```
Donde:
- `-d <directorio_archivos>`: Especifica el directorio donde se encuentran los archivos a buscar.
- `-f <fichero_busqueda>`: Especifica el archivo que contiene las referencias de búsqueda.

Ejemplo de ejecución:
```bash
./search_film.sh -d /mnt/storage/descargas/peliculas/ -f /home/carmelo/peliculas.log
```

---

## Dependencias
- `grep`
- `sed`
- `basename`
- `sort`

---

## Requisitos
- El directorio especificado debe existir y contener archivos.
- El archivo de búsqueda debe existir y contener referencias válidas.
- El script debe tener permisos de ejecución (`chmod +x search_film.sh`).

---

## Funcionalidad
1. **Verifica** que se han pasado los parámetros obligatorios y que los archivos/directorios existen.
2. **Itera** sobre los archivos en el directorio especificado.
3. **Limpia** el nombre de los archivos eliminando la extensión y cualquier contenido entre corchetes.
4. **Busca** coincidencias en el archivo de registro.
5. **Clasifica** los archivos en:
   - **Encontrados**: Se generan comandos `rm` para su eliminación.
   - **No encontrados**: Se listan de forma ordenada.

---

## Ejemplo
Si el directorio `/mnt/storage/descargas/peliculas/` contiene:
```
Avatar (2009).mkv
Inception (2010).mp4
Matrix (1999).avi
```
Y el archivo `/home/carmelo/peliculas.log` contiene:
```
Avatar 2009 --> /backup/movies/Avatar (2009).mkv
Matrix 1999 --> /backup/movies/Matrix (1999).avi
Inception (2010).mp4
```
Al ejecutar:
```bash
./search_film.sh -d /mnt/storage/descargas/peliculas/ -f /home/carmelo/peliculas.log
```
El resultado será:
```
rm -f "/backup/movies/Avatar (2009).mkv"
rm -f "/backup/movies/Matrix (1999).avi"
```
Esto indica que `Avatar` y `Matrix` fueron encontrados en el registro, mientras que `Inception` no.

---

## Notas
- El script solo busca en el directorio especificado, no en subdirectorios.
- Se recomienda verificar la lista de archivos antes de ejecutar los comandos `rm`.
- La salida está ordenada para facilitar la revisión.

---

## Script

```bash
#!/bin/bash

# -------------------------------------------
# Script de Búsqueda de Archivos
# -------------------------------------------
# Descripción:
# Este script busca archivos en un directorio específico y verifica su existencia en un archivo de registro.
# Elimina la extensión de los archivos y las partes que están entre corchetes, dejando solo el nombre y el año.
# Los resultados se muestran en un formato ordenado.
#
# Uso:
# ./script.sh -d <directorio_archivos> -f <fichero_busqueda>
#
# Parámetros:
# -d <directorio_archivos>   : Ruta del directorio donde se encuentran los archivos a buscar.
# -f <fichero_busqueda>      : Ruta del archivo que contiene las referencias de búsqueda.
#
# Ejemplo:
# ./script.sh -d /mnt/storage/descargas/peliculas/ -f /home/carmelo/peliculas.log
#
# Notas:
# - Asegúrate de que el directorio de archivos y el archivo de búsqueda existan antes de ejecutar el script.
# - El script no está diseñado para manejar subdirectorios; solo busca en el directorio especificado.
# - La salida del script está ordenada alfabéticamente, tanto para los archivos encontrados como para los que no se encontraron.
# -------------------------------------------

# Función para mostrar el uso del script
mostrar_uso() {
    echo "Uso: $0 -d <directorio_archivos> -f <fichero_busqueda>"
    exit 1
}

# Procesar los flags
while getopts "d:f:" opt; do
    case $opt in
        d) directorio_archivos="$OPTARG" ;;
        f) fichero_busqueda="$OPTARG" ;;
        *) mostrar_uso ;;
    esac
done

# Comprobar que se han pasado ambos parámetros
if [ -z "$directorio_archivos" ] || [ -z "$fichero_busqueda" ]; then
    mostrar_uso
fi

# Comprobar que el directorio de archivos existe
if [ ! -d "$directorio_archivos" ]; then
    echo "Error: El directorio '$directorio_archivos' no existe."
    exit 1
fi

# Comprobar que el fichero de búsqueda existe
if [ ! -f "$fichero_busqueda" ]; then
    echo "Error: El fichero '$fichero_busqueda' no existe."
    exit 1
fi

# Array para almacenar resultados
declare -a resultados_encontrados
declare -a resultados_no_encontrados

# Iterar sobre los archivos en el directorio (cualquier extensión)
for archivo in "$directorio_archivos"/*; do
    nombre_archivo=$(basename "$archivo")  # Obtener solo el nombre del archivo

    # Extraer el nombre sin la extensión
    nombre_sin_extension=$(echo "$nombre_archivo" | sed 's/\.[^.]*$//')  # Eliminar la extensión
    nombre_con_fecha=$(echo "$nombre_sin_extension" | sed 's/\[.*\]//g' | sed 's/ *$//')  # Eliminar lo que está entre corchetes y los espacios finales

    # Buscar en el fichero de búsqueda
    resultado=$(grep -i ".*$nombre_con_fecha.*" "$fichero_busqueda")

    if [ -n "$resultado" ]; then
        # Extraer la ruta completa del resultado, después de "--> "
        ruta_completa=$(echo "$resultado" | sed 's/.*--> //')
        resultados_encontrados+=("rm -f \"$ruta_completa\"")
    else
        resultados_no_encontrados+=("$nombre_con_fecha")
    fi
done

# Ordenar los resultados encontrados y no encontrados
(printf "%s\n" "${resultados_encontrados[@]}" | sort)
(printf "%s\n" "${resultados_no_encontrados[@]}" | sort)
```