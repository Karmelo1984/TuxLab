---
title: "Diagrama de Clases"
description: "Diagrama de clases con la estructura y las relaciones de los componentes de License Manager."
---

# Diagrama de Clases  

El siguiente diagrama de clases representa la estructura del sistema y las relaciones entre sus componentes principales.

```mermaid
classDiagram
    class License {
        +UUID license_id
        +DATE activation_date
        +DATE expiration_date
        +INT max_active_members
        +INT price
    }

    class Company {
        +CHAR(9) CIF
        +TEXT razon_social
        +TEXT cod_electronico
        +DATE date_creation
        +TEXT email
    }

    class Feature {
        +CHAR(9) name
        +DATE date_create
        +BOOLEAN is_basic
    }

    License "1" --> "0..*" Feature : includes
    Company "1" --> "0..*" License : owns
```

---

[Volver al índice del proyecto](../index.md)

---
