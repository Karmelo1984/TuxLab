---
title: "file_rename.sh"
authors:
  - Carmelo Molero Castillo
date: 2025-03-21
version: 1.0.0
---

# file_rename

![File Rename](img/img-file_rename-header-01.svg)

## Descripción
Este script permite renombrar archivos dentro de un directorio específico utilizando un archivo de texto que contiene los nuevos nombres. Cada línea del archivo de nombres debe seguir el formato `<cabecera> - <nombre>`, donde `cabecera` se usará para identificar el archivo a renombrar.

---

## Uso
```bash
./file_rename.sh -f <archivo_de_nombres> -p <directorio_origen>
```

### Opciones:
- `-f`: Especifica el archivo de texto con los nuevos nombres.
- `-p`: Define el directorio de origen donde se encuentran los archivos a renombrar.

---

## Dependencias
- `awk`
- `find`
- `mv`
- `dirname`
- `mapfile`

---

## Requisitos
- El archivo de nombres debe existir y no estar vacío.
- El directorio de origen debe ser válido y contener archivos que coincidan con las cabeceras del archivo de nombres.

---

## Funcionalidad
El script realiza las siguientes acciones:

1. **Validación de parámetros**: Verifica que el directorio de origen y el archivo de nombres sean válidos.
2. **Lectura del archivo de nombres**: Procesa cada línea en busca de la cabecera y el nuevo nombre.
3. **Búsqueda de archivos**: Localiza los archivos en el directorio de origen que coincidan con la cabecera.
4. **Renombrado de archivos**:
      - Si se encuentra exactamente un archivo con la cabecera, se renombra con el nuevo nombre.
      - Si se encuentran múltiples archivos para la misma cabecera, la línea es ignorada.
      - Si el nuevo nombre ya existe, se omite el renombrado para evitar sobreescrituras.

---

## Ejemplo
```bash
./file_rename.sh -f nombres.txt -p /ruta/a/mi/directorio
```
Si `nombres.txt` contiene:
```
video1 - Película A
video2 - Serie B
```
Y el directorio `/ruta/a/mi/directorio` tiene archivos como:
```
video1 - 1080p.mp4
video2 - HD.mkv
```
El resultado será:
```
/ruta/a/mi/directorio/video1 - 1080p.mp4  →  /ruta/a/mi/directorio/video1 - Película A.mp4
/ruta/a/mi/directorio/video2 - HD.mkv     →  /ruta/a/mi/directorio/video2 - Serie B.mkv
```

---

## Notas
- Ignora líneas con nombres vacíos o no válidos.
- Si hay más de un archivo coincidente para una cabecera, la línea se salta.
- Si un archivo con el nuevo nombre ya existe, no se renombra para evitar conflictos.

---

## Script

```bash
#!/bin/bash

################################################################################
# Fecha: 2025-01-08
# Versión: 1.1
# Autor: Carmelo Molero Castillo
#
# Descripción: 
#     Este script renombra archivos en un directorio específico basándose en un 
#     archivo de texto que contiene los nuevos nombres.
#
# Uso: 
#     ./script.sh -f <archivo_de_nombres> -p <directorio_origen>
#
#   -f: Especifica el archivo de texto que contiene los nombres (formato: "<cabecera> - <nombre>").
#   -p: Especifica el directorio de origen donde buscar los archivos a renombrar.
#
# Requisitos:
#   - El archivo de nombres debe existir y no estar vacío.
#   - El directorio de origen debe ser válido y contener los archivos a renombrar.
#
# Notas:
#   - Ignora líneas con nombres vacíos o no válidos.
#   - Si hay más de un archivo coincidente para una cabecera, la línea se salta.
################################################################################


# Variables predeterminadas
FILE_NAME="./archivo_de_nombres.txt"
DIRECTORIO_ORIGEN=""

# Función: Mostrar mensaje de error y salir
error_exit() {
  echo "Error: $1" >&2
  exit 1
}

# Función: Procesar las opciones del script
procesar_opciones() {
  while getopts "f:p:" opt; do
    case $opt in
      f)
        FILE_NAME="$OPTARG"
        ;;
      p)
        DIRECTORIO_ORIGEN="$OPTARG"
        ;;
      \?)
        error_exit "Opción inválida: -$OPTARG"
        ;;
      :)
        error_exit "La opción -$OPTARG requiere un argumento."
        ;;
    esac
  done
}

# Función: Validar los parámetros iniciales
validar_parametros() {
  if [ -z "$DIRECTORIO_ORIGEN" ] || [ ! -d "$DIRECTORIO_ORIGEN" ]; then
    error_exit "Se requiere el parámetro -p con la ruta válida al directorio de origen."
  fi

  if [ ! -s "$FILE_NAME" ]; then
    error_exit "El archivo de nombres '$FILE_NAME' no existe o está vacío."
  fi
}

# Función: Procesar una línea del archivo de nombres
procesar_linea() {
  local nuevo_nombre="$1"

  cabecera="$(echo "$nuevo_nombre" | awk -F ' - ' '{print $1}')"
  nombre="$(echo "$nuevo_nombre" | awk -F ' - ' '{print $2}')"

  # Validar que el nombre no esté vacío
  if [ -z "$nombre" ] || [ "$nombre" == " " ]; then
    return
  fi

  # Buscar archivos que coincidan con la cabecera
  mapfile -t files_to_rename < <(find "$DIRECTORIO_ORIGEN" -type f -name "*$cabecera*" -print0)
  local num_files=${#files_to_rename[@]}

  # Si no hay o hay más de un archivo, saltar
  if [ "$num_files" -ne 1 ]; then
    echo "$cabecera  --> Se han encontrado [$num_files] ficheros, saltando a la siguiente iteración"
    echo ""
    return
  fi

  # Renombrar el archivo
  local file_to_rename="${files_to_rename[0]}"
  local directory=$(dirname "$file_to_rename")
  local extension=$(echo "$file_to_rename" | awk -F '.' '{print $NF}')
  local new_name="$directory/$cabecera - $nombre.$extension"

  # Comprobar si el archivo de destino ya existe
  if [ -e "$new_name" ]; then
    echo "jump : $new_name"
    echo ""
    return
  fi
  
  echo "from : $file_to_rename"
  echo "to   : $new_name"

  mv "$file_to_rename" "$new_name"
  echo ""
}

# Función: Procesar el archivo de nombres
procesar_archivo_nombres() {
  while IFS= read -r nuevo_nombre || [ -n "$nuevo_nombre" ]; do
    procesar_linea "$nuevo_nombre"
  done < "$FILE_NAME"
}

# Main: Ejecutar las funciones
procesar_opciones "$@"
validar_parametros

echo "FICHERO DE NOMBRES : $FILE_NAME"
echo "PATH RAIZ          : $DIRECTORIO_ORIGEN"
echo ""

procesar_archivo_nombres

```

