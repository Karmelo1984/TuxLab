---
title: "Evaluación de resultados"
description: "Cómo comprobar de forma objetiva y reproducible la calidad de las respuestas de un modelo antes de confiar en un prompt."
---

# Evaluación de resultados

Una respuesta que parece correcta no es una respuesta verificada. Evaluar consiste en definir criterios de éxito y comprobarlos con casos representativos, no con una única prueba favorable.

## Procedimiento

1. Describir la tarea y el criterio de aceptación (exactitud, formato, cobertura).
2. Reunir casos de prueba que incluyan casos habituales y casos límite.
3. Ejecutar el prompt sobre todos los casos.
4. Puntuar los resultados con comprobaciones automáticas o con revisión humana.
5. Repetir tras cada cambio de prompt o de modelo para detectar regresiones.

Esta es la secuencia que describe la guía de evaluaciones de OpenAI: describir la tarea, ejecutarla con entradas de prueba y analizar los resultados para iterar.

## Criterios útiles

| Criterio | Pregunta |
|----------|----------|
| Exactitud | ¿Los datos y el código son correctos? |
| Cobertura | ¿Se cubren todos los casos pedidos? |
| Formato | ¿Cumple la estructura exigida? |
| Reproducibilidad | ¿Un cambio de modelo o de ejecución altera el resultado? |
| Regresión | ¿Lo que funcionaba sigue funcionando? |

Para código, la validación más fiable es ejecutar pruebas. Para texto, es preferible una lista de comprobación objetiva a una impresión general.

## Nota sobre la plataforma de OpenAI

La documentación de OpenAI indica que su plataforma de Evals será de solo lectura el 31 de octubre de 2026 y dejará de funcionar el 30 de noviembre de 2026. El método descrito aquí no depende de ella y puede aplicarse con scripts propios.

## Referencias

- [Evals (OpenAI)](https://developers.openai.com/api/docs/guides/evals)
