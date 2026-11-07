---
title: "{{ title }}"
description: "Descripción breve del contenido."
---

# {{ title }}

Explica en una o dos frases qué hace el script, qué datos recibe, qué produce y en qué contexto se utiliza. Señala desde el principio si modifica o elimina información.

## Requisitos

| Elemento     | Requisito                              |
|--------------|----------------------------------------|
| Intérprete   | BASH O PYTHON Y VERSIÓN MÍNIMA         |
| Dependencias | COMANDOS O PAQUETES NECESARIOS         |
| Sistema      | PLATAFORMAS COMPATIBLES                |
| Permisos     | PERMISOS REALES DE LECTURA O ESCRITURA |

<!-- Omite filas que no apliquen. No repitas dependencias ya incluidas en el sistema base sin necesidad. -->

## Uso

```text
COMANDO_DE_EJECUCION [OPCIONES] ENTRADA
```

| Parámetro  | Obligatorio | Descripción                   |
|------------|-------------|-------------------------------|
| `--opcion` | Sí/No       | FINALIDAD Y VALORES ADMITIDOS |

Indica los valores por defecto, las restricciones de los argumentos y el comportamiento cuando faltan parámetros, si resulta pertinente.

## Ejemplo reproducible

Describe el estado inicial o proporciona un conjunto de datos mínimo con el que cualquiera pueda repetir el ejemplo sin modificar información importante.

```bash
COMANDO_REAL_CON_ARGUMENTOS_DE_PRUEBA
```

**Resultado esperado:** SALIDA, ARCHIVO GENERADO O CAMBIO VERIFICABLE.

## Comportamiento y errores

Describe brevemente el orden de ejecución, el tratamiento de entradas no válidas y los efectos secundarios relevantes.

| Situación          | Comportamiento                  |
|--------------------|---------------------------------|
| Ejecución correcta | RESULTADO Y CÓDIGO DE SALIDA    |
| Entrada inválida   | MENSAJE Y CÓDIGO DE SALIDA      |
| Error de ejecución | MENSAJE, EFECTOS Y RECUPERACIÓN |

<!-- Ajusta la tabla a errores realmente implementados. -->

## Código fuente

<!-- Cambia el lenguaje del bloque por bash, python u otro según corresponda. Incluye una sola versión canónica del script, completa y revisada. -->

```text
CODIGO_COMPLETO_DEL_SCRIPT
```

## Limitaciones

<!-- Elimina esta sección si no existen limitaciones conocidas. -->

Documenta las restricciones de compatibilidad, rendimiento, seguridad o alcance que hayan sido verificadas.
