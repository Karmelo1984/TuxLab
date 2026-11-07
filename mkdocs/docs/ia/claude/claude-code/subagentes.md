---
title: "Subagentes"
description: "Qué son los subagentes de Claude Code, dónde se definen, qué campos admiten y por qué su contexto independiente ahorra contexto principal."
---

# Subagentes

Un subagente es un asistente especializado con su propio prompt de sistema, sus herramientas y su propia ventana de contexto. Claude le delega una tarea y recibe solo el resultado, de modo que las lecturas y búsquedas intermedias no ocupan el contexto de la conversación principal.

Según la documentación, cada subagente empieza con un contexto nuevo y aislado, sin acceso al historial de la conversación.

## Subagentes integrados

| Nombre | Función |
|--------|---------|
| Explore | Búsqueda rápida de solo lectura |
| Plan | Investigación de solo lectura durante el modo plan |
| general-purpose | Tareas complejas con todas las herramientas |

## Definir uno propio

Un subagente es un fichero Markdown con cabecera YAML; el cuerpo es su prompt de sistema.

```markdown
---
name: revisor-codigo
description: Revisa cambios de código. Úsalo tras modificar ficheros.
tools: Read, Grep, Glob
model: haiku
---

Revisa el código buscando errores y riesgos de seguridad. Informa de cada hallazgo con fichero y línea.
```

| Ubicación | Prioridad |
|-----------|-----------|
| Política gestionada | La más alta |
| Opción `--agents` | Solo la sesión |
| `.claude/agents/` | Proyecto |
| `~/.claude/agents/` | Usuario |
| Plugin | La más baja |

Campos principales: `name` y `description` (obligatorios), `tools`, `disallowedTools`, `model`, `permissionMode`, `maxTurns`, `skills`, `mcpServers`, `hooks` y `memory`. Si se omite `tools`, hereda todas las herramientas.

## Cuándo usarlos

- Tareas que generan mucha salida intermedia (búsquedas, análisis de logs).
- Trabajo que puede limitarse a herramientas de solo lectura.
- Tareas sencillas que pueden usar un modelo más económico.

Cada subagente consume tokens por su cuenta, por lo que delegar sin necesidad aumenta el coste; ver [Optimización](optimizacion.md).

## Referencias

- [Subagentes de Claude Code](https://code.claude.com/docs/en/sub-agents)
