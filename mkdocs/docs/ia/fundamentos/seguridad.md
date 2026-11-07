---
title: "Seguridad y limitaciones"
description: "Riesgos de usar modelos de lenguaje: prompt injection, exposición de secretos, permisos excesivos, alucinaciones y sesgos."
---

# Seguridad y limitaciones

## Prompt injection

Un modelo no distingue de forma fiable entre las instrucciones del usuario y las instrucciones escondidas en el contenido que procesa: una página web, un documento o un resultado de herramienta. Si ese contenido contiene órdenes, el modelo puede seguirlas.

Medidas:

- Tratar todo contenido externo como datos, no como instrucciones.
- Limitar las herramientas disponibles a lo imprescindible.
- Exigir confirmación humana antes de acciones irreversibles.

## Secretos

Lo que se envía al modelo sale del equipo. No incluyas contraseñas, tokens ni claves privadas en prompts, ficheros de contexto o repositorios que el asistente pueda leer. Usa variables de entorno y reglas que impidan leer ficheros sensibles; en Claude Code, ver [Seguridad y permisos](../claude/claude-code/seguridad.md).

## Permisos

Un agente con acceso al sistema de ficheros o a comandos puede causar daño por error o por inyección. Aplica el principio de mínimo privilegio y prefiere controles técnicos (permisos, sandbox, hooks) a instrucciones en lenguaje natural, que el modelo puede ignorar.

## Alucinaciones, incertidumbre y sesgos

- Alucinación: el modelo genera datos plausibles pero falsos, como funciones inexistentes o citas inventadas.
- Incertidumbre: el modelo puede expresar seguridad sin tenerla.
- Sesgos: reflejan los del corpus de entrenamiento.

Verifica siempre lo importante con la documentación oficial o ejecutando el código, y aplica la [evaluación](evaluacion.md).
