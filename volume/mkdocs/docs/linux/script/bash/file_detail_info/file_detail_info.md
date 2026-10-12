---
title: "file_detail_info.sh"
authors:
  - Carmelo Molero Castillo
date: 2025-03-21
version: 1.0.0
---

# file_detail_info

![File Detail Info](img/img-file_detail_info-header-01.svg)

## Descripción
Este script analiza los archivos de video en un directorio dado y proporciona información detallada sobre cada archivo. Extrae información como el tamaño del archivo, el códec de video, la resolución, el número de pistas de audio y subtítulos, y más. Utiliza la herramienta `ffprobe` para obtener los detalles de los streams de video, audio y subtítulos. El tamaño de los archivos se muestra en una unidad legible (B, KB, MB, GB).

---

## Uso
```bash
./file_detail_info.sh directorio
```

---

## Dependencias
- `ffprobe`: Se utiliza para obtener la información detallada sobre los streams de video, audio y subtítulos.
- `stat`: Para obtener el tamaño del archivo.

---

## Requisitos
- El directorio debe contener archivos de video para que el script pueda analizarlos.
- Asegúrate de tener permisos de ejecución en el script.

---

## Funcionalidad
Este script analiza todos los archivos en un directorio dado, extrayendo y mostrando información detallada sobre cada archivo de video, incluyendo:

- Tamaño del archivo en una unidad legible (B, KB, MB, GB).  
- Códec de video utilizado.  
- Resolución del video.  
- Número de pistas de audio y subtítulos.
  
La salida se presenta de manera clara y legible para facilitar la visualización de los detalles de cada archivo de video.

---

## Ejemplo
```bash
./file_detail_info.sh /ruta/a/mi/directorio
```

Este comando recorrerá todos los archivos dentro del directorio especificado, mostrando detalles sobre cada archivo de video.

---

## Notas
- El script muestra la información de los archivos `.mp4` que se encuentran en el directorio especificado.
- Se muestra información sobre códec de video (x264, x265, etc.), resolución, número de pistas de audio y subtítulos.
- El tamaño de los archivos se convierte a una unidad legible (B, KB, MB, GB) según su magnitud.

---

## Script

```bash
#!/bin/bash

# ==========================================================================================================
#
# Autor: Carmelo Molero Castillo
# Versión: v1.1.1
# Cambios de version: Calculo de espacio en las unidades analizadas <-- Por implementar
#
# Fecha de creación: 14/01/2024
# Última modificación: 14/01/2024
# Descripción: Analiza los archivos de video en un directorio dado, proporcionando información 
# 			   detallada sobre cada archivo, incluyendo tamaño, formato, códec de video, resolución,
# 			   y cantidad de pistas de audio y subtítulos. Utiliza 'ffprobe' cantidad de pistas de 
# 			   audio y subtítulos.
# 			   Utiliza 'ffprobe' para extraer información de los streams y muestra el tamaño.
# 			   La salida se presenta en un formato legible para cada archivo procesado.
#
# Uso: ./file_detail_info.sh <directorio>
#
# Notas:
# - Asegúrate de tener permisos de ejecución antes de usar el script (chmod +x nombre_script.sh).
# - El script procesa archivos de video en el directorio especificado, mostrando información detallada.
# - Se utiliza 'ffprobe' para obtener información sobre los streams de video, audio y subtítulos.
# - El tamaño de los archivos se muestra en bytes, kilobytes, megabytes o gigabytes según su magnitud.
# - Ajusta las rutas y comandos según tus necesidades antes de ejecutar el script.
#
# ==========================================================================================================



# Verificar que se haya proporcionado un parámetro
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

directory="$1"

file_count=0

find "$directory" -iname "*" -type f | \
#awk -F'/(PI[0-9][0-9]_(FILM|SERIES)|SERIES)/' '{
#awk -F'/PI[0-9][0-9]_(FILM|SERIES)/' '{

# Patrón: lib_00 ó lib_00
awk -F'/lib_[0-9][0-9]/' '{
	# printf "\nSTART\n";
	
	# Incrementar el contador de archivos
	file_count++;
	
	complete_path = $0
	path_mount_point = $1
    path_and_name = $2;

    path = "#NO_PATH";
    name = "#NO_NAME";
    ext = "#NO_EXT";
	
	video_codec = "#N/A"
	video_resolution = "#N/A"

	num_video_tracks = 0;
	num_audio_tracks = 0;
	num_subtitle_tracks = 0;

    if (match($0, /\/lib_[0-9][0-9]\//)) {
        mount_point = substr($0, RSTART+1, RLENGTH-2);
    }

	if (match(path_and_name, /.+\//)) {
		path = substr(path_and_name, RSTART, RLENGTH - 1);
		name_with_extension = substr(path_and_name, RSTART + RLENGTH);

		# Revertir la cadena antes de extraer la extensión
		cmd = "echo \"" name_with_extension "\" | rev";
		cmd |& getline reversed_name_with_extension;
		close(cmd);

		# Revertir la cadena antes de extraer la extensión
		reversed_name_with_extension = reverse(name_with_extension);

		# Dividir la cadena invertida antes del primer punto
		split(reversed_name_with_extension, parts, /\./);
		aux_1 = parts[1];
		delete parts[1];  			# Eliminar la primera parte
		aux_2 = join(parts, ".");	# Unir las partes restantes con el punto

		# Revertir la cadena antes de extraer la extensión y el nombre
		ext = reverse(aux_1);
		name = reverse(aux_2);
	}
	
	# Obtener el tamaño del archivo en bytes usando stat
    size_in_bytes_command = "stat -c %s \"" complete_path "\"";
    size_in_bytes_command |& getline size_in_bytes;
    close(size_in_bytes_command);

	# Convertir el tamaño a B, KB, MB o GB según sea necesario
	if (size_in_bytes >= 1024*1024*999) {
		size = sprintf("%.2f", size_in_bytes / (1024*1024*1024));
		size_unit = "GB";
	} else if (size_in_bytes >= 1024*999) {
		size = sprintf("%.2f", size_in_bytes / (1024*1024));
		size_unit = "MB";
	} else if (size_in_bytes >= 999) {
		size = sprintf("%.2f", size_in_bytes / 1024);
		size_unit = "KB";
	} else {
		size = size_in_bytes;
		size_unit = "B";
	}

	# Obtener información de todos los streams
	ffprobe_command = "ffprobe -v error -show_entries stream -of csv=p=0:nk=1:escape=csv \"" complete_path "\"";
	while ((ffprobe_command |& getline stream_info) > 0) {
		# Almacena la información en arrays según el tipo de stream
		if (stream_info ~ /video/) {
			video_tracks[++num_video_tracks] = stream_info;
		} else if (stream_info ~ /audio/) {
			audio_tracks[++num_audio_tracks] = stream_info;
		} else if (stream_info ~ /subtitle/) {
			subtitle_tracks[++num_subtitle_tracks] = stream_info;
		}
	}
	close(ffprobe_command);
    
    
    # printf "\n\n"fields[2]"\n\n";


	# Inicializar propiedades de vídeo
	split(video_tracks[1], fields, ",");
	if (fields[2] == "h264") {
		video_codec = "x264";
	} else if (fields[2] == "hevc") {
		video_codec = "x265";
	}else if (index(fields[2], "mpeg") == 1) {
		video_codec = "mpeg";
	}
	video_resolution = sprintf("%4s x %4s", fields[8], fields[9])
	
	#printf "[%5s] [%-12s] [%4s] [%7s %2s] [Vd: %5s, %11s] [Ad: %2s] [Sb: %2s] -->  %s\n", file_count, mount_point, ext, size, size_unit, video_codec, video_resolution, num_audio_tracks, num_subtitle_tracks, name;
	printf "[%5s] [%-10s] [%4s] [%7s %2s] [Vd: %5s, %11s] [Ad: %2s] [Sb: %2s] -->  %s\n", file_count, mount_point, ext, size, size_unit, video_codec, video_resolution, num_audio_tracks, num_subtitle_tracks, complete_path;

	# Limpiar los arrays para la próxima iteración
	delete audio_info_array;
	delete subtitle_codecs_array;
	num_audio_tracks = 0;
	num_subtitle_tracks = 0;

}

function reverse(str) {
    result = "";
    for (i = length(str); i >= 1; i--) {
        result = result substr(str, i, 1);
    }
    return result;
}

function join(array, delimiter, result, i) {
    result = array[1];
    for (i = 2; i <= length(array); i++) {
        result = result delimiter array[i];
    }
	
	    # Eliminar el primer caracter si es un punto
    result = gensub(/^\./, "", "g", result);
    
    # Eliminar el último caracter si es un punto
    result = gensub(/\.$/, "", "g", result);
    return result;
}
'
```