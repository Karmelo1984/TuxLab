---
title: "Claude Code"
description: "Qué mecanismos ofrece Claude Code para controlar su comportamiento y cuándo usar cada uno: CLAUDE.md, reglas, skills, hooks, MCP y subagentes."
---

# Claude Code

Claude Code es el agente de desarrollo de Anthropic que se ejecuta en la terminal y en otros entornos. Lee y modifica ficheros, ejecuta comandos y usa herramientas externas bajo un sistema de permisos.

La documentación oficial distingue varios mecanismos que no son intercambiables. Elegir el correcto evita instrucciones ignoradas y gasto innecesario de contexto.

## Cuándo usar cada mecanismo

| Necesidad | Mecanismo | Garantía |
|-----------|-----------|----------|
| Convención permanente del proyecto | [`CLAUDE.md` y reglas](contexto-reglas.md) | Orientativa: se carga como contexto |
| Procedimiento repetible bajo demanda | [Skill](skills.md) | Se carga al invocarse |
| Comprobación determinista automática | [Hook](hooks.md) | Se ejecuta siempre; puede bloquear |
| Acceso a herramientas o datos externos | [MCP](mcp.md) | Según permisos |
| Tarea aislada con contexto propio | [Subagente](subagentes.md) | Contexto independiente |
| Límite técnico de lo que puede hacer | [Permisos y seguridad](seguridad.md) | Aplicada por el sistema |

Una instrucción en `CLAUDE.md` no es un control de seguridad: el modelo puede no seguirla. Lo que debe cumplirse siempre se implementa con hooks o permisos.

## Páginas

- [Contexto y reglas](contexto-reglas.md)
- [Skills](skills.md)
- [Hooks](hooks.md)
- [MCP](mcp.md)
- [Subagentes](subagentes.md)
- [Seguridad y permisos](seguridad.md)
- [Optimización de contexto y costes](optimizacion.md)

## Compatibilidad

El contenido se ha contrastado con la documentación oficial en noviembre de 2026. Algunas funciones indican una versión mínima; por ejemplo, `/doctor prompt-audit` requiere la 2.1.283 o posterior. Comprueba tu versión con `claude --version`.

## Referencias

- [Documentación de Claude Code](https://code.claude.com/docs)
