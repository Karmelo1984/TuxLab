---
title: "Optimización de contexto y costes"
description: "Comandos y prácticas de Claude Code para controlar el consumo de tokens: /context, /compact, /clear, /usage, skills y modelos."
---

# Optimización de contexto y costes

El coste de Claude Code depende de los tokens procesados, y estos crecen con el contexto acumulado; ver [Tokens y contexto](../../fundamentos/tokens-contexto.md). Optimizar consiste en mantener en el contexto solo lo necesario.

## Comandos

| Comando | Función |
|---------|---------|
| `/context` | Muestra qué ocupa espacio en el contexto |
| `/usage` | Muestra tokens y coste de la sesión; `/cost` es un alias |
| `/compact [instrucciones]` | Resume la conversación; admite un foco, por ejemplo `/compact Centrarse en la API` |
| `/clear` | Inicia una sesión nueva; reinicia los totales |
| `/model` | Cambia de modelo |
| `/mcp` | Gestiona y desactiva servidores MCP |

En `CLAUDE.md` puedes añadir un apartado `# Compact instructions` para guiar qué conserva la compactación.

## Prácticas

- Mantén `CLAUDE.md` por debajo de unas 200 líneas y mueve procedimientos largos a [skills](skills.md), que solo se cargan al usarse.
- Usa un modelo ligero para tareas sencillas y reserva el más potente para las complejas; la documentación sugiere, por ejemplo, `model: haiku` en subagentes sencillos.
- Delega las búsquedas voluminosas en [subagentes](subagentes.md).
- Desactiva los servidores [MCP](mcp.md) que no uses.
- Usa el modo plan para explorar antes de editar.
- Limpia con `/clear` al cambiar de tarea.

## Caché de prompts

El contenido repetido al inicio de la petición se lee de caché a una tarifa menor; `/usage` muestra la proporción de aciertos. La caché caduca tras un tiempo sin uso; la duración exacta no figura en la página de costes, consulta la documentación de caché de prompts.

## Referencias

- [Gestión de costes](https://code.claude.com/docs/en/costs)
