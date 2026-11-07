---
title: "Seguridad y permisos"
description: "Cómo controlar con permisos, modos y sandbox lo que Claude Code puede leer, escribir y ejecutar, y qué no garantizan las instrucciones."
---

# Seguridad y permisos

Los controles de seguridad de Claude Code se dividen en dos tipos. Las reglas de comportamiento (`CLAUDE.md`, ver [Contexto y reglas](contexto-reglas.md)) orientan al modelo pero pueden no cumplirse. Los controles técnicos (permisos, sandbox y [hooks](hooks.md)) los aplica el sistema.

## Reglas de permisos

Una regla tiene la forma `Herramienta` o `Herramienta(especificador)`:

```json
{
  "permissions": {
    "allow": ["Bash(npm run *)"],
    "ask": ["Bash(git push *)"],
    "deny": ["Read(./.env)", "WebFetch(domain:example.com)"]
  }
}
```

Las reglas se evalúan en el orden deny, ask y allow. Un `deny` en cualquier ámbito prevalece sobre un `allow`. Las rutas de `Read` y `Edit` usan sintaxis gitignore.

Las reglas sobre `Bash` no son una barrera completa: la documentación advierte, por ejemplo, de que `Bash(curl *)` no impide ejecutar `/usr/bin/curl`. Combínalas con sandbox.

## Modos

| Modo | Comportamiento |
|------|----------------|
| `default` | Pide confirmación en el primer uso |
| `acceptEdits` | Acepta ediciones de ficheros en el directorio de trabajo |
| `plan` | Solo lectura y exploración |
| `auto` | Un clasificador revisa las acciones en lugar de preguntar |
| `dontAsk` | Deniega lo que requeriría confirmación |
| `bypassPermissions` | Omite las confirmaciones salvo acciones protegidas |

`bypassPermissions` solo debe usarse en entornos aislados. Se establece por defecto con `defaultMode` y puede bloquearse con `disableBypassPermissionsMode`.

## Precedencia de ajustes

Política gestionada, opciones de línea de comandos, `.claude/settings.local.json`, `.claude/settings.json` y `~/.claude/settings.json`, de mayor a menor prioridad. Las listas de permisos se combinan.

## Sandbox

El sandbox aplica límites a nivel de sistema operativo a los comandos Bash y complementa a los permisos. Actívalo cuando el agente ejecute código que no controles.

## Recomendaciones

- Deniega la lectura de `.env`, claves y credenciales.
- No uses `bypassPermissions` fuera de un contenedor o máquina desechable.
- Revisa los servidores [MCP](mcp.md) antes de aprobarlos.

## Referencias

- [Permisos](https://code.claude.com/docs/en/permissions)
- [Ajustes](https://code.claude.com/docs/en/settings)
