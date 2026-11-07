---
title: "Tokens, contexto y memoria"
description: "Qué son los tokens y la ventana de contexto, cómo afectan al coste y por qué contexto y memoria persistente no son lo mismo."
---

# Tokens, contexto y memoria

## Tokens

Un token es la unidad en la que el modelo procesa el texto: puede ser una palabra, parte de una palabra, un signo o un espacio. La tokenización depende del modelo, por lo que el mismo texto produce un número de tokens distinto según el proveedor. Como orden de magnitud, el español consume más tokens por palabra que el inglés.

El uso de tokens determina el coste y los límites: se contabilizan tanto los de entrada como los de salida, y los proveedores suelen tarificarlos de forma distinta.

## Ventana de contexto

La ventana de contexto es el máximo de tokens que el modelo puede considerar en una petición, sumando instrucciones, historial, documentos adjuntos, resultados de herramientas y la respuesta generada.

- Si la conversación supera el límite, hay que recortar, resumir o descartar contenido; el modelo no puede usar lo que no está en la ventana.
- Un contexto más largo no garantiza que toda la información se use con la misma fiabilidad. Conviene colocar lo importante de forma clara y evitar material irrelevante.
- Cada mensaje nuevo reenvía el contexto acumulado, por lo que las conversaciones largas son más caras y lentas.

## Contexto frente a memoria persistente

| Concepto | Qué es | Dónde vive |
|----------|--------|------------|
| Contexto | Texto presente en la petición actual | Se reconstruye en cada petición |
| Memoria persistente | Información guardada por la aplicación para sesiones futuras | Fuera del modelo, en ficheros o en un servicio |

El modelo no aprende durante la conversación. Cuando una herramienta "recuerda" algo entre sesiones, lo hace guardando texto y reinyectándolo en el contexto. Un ejemplo documentado es el fichero `CLAUDE.md` de Claude Code; ver [Contexto y reglas](../claude/claude-code/contexto-reglas.md).

## Parámetros de generación

Algunas interfaces y APIs permiten ajustar el muestreo, por ejemplo la temperatura o `top_p`. Valores bajos hacen la salida más determinista y valores altos la hacen más variada. Ni siquiera con temperatura baja se garantiza una respuesta idéntica, por lo que no sustituyen a la [evaluación](evaluacion.md). La disponibilidad de estos parámetros depende del modelo; consulta la documentación del proveedor.
