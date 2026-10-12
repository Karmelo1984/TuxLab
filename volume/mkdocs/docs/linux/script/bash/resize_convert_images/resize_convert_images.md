---
title: "image_resize_convert.sh"
authors:
  - Carmelo Molero Castillo
date: 2025-03-21
version: 1.0.0
---

# image_resize_convert

![Resize & Convert Images](img/img-resize_convert_images-header-01.svg)

## Descripción
Este script redimensiona y convierte imágenes en formato JPG a PNG, asegurando que todas tengan un tamaño uniforme de `1200x400` píxeles. Además, mantiene una copia de las imágenes originales en una carpeta separada dentro del directorio de entrada.

---

## Uso
```bash
./image_resize_convert.sh <directorio_de_imagenes>
```
Donde `<directorio_de_imagenes>` es la ruta de la carpeta que contiene las imágenes a procesar.

---

## Dependencias
- `convert` (parte del paquete `ImageMagick`)
- `basename`
- `mkdir`
- `mv`

Para instalar `ImageMagick`, usa:
```bash
$ sudo apt install imagemagick  # Debian/Ubuntu
$ brew install imagemagick      # macOS (Homebrew)
```

---

## Requisitos
- Se debe proporcionar un directorio válido con imágenes en formato `.jpg`.
- `ImageMagick` debe estar instalado para realizar la conversión.
- El script debe tener permisos de ejecución (`chmod +x image_resize_convert.sh`).

---

## Funcionalidad
1. **Verifica** que el usuario ha proporcionado un directorio válido como argumento.
2. **Crea** un subdirectorio `original_images` dentro del directorio proporcionado para almacenar las imágenes originales.
3. **Mueve** todas las imágenes `.jpg` a la carpeta `original_images` antes de procesarlas.
4. **Redimensiona y convierte** cada imagen a formato `.png` con dimensiones de `1200x400` píxeles, asegurando que el contenido se centre correctamente.
5. **Guarda** las imágenes convertidas en el directorio de entrada con el mismo nombre pero con extensión `.png`.

---

## Ejemplo
Si el directorio `/home/user/images` contiene:
```
photo1.jpg
photo2.jpg
photo3.jpg
```
Ejecutando:
```bash
./image_resize_convert.sh /home/user/images
```
El resultado será:
```
/home/user/images/original_images/photo1.jpg
/home/user/images/original_images/photo2.jpg
/home/user/images/original_images/photo3.jpg
/home/user/images/photo1.png
/home/user/images/photo2.png
/home/user/images/photo3.png
```

---

## Notas
- Si el directorio de imágenes contiene otros formatos distintos a `.jpg`, estos no serán procesados.
- Se recomienda verificar que `ImageMagick` está instalado antes de ejecutar el script.
- El script preserva las imágenes originales en una carpeta separada para evitar la pérdida de datos.

---

## Script

```bash
#!/bin/bash

# Verificar que se proporcionó un directorio como argumento
if [ $# -ne 1 ]; then
    echo "Uso: $0 <directorio_de_imagenes>"
    exit 1
fi

# Obtener el directorio de imágenes
input_dir="$1"

# Verificar si el directorio existe
if [ ! -d "$input_dir" ]; then
    echo "El directorio '$input_dir' no existe."
    exit 1
fi

# Crear directorio para las imágenes originales dentro del directorio de entrada
mkdir -p "$input_dir/original_images"

# Mover las imágenes originales al directorio correspondiente
mv "$input_dir"/*.jpg "$input_dir/original_images/"

# Iterar sobre las imágenes originales
for file in "$input_dir/original_images"/*.jpg; do
    # Extraer el nombre del archivo sin la extensión
    filename=$(basename -- "$file")
    filename_no_extension="${filename%.*}"
    
    echo "Procesando: $file"
    # Redimensionar y convertir la imagen
    convert "$file" -resize 1200x400^ -gravity center -extent 1200x400 -density 96 -units pixelsperinch "$input_dir/${filename_no_extension}.png"
done

echo "Las imágenes originales se han mantenido en '$input_dir/original_images'."
echo "Las imágenes convertidas se encuentran en '$input_dir'."
```