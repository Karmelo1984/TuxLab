---
title: "Diagrama de Clases"
description: "Diagrama de clases con la estructura y las relaciones de los componentes de el proyecto de ejemplo. Contenido de ejemplo con marcadores de posición."
---

# Diagrama de Clases  

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

---

[Volver al índice del proyecto](../index.md)

---
