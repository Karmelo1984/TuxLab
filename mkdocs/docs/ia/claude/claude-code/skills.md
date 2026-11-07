---
title: "Skills"
description: "Qué es una skill de Claude Code, dónde se define con SKILL.md, qué campos admite y cómo se carga e invoca."
---

# Skills

Una skill es un procedimiento reutilizable que Claude Code carga bajo demanda. A diferencia de `CLAUDE.md`, que se carga siempre, el cuerpo de una skill solo entra en el contexto cuando se usa, lo que ahorra tokens; ver [Optimización](optimizacion.md).

## Estructura

Cada skill es un directorio con un fichero `SKILL.md`:

| Ámbito | Ruta |
|--------|------|
| Personal | `~/.claude/skills/<nombre>/SKILL.md` |
| Proyecto | `.claude/skills/<nombre>/SKILL.md` |
| Plugin | `<plugin>/skills/<nombre>/SKILL.md`, invocada como `/plugin:skill` |

Los antiguos `.claude/commands/*.md` siguen funcionando y equivalen a skills.

## Ejemplo

```markdown
---
name: deploy
description: Despliega la aplicación en producción. Úsala cuando se pida publicar una versión.
disable-model-invocation: true
allowed-tools: Bash(git status *)
---

1. Comprueba que el árbol de trabajo está limpio.
2. Ejecuta las pruebas.
3. Publica la versión.
```

## Campos de la cabecera

| Campo | Función |
|-------|---------|
| `name` | Nombre; por defecto, el del directorio |
| `description` | Cuándo usarla; siempre está en el contexto para que Claude decida |
| `disable-model-invocation` | Con `true`, solo se ejecuta si el usuario la invoca |
| `user-invocable` | Con `false`, no aparece en el menú `/` |
| `allowed-tools` | Herramientas permitidas sin preguntar mientras actúa la skill |
| `context: fork` | La ejecuta en un subagente |

Los campos no reconocidos se ignoran. La documentación recomienda mantener `SKILL.md` por debajo de unas 500 líneas.

## Invocación

Se invoca con `/nombre-de-la-skill` al inicio de un mensaje, y admite argumentos mediante `$ARGUMENTS`. Salvo `disable-model-invocation: true`, Claude también puede cargarla por su cuenta cuando la descripción encaja con la tarea. Los cambios en `SKILL.md` se detectan sin reiniciar.

## Cuándo usar una skill

Úsala para un procedimiento que se repite y es demasiado largo para `CLAUDE.md`. Si la comprobación debe ejecutarse siempre y sin depender del criterio del modelo, usa un [hook](hooks.md).

## Referencias

- [Skills de Claude Code](https://code.claude.com/docs/en/skills)
