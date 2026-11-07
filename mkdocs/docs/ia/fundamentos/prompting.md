---
title: "Prompting"
description: "Cómo estructurar un prompt con identidad, instrucciones, ejemplos y contexto, y qué prácticas recomienda OpenAI."
---

# Prompting

Un prompt es la entrada que recibe el modelo. La calidad de la respuesta depende sobre todo de cuánta información relevante e inequívoca contiene.

## Estructura recomendada

La guía de OpenAI propone organizar el mensaje de desarrollador en cuatro bloques:

1. **Identidad:** propósito, tono y rol del asistente.
2. **Instrucciones:** reglas y restricciones que debe respetar.
3. **Ejemplos:** pares de entrada y salida esperada.
4. **Contexto:** datos adicionales; suele funcionar mejor al final.

Se recomienda delimitar secciones y datos con encabezados Markdown, listas y etiquetas XML.

## Prácticas

| Práctica | Motivo |
|----------|--------|
| Definir la tarea y el formato de salida | Reduce ambigüedad y facilita validar el resultado |
| Dar ejemplos variados (few-shot) | Fija el patrón esperado |
| Ser explícito con los modelos GPT | La guía indica que se benefician de instrucciones más detalladas |
| Dar objetivos de alto nivel a los modelos de razonamiento | Según la guía, resuelven bien tareas complejas con indicaciones generales |
| Colocar el contenido reutilizable al principio | Favorece la caché de prompts |
| Fijar versiones concretas del modelo en producción | Mantiene un comportamiento estable |
| Medir con casos de prueba | Un prompt solo se puede mejorar si se evalúa; ver [Evaluación](evaluacion.md) |

## Roles de mensaje (API de OpenAI)

| Rol | Prioridad |
|-----|-----------|
| `developer` | Instrucciones de la aplicación; tienen prioridad sobre `user` |
| `user` | Instrucciones del usuario final |
| `assistant` | Respuestas generadas por el modelo |

## Plantilla

Para guardar prompts reutilizables con su validación y limitaciones, usa la plantilla `templates/prompt.md` del repositorio.

## Referencias

- [Prompt engineering (OpenAI)](https://developers.openai.com/api/docs/guides/prompt-engineering)
