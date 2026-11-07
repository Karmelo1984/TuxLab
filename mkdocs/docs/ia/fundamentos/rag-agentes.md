---
title: "RAG, embeddings y agentes"
description: "Cómo aportar información externa a un modelo mediante embeddings y RAG, y qué cambia cuando el modelo usa herramientas como agente."
---

# RAG, embeddings y agentes

## Embeddings

Un embedding es un vector numérico que representa el significado de un texto. Textos con significado parecido producen vectores cercanos, lo que permite realizar búsqueda semántica: encontrar fragmentos relacionados con una consulta aunque no compartan las mismas palabras.

## RAG

La generación aumentada por recuperación (RAG, *Retrieval-Augmented Generation*) añade al prompt información recuperada de una fuente externa antes de que el modelo responda.

1. Los documentos se dividen en fragmentos y se calculan sus embeddings.
2. Ante una consulta, se buscan los fragmentos más cercanos.
3. Esos fragmentos se insertan en el contexto junto a la pregunta.
4. El modelo responde apoyándose en ellos.

RAG permite usar información actual o privada sin reentrenar el modelo. Su calidad depende de la recuperación: si no se encuentran los fragmentos correctos, el modelo responde sin ellos o con datos erróneos. Los fragmentos recuperados consumen ventana de contexto; ver [Tokens y contexto](tokens-contexto.md).

## Herramientas y agentes

Una herramienta es una función que el modelo puede solicitar: buscar en la web, leer un fichero, ejecutar un comando o consultar una API. La aplicación ejecuta la herramienta y devuelve el resultado al modelo.

Un agente encadena ese ciclo: el modelo decide una acción, recibe el resultado, y repite hasta completar la tarea. Esto lo hace más capaz y también más arriesgado, porque actúa sobre sistemas reales; ver [Seguridad y limitaciones](seguridad.md). Claude Code es un ejemplo de agente de desarrollo; ver [Claude Code](../claude/claude-code/index.md).

El protocolo MCP estandariza cómo se conectan herramientas externas a un modelo; ver [MCP](../claude/claude-code/mcp.md).
