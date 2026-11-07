---
title: "Contexto y reglas: CLAUDE.md"
description: "Dónde se ubica CLAUDE.md, cómo se carga, cómo importar ficheros y cómo limitar reglas por ruta con .claude/rules."
---

# Contexto y reglas: CLAUDE.md

`CLAUDE.md` es un fichero Markdown cuyo contenido Claude Code carga como contexto al empezar una sesión. Sirve para fijar convenciones del proyecto, comandos habituales y criterios de trabajo. Es una guía, no una garantía: para imponer comportamientos usa [hooks](hooks.md) o [permisos](seguridad.md).

## Ubicaciones

| Ámbito | Ubicación |
|--------|-----------|
| Política gestionada | `/Library/Application Support/ClaudeCode/CLAUDE.md` (macOS), `/etc/claude-code/CLAUDE.md` (Linux) |
| Usuario | `~/.claude/CLAUDE.md` |
| Proyecto | `./CLAUDE.md` o `./.claude/CLAUDE.md` |
| Local | `./CLAUDE.local.md` (añádelo a `.gitignore`) |

Los ficheros del directorio actual y de todos los directorios superiores se concatenan, desde la raíz hacia abajo; no se sustituyen entre sí. Los `CLAUDE.md` de subdirectorios se cargan al leer o editar archivos de esa carpeta.

## Buenas prácticas

- Mantén cada fichero por debajo de unas 200 líneas, según la guía oficial.
- Escribe instrucciones concretas y verificables.
- Los comentarios HTML (`<!-- -->`) se eliminan antes de enviar el contenido al modelo.
- `/init` genera un `CLAUDE.md` inicial; si ya existe, propone mejoras.

## Importaciones

Con `@ruta/al/fichero` se importa otro archivo. Las rutas relativas se resuelven desde el fichero que importa, con un máximo de cuatro niveles. Las importaciones dentro de bloques de código se ignoran.

```markdown
Consulta @README.md y @docs/convenciones.md antes de proponer cambios.
```

## Reglas con `.claude/rules/`

Los ficheros `.md` de `.claude/rules/` se descubren de forma recursiva. Los que no declaran `paths` se cargan al iniciar con la misma prioridad que `.claude/CLAUDE.md`. Con `paths` se limitan a ciertos ficheros y se cargan cuando Claude trabaja con uno que coincide:

```markdown
---
paths:
  - "src/api/**/*.ts"
---

Valida todas las entradas de los endpoints.
```

Las reglas de usuario viven en `~/.claude/rules/`.

## Diagnóstico

- `/memory` muestra y abre los ficheros de memoria cargados.
- `/context all` lista los ficheros de memoria cargados al iniciar.
- Si no hay `CLAUDE.md`, Claude Code lee `AGENTS.md`.

## Memoria automática

Claude Code puede guardar notas por su cuenta en `~/.claude/projects/<proyecto>/memory/`. Al iniciar carga las primeras 200 líneas o 25 KB de `MEMORY.md`. Se desactiva con la variable `CLAUDE_CODE_DISABLE_AUTO_MEMORY=1`.

## Referencias

- [Memoria de Claude Code](https://code.claude.com/docs/en/memory)
