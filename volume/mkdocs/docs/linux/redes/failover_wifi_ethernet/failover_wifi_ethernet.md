---
title: "Failover Wi-Fi/Ethernet en Linux"
authors:
  - Carmelo Molero Castillo
date: 2025-11-29
version: 1.0.0
---

# Failover Wi-Fi/Ethernet en Linux

![Failover Wi-Fi / Ethernet](img/img-fwe-header-02.svg)

**Descripción**:  
Guía técnica completa para configurar dos equipos Linux con comunicación local a través de Ethernet (LAN 192.168.50.0/24) y Wi-Fi como ruta principal hacia Internet.  
Incluye configuración con NetworkManager y Netplan, explicación de métricas de rutas, failover automático y herramientas de verificación de conectividad y velocidad (ping, SSH, iperf3).

---

## Instalación

No se requiere instalar software adicional más allá de:

- NetworkManager (ya incluido en Linux Mint).
- Netplan + systemd-networkd (incluidos en Ubuntu Lite).
- `openssh-server` si se desea acceso SSH entre equipos.
- `iperf3` para validación de velocidad.

---

### Requisitos previos

- Dos equipos Linux (ejemplo: Linux Mint y Ubuntu Lite).
- Cable Ethernet Cat5e/Cat6/Cat6e certificado.
- Acceso sudo en ambos equipos.
- Conexión Wi-Fi operativa en ambos PCs.
- Conocimientos básicos de edición YAML (para Netplan).

---

### Instalación en Linux

No hay paquetes específicos salvo `iperf3` (opcional para pruebas):

```bash
sudo apt install iperf3
```

---

## Uso de la red (visión general)

El objetivo es una arquitectura de doble interfaz:

```txt
                                               ┌─────────────────────────────────┐
                                               │           ROUTER Wi-Fi          │
                                               │          192.168.1.1/24         │
                                               └───────────────┬─────────────────┘
                                                               │
                                     ┌─────────────────────────┼─────────────────────────┐
                                     │                                                   │
                                     │                                                   │
                                     │                                                   │
                                     ▼                                                   ▼
                           ┌──────────────────┐                                 ┌──────────────────┐
                           │     PC A (Mint)  │                                 │  PC B (Ubuntu)   │
                           │──────────────────│                                 │──────────────────│
                           │ wlo1 (Wi-Fi)     │                                 │ wlp2s0 (Wi-Fi)   │
                           │ 192.168.1.142/24 │                                 │ 192.168.1.140/24 │
                           │ default → router │                                 │ default → router │
                           └─────────┬────────┘                                 └─────────┬────────┘
                                     │                                                    │
                                     │   Ethernet LAN 192.168.50.0/24 (alta velocidad)    │
                                     │                     1 Gbps                         │
                                     └────────────────────────┬───────────────────────────┘
                                                              │
                                                              ▼
                                                  ┌─────────────────────────┐
                                                  │   nlace punto a punto   │
                                                  │   C A ↔ PC B            │
                                                  │   92.168.50.1 ↔ .50.2   │
                                                  └─────────────────────────┘
                    
                    
                                             ╔══════════════════════════════════╗
                                             ║      COMPORTAMIENTO FINAL        ║
                                             ╠══════════════════════════════════╣
                                             ║ • Internet → SIEMPRE por Wi-Fi   ║
                                             ║ • LAN local → SIEMPRE por cable  ║
                                             ║ • Si cae Wi-Fi → LAN activa      ║
                                             ║ • Si vuelve Wi-Fi → ruta vuelve  ║
                                             ╚══════════════════════════════════╝

```

---

## Configuración Básica

### Linux Mint (NetworkManager)

#### 1. Identificar interfaces:

```bash
nmcli device
nmcli con show
```

Ejemplo de conexiones:

* Ethernet → `enp86s0` (perfil: `"Conexión cableada 1"`)
* Wi-Fi → `wlo1` (perfil: `"MIWIFI_pE5u"`)

---

#### 2. Establecer prioridad del Wi-Fi

```bash
sudo nmcli con mod "MIWIFI_pE5u" ipv4.route-metric 100
sudo nmcli con up "MIWIFI_pE5u"
```

---

#### 3. Configurar Ethernet con IP estática

```bash
sudo nmcli con mod "Conexión cableada 1" ipv4.addresses 192.168.50.1/24
sudo nmcli con mod "Conexión cableada 1" ipv4.method manual
sudo nmcli con mod "Conexión cableada 1" ipv4.never-default yes
sudo nmcli con mod "Conexión cableada 1" ipv4.route-metric 600
sudo nmcli con up "Conexión cableada 1"
```

---

#### 4. Validación en Mint

```bash
ip route
```

Salida esperada:

```
default via 192.168.1.1 dev wlo1 metric 100
192.168.50.0/24 dev enp86s0 metric 600
```

---

### Ubuntu Lite (Netplan + systemd-networkd)

#### 1. Identificar interfaces

```bash
networkctl
```

Ejemplo:

* Ethernet: `enp1s0`
* Wi-Fi: `wlp2s0`

---

#### 2. Wi-Fi (ya configurado previamente)

Mantener configuración existente del acceso a Internet.

---

#### 3. Configurar Ethernet con IP fija

Archivo `/etc/netplan/01-netcfg.yaml`:

```yaml
network:
  version: 2
  renderer: networkd

  wifis:
    wlp2s0:
      dhcp4: false
      addresses:
        - 192.168.1.140/24
      routes:
        - to: 0.0.0.0/0
          via: 192.168.1.1
      nameservers:
        addresses:
          - 8.8.8.8
          - 1.1.1.1
      access-points:
        "MIWIFI_pE5u":
          auth:
            key-management: "psk"
            password: "PASSWORD"

  ethernets:
    enp1s0:
      dhcp4: false
      addresses:
        - 192.168.50.2/24
      link-local: []
      routes: []
```

Aplicar:

```bash
sudo netplan apply
```

---

#### 4. Validación

```bash
ip route
```

Salida esperada:

```
default via 192.168.1.1 dev wlp2s0
192.168.50.0/24 dev enp1s0
```

---

## Configuración Avanzada

# Verificación de Conectividad (Ping y SSH)

### 1. Probar conectividad por Ethernet

Mint → Ubuntu Lite:

```bash
ping 192.168.50.2
```

Ubuntu Lite → Mint:

```bash
ping 192.168.50.1
```

Latencia esperada:

* **< 0.3 ms** y **0% pérdidas**

### 2. Verificar acceso SSH

```bash
ssh mediauser@192.168.50.2
ssh carmelo@192.168.50.1
```

---

# Verificación de Velocidad Real (iperf3)

### 1. Instalar iperf3

```bash
sudo apt install iperf3
```

### 2. Iniciar servidor iperf3

```bash
iperf3 -s
```

### 3. Cliente iperf3 – Wi-Fi

```bash
iperf3 -c 192.168.1.140
```

Resultado típico:

```
≈ 270 Mbits/sec
```

### 4. Cliente iperf3 – Ethernet

```bash
iperf3 -c 192.168.50.2
```

Resultado típico:

```
≈ 940–950 Mbits/sec
```

Interpretación:

* El valor se acerca al límite real de Gigabit Ethernet.

---

# Diagnóstico del Cable (ethtool)

### Comprobar velocidad negociada

Mint:

```bash
sudo ethtool enp86s0 | grep -i speed
```

Ubuntu Lite:

```bash
sudo ethtool enp1s0 | grep -i speed
```

* Correcto → `Speed: 1000Mb/s`
* Incorrecto → `Speed: 100Mb/s`

Si aparece 100Mb/s:

* Par interno roto
* Conector RJ45 defectuoso
* Cable viejo o doblado
* Adaptadores intermedios

**Solución:** cambiar el cable por Cat5e/Cat6 certificado.

---

# Comparativa Real Wi-Fi vs Ethernet

| Medio        | Velocidad (iperf3) | Velocidad real | Estabilidad | Latencia |
| ------------ | ------------------ | -------------- | ----------- | -------- |
| **Wi-Fi**    | ~270 Mbit/s        | ~34 MB/s       | Media       | 2–10 ms  |
| **Ethernet** | ~943 Mbit/s        | ~118 MB/s      | Muy alta    | < 0.3 ms |

**Conclusión:** Ethernet Gigabit es ~3,5 veces más rápido y muy superior en estabilidad y latencia.

---

## Solución de Problemas

**Error: No hay conectividad entre PCs por Ethernet**
🔹 Verificar cable, conectores y estado del enlace (`ethtool`).
🔹 Revisar IPs estáticas.
🔹 Probar `ping 192.168.50.X`.

**Error: El PC usa Ethernet para Internet**
🔹 En Mint: `ipv4.never-default yes`.
🔹 En Ubuntu Lite: eliminar gateways en `enp1s0`.

**Error: El Wi-Fi no es la ruta principal**
🔹 Revisar métricas de rutas:

```bash
ip route
```

**Error: Velocidad limitada a 100Mbit/s**
🔹 Cable defectuoso o sin 4 pares funcionales.
🔹 Sustituir cable y verificar con `ethtool`.

---

