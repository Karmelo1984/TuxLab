---
title: "Diagrama Entidad-Relación (DER)"
description: "Diagrama entidad-relación con las entidades de la base de datos de Gestor de Asociaciones."
---

# 📌 Diagrama Entidad-Relación (DER)

Este diagrama muestra la estructura de la base de datos y cómo las entidades están relacionadas.

```mermaid
erDiagram
    ASOCIACION {
        int id PK
        string nombre
        string direccion
    }
    
    DIRECTIVA {
        int id PK
        int asociacion_id FK
        string cargo
        date fecha_inicio
        date fecha_fin
    }
    
    SOCIO {
        int id PK
        int asociacion_id FK
        string nombre
        string email
    }

    EVENTO {
        int id PK
        int asociacion_id FK
        string nombre
        date fecha
    }

    PAGO {
        int id PK
        int socio_id FK
        float monto
        date fecha
    }

    ASOCIACION ||--o{ DIRECTIVA : tiene
    ASOCIACION ||--o{ SOCIO : tiene
    SOCIO ||--o{ PAGO : realiza
    SOCIO ||--o{ EVENTO : asiste_a
```
