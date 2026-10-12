---
title: "speedtest_monitor.sh"
authors:
  - Carmelo Molero Castillo
date: 2025-03-21
version: 1.0.0
---

# speedtest_monitor

![Speed Test Internet](img/img-speed_test_internet-header-01.svg)

## Descripción
Este script realiza una prueba de velocidad de Internet utilizando `speedtest.net`.  
Obtiene la velocidad de descarga, subida y latencia (ping) desde un servidor de Speedtest y muestra los resultados en la terminal.

---

## Uso
```bash
./speedtest_monitor.sh
```
El script se ejecuta sin necesidad de parámetros y devuelve los resultados en Mbit/s para descarga y subida, y en milisegundos para el ping.

---

## Dependencias
- `curl`
- `grep`
- `tr`

---

## Requisitos
- Conexión a Internet activa.
- Acceso al sitio `speedtest.net`.

---

## Funcionalidad
1. **Descarga** la página de Speedtest y extrae la URL del test de velocidad.  
2. **Ejecuta** la prueba de velocidad accediendo a la URL extraída.  
3. **Filtra** los resultados obtenidos para extraer:  
    - Velocidad de descarga en Mbit/s.  
    - Velocidad de subida en Mbit/s.  
    - Ping en milisegundos.  
4. **Muestra** los resultados en la terminal.  


---

## Ejemplo
Ejecutando el script:
```bash
./speedtest_monitor.sh
```
Salida esperada (ejemplo):
```
Velocidad de descarga: 85.23 Mbit/s
Velocidad de subida: 12.47 Mbit/s
Ping: 20 ms
```

---

## Notas
- Este script depende de la estructura del sitio `speedtest.net`, por lo que puede dejar de funcionar si el sitio cambia su formato.
- La precisión de los resultados depende de la estabilidad de la conexión a Internet.
- Si el test no se ejecuta correctamente, revisar que `curl` esté instalado y que haya acceso al sitio de Speedtest.

---

## Script

```bash
#!/bin/bash

# URL del servidor Speedtest
speedtest_url="https://speedtest.net/speedtest"

# Descargar el script Speedtest y ejecutarlo
speedtest=$(curl -s $speedtest_url | grep -oP '(?<=href=")/speedtest/[^"]+')

# Extraer la URL de prueba de velocidad
test_url="https://speedtest.net${speedtest}"

# Realizar la prueba de velocidad y guardar la salida en un archivo temporal
speedtest_output=$(curl -s $test_url)

# Extraer los resultados de la velocidad de descarga, subida y ping
download_speed=$(echo "$speedtest_output" | grep -oP '(?<=Download: )[^<]+' | tr -d '[:space:]')
upload_speed=$(echo "$speedtest_output" | grep -oP '(?<=Upload: )[^<]+' | tr -d '[:space:]')
ping=$(echo "$speedtest_output" | grep -oP '(?<=Latency: )[^<]+' | tr -d '[:space:]')

# Mostrar los resultados
echo "Velocidad de descarga: $download_speed Mbit/s"
echo "Velocidad de subida: $upload_speed Mbit/s"
echo "Ping: $ping ms"

```