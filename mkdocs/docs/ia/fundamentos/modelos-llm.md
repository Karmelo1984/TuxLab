---
title: "Modelos de lenguaje (LLM)"
description: "Qué es un modelo de lenguaje, cómo se basa en la arquitectura Transformer y qué diferencia el entrenamiento de la inferencia."
---

# Modelos de lenguaje (LLM)

Un modelo de lenguaje de gran tamaño (LLM, *Large Language Model*) es una red neuronal entrenada para predecir el siguiente token de una secuencia de texto. Esa única tarea, aplicada a enormes cantidades de texto, produce modelos capaces de redactar, resumir, traducir, clasificar o escribir código.

## Arquitectura Transformer

Los LLM actuales se basan en la arquitectura Transformer, presentada en el artículo *Attention Is All You Need* (Vaswani et al., 2017). Su componente central es el mecanismo de atención, que permite al modelo ponderar la relevancia de cada token de la entrada al procesar cada uno de los demás, sin recorrer el texto de forma estrictamente secuencial.

Los modelos generativos de texto suelen usar la variante de solo decodificador: leen los tokens anteriores y calculan una distribución de probabilidad sobre el siguiente.

## Entrenamiento e inferencia

| Fase | Qué ocurre | Consecuencia práctica |
|------|------------|-----------------------|
| Preentrenamiento | El modelo ajusta sus parámetros prediciendo tokens sobre un gran corpus de texto | Fija el conocimiento general y la fecha de corte |
| Ajuste posterior | Se refina con ejemplos de instrucciones y con retroalimentación humana o automática | Hace que el modelo siga instrucciones y adopte un estilo |
| Inferencia | Con los parámetros ya fijos, el modelo genera la respuesta token a token | Es la fase en la que se paga por uso y no aprende de la conversación |

Durante la inferencia los parámetros no cambian. Lo que el modelo "recuerda" de una conversación es únicamente el texto que se le vuelve a enviar en cada petición; ver [Tokens y contexto](tokens-contexto.md).

## Implicaciones

- El modelo genera texto plausible según patrones aprendidos, no consulta una base de hechos verificados. Esto explica las alucinaciones tratadas en [Seguridad y limitaciones](seguridad.md).
- Su conocimiento termina en la fecha de corte del entrenamiento, salvo que se le proporcione información actual mediante herramientas o [RAG](rag-agentes.md).
- Dos ejecuciones con la misma entrada pueden producir respuestas distintas, porque la generación incorpora muestreo.

## Referencias

- [Attention Is All You Need (arXiv:1706.03762)](https://arxiv.org/abs/1706.03762)
