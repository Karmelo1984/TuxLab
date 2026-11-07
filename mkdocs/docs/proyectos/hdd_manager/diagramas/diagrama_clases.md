---
title: "Diagrama de Clases"
authors:
  - Carmelo Molero Castillo
date: 2025-03-25
version: 1.0.0
tags: [arquitectura, UML]
---

# 📌 Diagrama de Clases  

El siguiente diagrama de clases representa la estructura del sistema y las relaciones entre sus componentes principales.

```mermaid
classDiagram
    class Asociacion {
        +String nombre
        +String direccion
        +gestionarDirectiva()
        +gestionarSocios()
    }
    
    class Directiva {
        +String cargo
        +Date fechaInicio
        +Date fechaFin
        +asignarCargo()
    }
    
    class Socio {
        +String nombre
        +String email
        +pagarCuota()
    }

    class Evento {
        +String nombre
        +Date fecha
        +registrarAsistencia()
    }

    class Pago {
        +float monto
        +Date fecha
        +registrarPago()
    }

    Asociacion --> Directiva : tiene
    Asociacion --> Socio : tiene
    Socio --> Pago : realiza
    Socio --> Evento : asiste a
```
