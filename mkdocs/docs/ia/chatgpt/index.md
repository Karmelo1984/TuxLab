---
title: "ChatGPT y la API de OpenAI"
description: "Cómo aplicar las prácticas de prompting y evaluación recomendadas por OpenAI a ChatGPT y a su API."
---

# ChatGPT y la API de OpenAI

ChatGPT es el asistente conversacional de OpenAI. Esta página recoge solo lo que está respaldado por la documentación técnica oficial de la API; las funciones de producto de ChatGPT (proyectos, memoria, herramientas) cambian con frecuencia y se documentarán cuando puedan contrastarse con el centro de ayuda oficial.

## Cómo trabajar de forma sistemática

- Estructura las instrucciones en identidad, instrucciones, ejemplos y contexto; ver [Prompting](../fundamentos/prompting.md).
- Define criterios de éxito y prueba con casos representativos antes de reutilizar un prompt; ver [Evaluación](../fundamentos/evaluacion.md).
- Guarda los prompts reutilizables con la plantilla `templates/prompt.md`.

## Particularidades de la API

| Aspecto | Qué indica la documentación |
|---------|-----------------------------|
| Roles | `developer` tiene prioridad sobre `user` |
| Modelos de razonamiento | Funcionan bien con objetivos de alto nivel |
| Modelos GPT | Se benefician de instrucciones más explícitas |
| Producción | Fijar una versión (snapshot) del modelo para un comportamiento estable |
| Prompts reutilizables | La documentación indica que los objetos de prompt reutilizables de OpenAI se retiran; la guía recomienda guardar los prompts en el código de la aplicación |

La documentación también anuncia el cierre de la plataforma de Evals el 30 de noviembre de 2026; consulta las fechas vigentes en la fuente.

## Referencias

- [Prompt engineering (OpenAI)](https://developers.openai.com/api/docs/guides/prompt-engineering)
- [Evals (OpenAI)](https://developers.openai.com/api/docs/guides/evals)
