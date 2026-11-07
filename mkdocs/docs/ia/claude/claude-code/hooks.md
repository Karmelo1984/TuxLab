---
title: "Hooks"
description: "Cómo configurar hooks en Claude Code para ejecutar comprobaciones deterministas, con eventos, matchers, códigos de salida y un ejemplo."
---

# Hooks

Un hook es una acción que Claude Code ejecuta automáticamente cuando ocurre un evento, como antes de usar una herramienta o al terminar una respuesta. A diferencia de una instrucción en `CLAUDE.md`, lo ejecuta el sistema y no depende de que el modelo la recuerde.

## Dónde se configuran

| Fichero | Alcance |
|---------|---------|
| `~/.claude/settings.json` | Todos los proyectos |
| `.claude/settings.json` | Un proyecto, compartible |
| `.claude/settings.local.json` | Un proyecto, no versionado |

También pueden definirse en plugins, en la cabecera de una skill o en la de un subagente. El comando `/hooks` abre el explorador de hooks.

## Eventos

La documentación enumera decenas de eventos. Los más utilizados:

| Evento | Momento |
|--------|---------|
| `SessionStart` | Al iniciar o reanudar una sesión |
| `UserPromptSubmit` | Al enviar un prompt |
| `PreToolUse` | Antes de ejecutar una herramienta; puede bloquearla |
| `PostToolUse` | Después de ejecutar una herramienta |
| `Stop` | Cuando Claude termina de responder |
| `PreCompact` | Antes de compactar el contexto |

La lista completa y vigente está en la referencia oficial.

## Matchers y tipos

El campo `matcher` filtra por nombre de herramienta: `Edit|Write` admite una lista exacta; cualquier otro carácter lo convierte en una expresión regular. Las herramientas MCP se nombran `mcp__<servidor>__<herramienta>`. Un nombre de servidor solo no coincide con nada: usa `mcp__servidor__.*`.

Tipos de manejador: `command`, `http`, `mcp_tool`, `prompt` y `agent`. El campo `if` permite acotar con sintaxis de reglas de permisos, por ejemplo `Bash(git *)`.

## Entrada y códigos de salida

El hook recibe un JSON por la entrada estándar con, entre otros, `session_id`, `cwd`, `hook_event_name`, `tool_name` y `tool_input`. Para `Bash`, el comando está en `tool_input.command`.

| Código | Efecto |
|--------|--------|
| `0` | Sin decisión; la herramienta sigue el flujo normal de permisos |
| `2` | Bloqueo; el mensaje de `stderr` se muestra a Claude. En `PostToolUse` la herramienta ya se ejecutó |
| Otro | Error no bloqueante; la acción continúa |

Los hooks se ejecutan en paralelo y, si hay decisiones contradictorias, prevalece la más restrictiva.

## Ejemplo: bloquear un comando

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          { "type": "command", "command": ".claude/hooks/bloquear-rm.sh" }
        ]
      }
    ]
  }
}
```

```bash
#!/usr/bin/env bash
cmd=$(jq -r '.tool_input.command')
if [[ "$cmd" == *"rm -rf"* ]]; then
  echo "Bloqueado: rm -rf no está permitido" >&2
  exit 2
fi
```

Este script necesita `jq` y debe tener permiso de ejecución. Comprueba que funciona pidiendo a Claude que ejecute un `rm -rf` sobre un directorio de prueba.

## Cuándo usar un hook

Úsalo para validaciones que deben ejecutarse siempre: formatear tras editar, impedir comandos peligrosos o ejecutar pruebas al terminar. Para un procedimiento que Claude aplica con criterio, usa una [skill](skills.md).

## Referencias

- [Referencia de hooks](https://code.claude.com/docs/en/hooks)
- [Guía de hooks](https://code.claude.com/docs/en/hooks-guide)
