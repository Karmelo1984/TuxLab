---
title: "mp4_to_mkv.sh"
authors:
  - Carmelo Molero Castillo
date: 2025-03-21
version: 1.0.0
---

# mp4_to_mkv

![MP4 to MKV](img/img-mp4_to_mkv-header-01.svg)

## Descripción
Este script convierte archivos de video en formato `.mp4` a `.mkv` utilizando la herramienta `mkvmerge`. Es útil para cambiar el contenedor de video sin perder calidad.

---

## Uso
```bash
$ ./mp4_to_mkv.sh directorio_entrada directorio_salida
```

---

## Dependencias
- `mkvmerge`

---

## Requisitos
- El directorio de entrada debe contener archivos `.mp4` que serán convertidos a `.mkv`.
- El directorio de salida debe existir o será creado automáticamente.

---

## Funcionalidad
Convierte todos los archivos `.mp4` en un directorio de entrada a archivos `.mkv`, y los guarda en un directorio de salida. Durante el proceso, se verifica si la herramienta `mkvmerge` está instalada y si los directorios de entrada y salida son válidos.

---

## Ejemplo
```bash
$ ./mp4_to_mkv.sh /ruta/a/archivos_mp4 /ruta/de/salida
```

---

Este comando tomará todos los archivos `.mp4` de `/ruta/a/archivos_mp4` y los convertirá a `.mkv` en el directorio `/ruta/de/salida`.

---

## Notas
- Asegúrate de que `mkvmerge` esté instalado en tu sistema. Si no está, el script te lo notificará y se detendrá.
- El script solo procesará archivos `.mp4`. Si el directorio contiene otros tipos de archivo, serán ignorados.
- Si el directorio de salida no existe, el script lo creará automáticamente.
- El script no elimina los archivos `.mp4` después de la conversión, pero puedes hacerlo manualmente si lo deseas, descomentando la línea `# rm "$archivo"`.

---

## Script

```bash
#!/bin/bash

# Verificar si mkvmerge está instalado
if ! command -v mkvmerge &> /dev/null; then
    echo "#ERROR: mkvmerge no está instalado. Por favor, instálalo antes de continuar."
    exit 1
fi

# Verificar la cantidad correcta de argumentos
if [ "$#" -ne 2 ]; then
    echo "USO: $0 directorio_entrada directorio_salida"
    exit 1
fi

directorio_entrada="$1"
directorio_salida="$2"

# Verificar si el directorio de entrada existe
if [ ! -d "$directorio_entrada" ]; then
    echo "#ERROR: El directorio de entrada '$directorio_entrada' no existe."
    exit 1
fi

# Crear el directorio de salida si no existe
if [ ! -d "$directorio_salida" ]; then
    echo "Creando el directorio de salida '$directorio_salida'..."
    mkdir -p "$directorio_salida"
fi

# Inicializar contador de archivos procesados
archivos_procesados=0

# Procesar archivos mp4
for archivo in "$directorio_entrada"/*.mp4; do
    echo "    "
	
    nombre_sin_extension="$(basename "${archivo%.mp4}")"
    nuevo_nombre="$directorio_salida/$nombre_sin_extension.mkv"

    # Mostrar el archivo que se está procesando
    echo "    [$(date)] Archivo Entrada: $nombre_sin_extension.mp4"
		# Usar mkvmerge para cambiar la extensión
		mkvmerge -o "$nuevo_nombre" "$archivo"
		((archivos_procesados++))  # Incrementar el contador
    echo "    [$(date)] Archivo Salida : $nombre_sin_extension.mkv"
	
    # Opcional: eliminar el archivo original mp4
    # rm "$archivo"

done
    echo "    "

echo "PROCESO COMPLETADO. Se han convertido [$archivos_procesados] archivos mp4 a mkv. Directorio de salida --> '$directorio_salida'."

```