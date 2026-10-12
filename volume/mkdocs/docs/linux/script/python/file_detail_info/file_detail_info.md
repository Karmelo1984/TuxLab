---
title: "file_detail_info"
authors:
  - Carmelo Molero Castillo
date: 2025-04-05
version: 1.0.0
---

# file_detail_info

![File Detail Info](img/img-file_detail_info-header-01.svg)

## Descripción

Este script permite analizar de forma detallada archivos de vídeo dentro de un directorio específico, proporcionando información como tamaño, duración, resolución, códecs, pistas de audio y subtítulos. También genera estadísticas globales sobre el total de archivos procesados.

---

## Uso

```bash
python script.py --directory <ruta_directorio> [--extensions ['<ext1>', '<ext2>' ...]]
```

**Parámetros:**

- `--directory` / `-d`: Ruta al directorio donde se encuentran los vídeos (obligatorio).
- `--extensions` / `-e`: Lista de extensiones a procesar. Por defecto: `avi`, `mp4`, `mkv`, `iso`.

---

## Dependencias

- Python ≥ 3.7
- moviepy
- natsort

---

## Requisitos

- Tener `ffprobe` instalado (forma parte de FFmpeg).
- Acceso de lectura al directorio que contiene los vídeos.

---

## Funcionalidad

- Recorre recursivamente todos los archivos de un directorio.
- Filtra archivos por extensión.
- Usa `ffprobe` para extraer metadatos del archivo.
- Usa `moviepy` para obtener la duración exacta.
- Muestra información de cada vídeo: extensión, tamaño, duración, códec, resolución, pistas de audio y subtítulos.
- Acumula estadísticas globales: cantidad de archivos, tiempo total de reproducción, tamaño total, tipos de códec y formatos.

---

## Ejemplo

```bash
python script.py --directory ./videos --extensions mp4 mkv
```

Salida esperada (resumen por archivo):

```
[    1] [videos    ] [mp4 ] [   345.67 MB] [ 00:12:34 ] [Vd: x264 , 1920 x 1080] [Ad:  2] [Sb:  1] --> ./videos/ejemplo.mp4
```

Y al final:

```
# Estadísticas finales:
   - Cantidad total de archivos: 25
   - Tamaño total: 18.23 GB
   - Tiempo total de reproducción: 08 horas, 15 min. 12 seg.
   - Cantidad de códec de video:
     · x264: 20
     · x265: 5
   - Cantidad de formatos diferentes:
     · mp4: 15
     · mkv: 10

# Tiempo total de escaneo: 00 horas, 00 min. 23 seg.
```

---

## Notas

- Si un archivo presenta errores, el script continuará con el siguiente.
- Los vídeos se ordenan alfabéticamente para facilitar el seguimiento.
- El script puede adaptarse fácilmente para procesar otros tipos de archivos multimedia.

---

## Script

```bash

import os
import locale
import subprocess
import argparse
import time
import json

from natsort import natsorted

from collections import defaultdict
from typing import List, Dict, Union, Tuple
from moviepy.editor import VideoFileClip


def join(array: List[str], delimiter: str) -> str:
    """
    Une una lista de cadenas en una sola cadena, usando un delimitador específico,
    y elimina los puntos ('.') al principio y al final de la cadena resultante.

    :param array: Lista de cadenas a unir.
    :param delimiter: Delimitador a usar para unir las cadenas.
    :return: Una cadena resultante de unir las cadenas con el delimitador,
             sin puntos al principio ni al final.
    """
    return delimiter.join(array).lstrip(".").rstrip(".")

def get_mediainfo(path: str) -> Union[Dict, list]:
    """
    Obtiene información de medios de un archivo de vídeo utilizando `ffprobe`.
    
    Ejecuta `ffprobe` en el archivo especificado por `path` para obtener detalles
    sobre las pistas del archivo en formato JSON. Si el comando falla o la salida
    no se puede decodificar, se maneja la excepción y se devuelve una lista vacía.

    :param path: Ruta del archivo de vídeo del cual obtener la información.
    :return: Un diccionario con la información del archivo en formato JSON si el
             comando se ejecuta correctamente. Si ocurre un error, devuelve una lista vacía.
    """
    ffprobe_command = ["ffprobe", "-v", "error", "-show_entries", "stream", "-of", "json", path]
    
    try:
        # Ejecutar el comando ffprobe y obtener la salida
        output = subprocess.check_output(ffprobe_command, stderr=subprocess.DEVNULL).decode("utf-8")
        # Decodificar la salida JSON y devolverla como un diccionario
        return json.loads(output)
    
    except subprocess.CalledProcessError as e:
        # Manejo de errores si ffprobe falla
        #print(f"Error al ejecutar ffprobe en el archivo {path} --> {e}", file=sys.stderr)
        return []
    
    except json.JSONDecodeError:
        # Manejo de errores si la salida JSON no se puede decodificar
        #print(f"Error al decodificar la salida JSON de ffprobe para el archivo {path}", file=sys.stderr)
        return []

def get_info_tracks(mediainfo: Dict) -> Tuple[List[Dict], List[Dict], List[Dict]]:
    """
    Extrae las pistas de vídeo, audio y subtítulos del fichero.

    Analiza la información de medios proporcionada por `mediainfo` y clasifica
    las pistas en vídeo, audio y subtítulos en listas separadas.

    :param mediainfo: Un diccionario que contiene la información de medios en formato JSON,
                      típicamente obtenido de `ffprobe`.
    :return: Una tupla que contiene tres listas:
             - La primera lista contiene diccionarios de pistas de vídeo.
             - La segunda lista contiene diccionarios de pistas de audio.
             - La tercera lista contiene diccionarios de pistas de subtítulos.
    """
    # Listas para almacenar las pistas de vídeo, audio y subtítulos
    video_tracks = []
    audio_tracks = []
    subtitle_tracks = []

    # Iterar sobre los flujos en la información de medios
    for stream in mediainfo.get('streams', []):
        # Clasificar las pistas según su tipo de códec
        if stream['codec_type'] == 'video':
            video_tracks.append(stream)
        elif stream['codec_type'] == 'audio':
            audio_tracks.append(stream)
        elif stream['codec_type'] == 'subtitle':
            subtitle_tracks.append(stream)

    # Devolver una tupla con las listas de pistas clasificadas
    return video_tracks, audio_tracks, subtitle_tracks

def convert_size(size_in_bytes: int) -> Tuple[float, str]:
    """
    Convierte un tamaño en bytes a una representación más legible en unidades de almacenamiento.

    La función convierte un tamaño dado en bytes a la unidad más adecuada (Bytes, KB, MB, GB, TB, PB, EB, ZB, YB),
    redondeando el valor según el tamaño del archivo.

    :param size_in_bytes: Tamaño del archivo en bytes.
    :return: Una tupla que contiene:
             - El tamaño convertido en la unidad más adecuada (como float).
             - La unidad de medida correspondiente (como string).
    """
    if size_in_bytes >= (1024**7)*999:
        # Convertir a Yottabytes (YB)
        size = size_in_bytes / (1024**8)
        size_unit = "YB"
    elif size_in_bytes >= (1024**6)*999:
        # Convertir a Zettabytes (ZB)
        size = size_in_bytes / (1024**7)
        size_unit = "ZB"
    elif size_in_bytes >= (1024**5)*999:
        # Convertir a Exabytes (EB)
        size = size_in_bytes / (1024**6)
        size_unit = "EB"
    elif size_in_bytes >= (1024**4)*999:
        # Convertir a Petabytes (PB)
        size = size_in_bytes / (1024**5)
        size_unit = "PB"
    elif size_in_bytes >= (1024**3)*999:
        # Convertir a Terabytes (TB)
        size = size_in_bytes / (1024**4)
        size_unit = "TB"
    elif size_in_bytes >= (1024**2)*999:
        # Convertir a Gigabytes (GB)
        size = size_in_bytes / (1024**3)
        size_unit = "GB"
    elif size_in_bytes >= 1024*999:
        # Convertir a Megabytes (MB)
        size = size_in_bytes / (1024**2)
        size_unit = "MB"
    elif size_in_bytes >= 999:
        # Convertir a Kilobytes (KB)
        size = size_in_bytes / 1024
        size_unit = "KB"
    else:
        # Dejar en Bytes (B)
        size = size_in_bytes
        size_unit = "B"
    
    return size, size_unit

def segundos_a_hhmmss(segundos_totales: int) -> Tuple[int, int, int]:
    """
    Convierte una cantidad total de segundos a una representación en horas, minutos y segundos.

    La función toma una cantidad de segundos y la convierte en una tupla que contiene
    la cantidad de horas, minutos y segundos correspondientes, todos como enteros.

    :param segundos_totales: Cantidad total de segundos a convertir. Debe ser un número entero.
    :return: Una tupla de tres enteros que representan las horas, minutos y segundos,
             respectivamente.
    """
    # Calcula el número de horas y los segundos restantes después de extraer las horas
    horas, resto = divmod(segundos_totales, 3600)
    # Calcula el número de minutos y los segundos restantes después de extraer los minutos
    minutos, segundos = divmod(resto, 60)
    
    # Devuelve las horas, minutos y segundos como enteros
    return int(horas), int(minutos), int(segundos)

def format_duration(seconds: float) -> str:
    """
    Convierte una duración en segundos a un formato de cadena 'hh horas, mm min. ss seg.'.

    :param seconds: Duración en segundos.
    :return: Duración formateada como cadena.
    """
    horas, minutos, segundos = segundos_a_hhmmss(seconds)
    return f"{int(horas):02} horas, {int(minutos):02} min. {int(segundos):02} seg."

def get_duracion(video_path: str) -> Tuple[str, float]:
    """
    Obtiene la duración de un vídeo en segundos y en formato `hh:mm:ss`.

    La función carga el vídeo desde la ruta proporcionada, obtiene su duración en segundos
    y la convierte a un formato legible de horas, minutos y segundos. Luego devuelve
    tanto el formato legible como la duración en segundos.

    :param video_path: Ruta del fichero de vídeo (cadena de texto).
    :return: Una tupla que contiene:
             - La duración del vídeo en formato `hh:mm:ss` como una cadena de texto.
             - La duración del vídeo en segundos como un número de punto flotante.
    """
    # Cargar el vídeo
    clip = VideoFileClip(video_path)
    
    # Obtener la duración en segundos
    duracion_segundos = clip.duration
    
    # Convertir la duración a formato `hh:mm:ss`
    horas, minutos, segundos = segundos_a_hhmmss(int(duracion_segundos))
    duracion_formateada = f"{horas:02}:{minutos:02}:{segundos:02}"
    
    # Devolver la duración formateada y la duración en segundos
    return duracion_formateada, duracion_segundos

def process_video_file(complete_path: str, codec_count: defaultdict) -> Tuple[str, float, str, int, int, int, int]:
    """
    Procesa un archivo de video para obtener sus detalles y manejar cualquier excepción.

    :param complete_path: Ruta completa del archivo de video.
    :param codec_count: Contador de códecs.
    :return: Una tupla con los detalles del archivo (extensión, tamaño formateado, unidad de tamaño, tiempo formateado, codec de video, resolución de video, número de pistas de audio, número de pistas de subtítulos, tamaño en bytes, tiempo de reproducción en segundos).
    """
    ext = os.path.splitext(complete_path)[1].lower().lstrip('.')
    size_in_bytes = os.path.getsize(complete_path)
    size, size_unit = convert_size(size_in_bytes)

    video_codec = "????"
    video_resolution = "???? x ????"
    num_audio_tracks = "?"
    num_subtitle_tracks = "?"
    time_format = "??:??:??"
    time_total_repr = 0

    try:
        mediainfo = get_mediainfo(complete_path)
        video_tracks, audio_tracks, subtitle_tracks = get_info_tracks(mediainfo)

        if video_tracks:
            video_track = video_tracks[0]

            width = video_track.get('width', 0)
            coded_width = video_track.get('coded_width', 0)
            height = video_track.get('height', 0)
            coded_height = video_track.get('coded_height', 0)

            final_width = max(width, coded_width) if width and coded_width else width or coded_width
            final_height = max(height, coded_height) if height and coded_height else height or coded_height

            codec_name = video_track.get('codec_name', "????")
            if codec_name == "h264":
                video_codec = "x264"
            elif codec_name == "hevc":
                video_codec = "x265"
            elif codec_name.startswith("mpeg"):
                video_codec = "mpeg"
            else:
                video_codec = codec_name

            codec_count[video_codec] += 1
            video_resolution = f"{final_width:4} x {final_height:4}"
            num_audio_tracks = len(audio_tracks)
            num_subtitle_tracks = len(subtitle_tracks)

            time_format, time_seg = get_duracion(complete_path)
            time_total_repr += time_seg

        return ext, size, size_unit, time_format, video_codec, video_resolution, num_audio_tracks, num_subtitle_tracks, size_in_bytes, time_total_repr

    except Exception as e:
        return ext, size, size_unit, time_format, video_codec, video_resolution, num_audio_tracks, num_subtitle_tracks, size_in_bytes, 0

def file_detail_info(directory: str, extensions: List[str]):
    """
    Analiza los archivos de vídeo en el directorio dado y proporciona detalles sobre ellos,
    incluyendo el tamaño del archivo, el códec de vídeo, la resolución, y el número de pistas de audio y subtítulos.

    La función también recopila estadísticas como el tamaño total de los archivos, el tiempo total de reproducción,
    y la cantidad de códecs y formatos de archivo encontrados.

    :param directory: Ruta del directorio que contiene los archivos de vídeo (cadena de texto).
    :param extensions: Lista de extensiones de archivo a analizar (lista de cadenas de texto).
    :return: None
    """
    # Configura el locale para que sea independiente de mayúsculas y minúsculas y trate acentos de manera uniforme
    locale.setlocale(locale.LC_COLLATE, locale.getdefaultlocale())

    time_start_exec = time.time()  # Start time of the scan

    file_total_count = 0
    size_total_bytes = 0
    time_total_repr = 0
    codec_count = defaultdict(int)
    format_count = defaultdict(int)
    
    for root, _, files in os.walk(directory):
        # Ordenar los archivos alfabéticamente
        files = sorted(files, key=locale.strxfrm)

        # Obtener la parte inicial del directorio
        mount_point = os.path.relpath(root, directory).split(os.sep, 1)[0] or '/'

        for filename in files:
            # Solo analizar archivos con ciertas extensiones
            ext = os.path.splitext(filename)[1].lower().lstrip('.')
            if ext not in extensions:
                continue

            file_total_count += 1
            complete_path = os.path.join(root, filename)

            (ext, size, size_unit, time_format, video_codec, video_resolution, 
             num_audio_tracks, num_subtitle_tracks, size_in_bytes, time_total_repr_seg) = process_video_file(complete_path, codec_count)
            
            size_total_bytes += size_in_bytes
            time_total_repr += time_total_repr_seg
            format_count[ext] += 1

            print(f"[{file_total_count:5}] [{mount_point:10}] [{ext:4}] [{size:7.2f} {size_unit}] "
                  f"[ {time_format} ] "
                  f"[Vd: {video_codec:5}, {video_resolution:11}] "
                  f"[Ad: {num_audio_tracks:2}] "
                  f"[Sb: {num_subtitle_tracks:2}] "
                  f"--> {complete_path}")
    
    total_size, total_size_unit = convert_size(size_total_bytes)
    
    time_total_exec = time.time() - time_start_exec
    time_total_exec_format = format_duration(time_total_exec)
    time_total_repr_format = format_duration(time_total_repr)

    print("\n\n# Estadísticas finales:")
    print(f"   - Cantidad total de archivos: {file_total_count}")
    print(f"   - Tamaño total: {total_size:.2f} {total_size_unit}")
    print(f"   - Tiempo total de reproducción: {time_total_repr_format}")
    print("   - Cantidad de códec de video:")
    for codec, count in codec_count.items():
        print(f"     · {codec}: {count}")
    print("   - Cantidad de formatos diferentes:")
    for fmt, count in format_count.items():
        print(f"     · {fmt}: {count}")
    print(f"\n# Tiempo total de escaneo: {time_total_exec_format}\n\n")

def main():
    """
    Configura el parser de argumentos para obtener información detallada de archivos de vídeo
    en un directorio dado. Permite especificar el directorio y las extensiones de archivo a analizar.

    Los argumentos pueden ser proporcionados desde la línea de comandos:
    - `--directory` o `-d`: Especifica el directorio que contiene los archivos de vídeo.
    - `--extensions` o `-e`: Lista de extensiones de archivo a analizar (por defecto: 'avi', 'mp4', 'mkv', 'iso').

    :return: None
    """
    # Configurar el parser de argumentos
    parser = argparse.ArgumentParser(description="Obtener información detallada de archivos de video en un directorio dado.")
    parser.add_argument("--directory", "-d", type=str, help="Directorio que contiene los archivos de video", required=True)
    parser.add_argument("--extensions", "-e", nargs='+', default=['avi', 'mp4', 'mkv', 'iso'],
                        help="Extensiones de archivo a analizar (por defecto: avi, mp4, mkv, iso)")

    # Obtener los argumentos proporcionados desde la línea de comandos
    args = parser.parse_args()

    # Obtener detalles de los archivos de video en el directorio dado
    file_detail_info(args.directory, args.extensions)

if __name__ == "__main__":
    """
    Punto de entrada principal del script.

    Esta sección se ejecuta solo si el script se ejecuta como un programa principal
    y no cuando se importa como un módulo en otro script. Llama a la función `main` para
    iniciar el procesamiento del script.

    :return: None
    """
    main()
```

