---
title: "MCP: herramientas externas"
description: "Cómo conectar servidores MCP a Claude Code: comandos, transportes, ámbitos, fichero .mcp.json y riesgos."
---

# MCP: herramientas externas

MCP (_Model Context Protocol_) es un protocolo abierto para conectar un modelo con herramientas y fuentes de datos externas. En Claude Code, un servidor MCP añade herramientas nombradas `mcp__<servidor>__<herramienta>`.

## Añadir un servidor

```bash
# Servidor remoto HTTP (recomendado para remotos)
claude mcp add --transport http notion https://mcp.notion.com/mcp

# Servidor local por stdio
claude mcp add --env AIRTABLE_API_KEY=TU_CLAVE --transport stdio airtable -- npx -y airtable-mcp-server
```

El `--` separa las opciones de Claude del comando del servidor. Otros comandos: `claude mcp list`, `claude mcp get <nombre>`, `claude mcp remove <nombre>` y `/mcp` dentro de una sesión.

## Transportes

| Transporte | Uso |
|------------|-----|
| HTTP | Recomendado para servidores remotos |
| stdio | Proceso local |
| SSE | Obsoleto; la documentación recomienda HTTP |

## Ámbitos

La opción `--scope` acepta `local` (por defecto), `project` y `user`. El ámbito `project` guarda la configuración en `.mcp.json`, que se puede versionar:

```json
{
  "mcpServers": {
    "shared-server": { "type": "http", "url": "https://example.com/mcp" }
  }
}
```

Los servidores de `.mcp.json` requieren aprobación antes de usarse.

## Riesgos

- Un servidor MCP ejecuta código o accede a datos con tus credenciales: instala solo servidores de confianza.
- Su contenido puede incluir instrucciones maliciosas (_prompt injection_); ver [Seguridad y limitaciones](../../fundamentos/seguridad.md).
- No guardes secretos en `.mcp.json`; usa variables de entorno.
- Cada servidor añade descripciones de herramientas al contexto; desactiva los que no uses con `/mcp`.

## Referencias

- [MCP en Claude Code](https://code.claude.com/docs/en/mcp)
