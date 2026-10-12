---
title: "smart_monitor.sh"
authors:
  - Carmelo Molero Castillo
date: 2025-03-21
version: 1.0.0
---

# smart_monitor

![Smart Monitor](img/img-smart_monitor-header-01.svg)

## Descripción
Este script monitorea el estado SMART de los discos conectados al sistema, evaluando métricas críticas como sectores reasignados, temperatura y errores de lectura.  
Si se superan ciertos umbrales predefinidos, se genera una alerta en la salida estándar.  

---

## Uso
```bash
./smart_monitor.sh
```
El script no requiere parámetros y se ejecuta con privilegios de superusuario para acceder a la información SMART de los discos.

---

## Dependencias
- `smartctl` (parte del paquete `smartmontools`)
- `lsblk`
- `awk`
- `grep`
- `tr`
- `printf`
- `date`

---

## Requisitos
- Ejecutar el script con permisos de superusuario (`sudo`).
- Tener instaladas las herramientas `smartmontools` y `util-linux`.
- Discos compatibles con SMART habilitado.

---

## Funcionalidad
1. **Identifica** todos los discos conectados mediante `lsblk`.
2. **Obtiene** el número de serie de cada disco y lo asocia a un nombre predefinido.
3. **Ejecuta** `smartctl` para extraer métricas SMART relevantes.
4. **Compara** los valores obtenidos con umbrales definidos para cada atributo.
5. **Genera alertas** si algún valor supera su umbral.
6. **Muestra un resumen** indicando si todas las métricas están dentro de los límites aceptables.

---

## Ejemplo
Ejecutando el script en un sistema con varios discos conectados:
```bash
sudo ./smart_monitor.sh
```
Salida esperada (ejemplo):
```
[2025-03-21 14:30:00] Métricas para --> lib_01
[2025-03-21 14:30:00] [ WARNING ] [SN: 575855314535393732504152, DISK: /dev/sdb, NAME: lib_01] Reallocated_Sector_Ct umbral superado (10 > 0)
[2025-03-21 14:30:00] [ OK ] [SN: 575855314535393732504152, DISK: /dev/sdb, NAME: lib_01] Temperature_Celsius umbral correcto (40 <= 45)
[2025-03-21 14:30:00] [ INFO ] [SN: 575855314535393732504152, DISK: /dev/sdb, NAME: lib_01] Todas las métricas CORRECTAS.
```
Esto indica que el disco `lib_01` tiene sectores reasignados fuera del umbral pero su temperatura está dentro del límite aceptable.

---

## Notas
- Los umbrales pueden ajustarse modificando el array `THRESHOLDS` en el script.
- Se recomienda revisar periódicamente los valores SMART y reemplazar discos con errores críticos.
- La ejecución sin `sudo` puede impedir la obtención de datos SMART.

---

## Script

```bash
#!/bin/bash

# Rutas a los logs
# LOG_FILE="./smart_monitor.log"
# ALERT_FILE="./smart_alert.log"

# Especificar el carácter de relleno (en este caso, 'X')
FILL_CHARACTER=" "

# Atributos SMART a monitorear y sus umbrales
ATTRIBUTES=("Reallocated_Sector_Ct" "Current_Pending_Sector" "Offline_Uncorrectable" "Reallocated_Event_Count" "Seek_Error_Rate" "Temperature_Celsius" "Power_On_Hours")
THRESHOLDS=(0 1 1 1 100 45 20000)  # Ajusta los valores de umbral según tus necesidades

# Array asociativo para relacionar el número de serie con un nombre
declare -A SERIAL_TO_NAME
SERIAL_TO_NAME["WX51A97JKCT0"]="storage"

SERIAL_TO_NAME["Y2Q6TT3YT"]="uni"
SERIAL_TO_NAME["57583931453133455A433934"]="trabajo_car"

SERIAL_TO_NAME["575855314535393732504152"]="lib_01"
SERIAL_TO_NAME["575854314535393830483056"]="lib_02"
SERIAL_TO_NAME["57585531453539375758575A"]="lib_03"

SERIAL_TO_NAME["57585332443533384556555A"]="bkl_01"
SERIAL_TO_NAME["5758353244363330374A5437"]="bkl_02"
SERIAL_TO_NAME["57584C324435334644314B50"]="bkl_03"

SERIAL_TO_NAME["575833324437313752485630"]="lib_31"
SERIAL_TO_NAME["5758353245373037444D414A"]="lib_32"
SERIAL_TO_NAME["575831314536394657444459"]="int_01"
# SERIAL_TO_NAME[""]="lib_33"

SERIAL_TO_NAME["575851324435334856453559"]="bkl_31"
SERIAL_TO_NAME["575853324435333437414E41"]="bkl_32"
SERIAL_TO_NAME["575838324438314C32594144"]="int_02"
# SERIAL_TO_NAME[""]="bkl_33"


# Función para rellenar un string con un carácter dado
# Ejemplo: padded_string=$(fill_string "123" 8 "X")  # Resultado: "XXXXX123"
fill_string() {
    local input_string=$1
    local target_length=$2
    local fill_character=$3

    # Calcular la longitud del string de entrada
    local input_length=${#input_string}

	local padded_string=$(printf "%-${target_length}s" "$input_string" | tr ' ' "$fill_character")

    echo "$padded_string"
}


MSG_INFO="[ $(fill_string "INFO" 7 "$FILL_CHARACTER") ]"
MSG_DEBUG="[ $(fill_string "DEBUG" 7 "$FILL_CHARACTER") ]"
MSG_WARNING="[ $(fill_string "WARNING" 7 "$FILL_CHARACTER") ]"
MSG_OK="[ $(fill_string "OK" 7 "$FILL_CHARACTER") ]"

# Obtener una lista de todas las unidades
DISKS=($(lsblk -o NAME -n -l -p -I 8,9 | grep -E 'sd[a-z]$'))

# Iterar sobre cada unidad
for DISK_PATH in "${DISKS[@]}"; do
    # Obtener la fecha y hora actual
    DATE=$(date +"[%Y-%m-%d %H:%M:%S]")

    # Comando para obtener información SMART
    SMART_CMD="sudo smartctl -A $DISK_PATH"
    
	# Obtener el número de serie de la unidad
    SERIAL_NUMBER=$(lsblk -o NAME,SERIAL -n -l $DISK_PATH | awk '{print $2}')

    # Obtener el nombre asociado al número de serie
    HDD_NAME=${SERIAL_TO_NAME["$SERIAL_NUMBER"]}
	HDD_NAME=$(fill_string "$HDD_NAME" 7 "$FILL_CHARACTER")

	echo "$DATE Métricas para --> $HDD_NAME"
	
	#Normalizar el string con el número de serie 
	SERIAL_NUMBER=$(fill_string "$SERIAL_NUMBER" 24 "$FILL_CHARACTER")

    # Obtener información SMART y filtrar solo las líneas relevantes
    SMART_DATA=$($SMART_CMD | grep -E "$(IFS=\|; echo "${ATTRIBUTES[*]}")")

    # Verificar los umbrales y registrar alertas
    error_found=false

    for ((i=0; i<${#ATTRIBUTES[@]}; i++)); do
        ATTRIBUTE=${ATTRIBUTES[i]}
        THRESHOLD=${THRESHOLDS[i]}
        VALUE=$(echo "$SMART_DATA" | grep "$ATTRIBUTE" | awk '{print $10}')
		
		ATTRIBUTE=$(fill_string "$ATTRIBUTE" 25 "$FILL_CHARACTER")

        # Verificar que VALUE sea un número antes de la comparación numérica
        if [[ "$VALUE" =~ ^[0-9]+$ ]]; then
            if [ "$VALUE" -gt "$THRESHOLD" ]; then
                echo "$DATE $MSG_WARNING [SN: $SERIAL_NUMBER, DISK: $DISK_PATH, NAME: $HDD_NAME] $ATTRIBUTE umbral superado (${VALUE} > ${THRESHOLD})"
                error_found=true
            else
                echo "$DATE $MSG_OK [SN: $SERIAL_NUMBER, DISK: $DISK_PATH, NAME: $HDD_NAME] $ATTRIBUTE umbral correcto (${VALUE} <= ${THRESHOLD})"
            fi
        else
            echo "$DATE $MSG_DEBUG [SN: $SERIAL_NUMBER, DISK: $DISK_PATH, NAME: $HDD_NAME] $ATTRIBUTE: No se pudo obtener el valor."
        fi
    done

    # Mostrar mensaje "OK" si no se encontraron errores
    if [ "$error_found" = false ]; then
        echo "$DATE $MSG_INFO [SN: $SERIAL_NUMBER, DISK: $DISK_PATH, NAME: $HDD_NAME] Todas las métricas CORRECTAS."
    fi
    echo ""
done

```