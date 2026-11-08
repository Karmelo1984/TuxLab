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

## Gestionar skills con Skills CLI

[Skills CLI](https://skills.sh/) es un gestor externo para descubrir, instalar y mantener skills de distintos agentes. **No es el sistema de plugins de Claude Code**. Para usarlo con `npx`, necesitas Node.js 22.20 o posterior.

```bash
# Buscar por tema
npx skills find
npx skills find playwright

# Instalar find-skills globalmente solo para Claude Code
npx skills add vercel-labs/skills --skill find-skills -g -a claude-code -y

# Consultar y mantener skills
npx skills list -g
npx skills check
npx skills update
```

`find-skills` permite a Claude descubrir skills cuando solicitas capacidades nuevas. **No instala automáticamente todas las skills encontradas**; revisa el origen, los scripts y los permisos de cada una antes de instalar. Sin `-g`, la instalación de Skills CLI es local al proyecto por defecto.

### Crear skills propias

La skill oficial _Skill Creator_ ayuda a redactar, evaluar e iterar skills. Se distribuye como plugin de Claude Code:

```bash
claude plugin install skill-creator@claude-plugins-official --scope user
claude plugin list
```

Si el marketplace oficial no está configurado, consulta primero `claude plugin marketplace list` y la documentación oficial de plugins. Para una plantilla básica también existe `npx skills init <nombre>`.

**Diferencias:** una _skill_ aporta instrucciones y recursos; un _plugin_ puede agrupar skills, hooks y servidores MCP. Ninguno equivale a una validación determinista de arquitectura o seguridad.

Fuentes: [Skills CLI](https://github.com/vercel-labs/skills), [find-skills](https://github.com/vercel-labs/skills/blob/main/skills/find-skills/SKILL.md) y [Skill Creator](https://github.com/anthropics/claude-plugins-official/tree/main/plugins/skill-creator).

## Referencias

- [Skills de Claude Code](https://code.claude.com/docs/en/skills)
