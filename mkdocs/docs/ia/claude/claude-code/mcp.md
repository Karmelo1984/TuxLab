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

## CodeGraph: grafos del repositorio

[CodeGraph](https://github.com/colbymchenry/codegraph) analiza relaciones del código y expone herramientas a Claude Code mediante MCP. **Hay dos pasos independientes**:

```bash
# 1. Instalar el ejecutable y registrar el MCP en el usuario
npm install -g @colbymchenry/codegraph
codegraph install --target=claude --location=global --no-permissions --yes

# 2. Indexar cada proyecto donde quieras usarlo
cd /ruta/a/tu/repositorio
codegraph init
```

`--no-permissions` evita añadir aprobaciones automáticas de herramientas MCP. La instalación global no crea índices automáticamente: `codegraph init` genera `.codegraph/` en cada repositorio. Valora excluir ese índice del control de versiones según la política del proyecto.

```bash
# Comprobar que el servidor MCP está registrado
claude mcp list

# Consultar la ayuda del ejecutable
codegraph --help

# Eliminar el índice del proyecto (desde su raíz)
codegraph uninit

# Retirar la integración global del agente (si procede)
codegraph uninstall
```

Si `claude mcp list` ya incluye `codegraph`, **no repitas la integración**: basta con comprobar si el proyecto está indexado. `MCP conectado` no significa `grafo del proyecto listo`.

### Alternativa: Graphify

[Graphify](https://github.com/Graphify-Labs/graphify) genera un grafo consultable de código, documentos, configuraciones y esquemas SQL. Se instala como **skill**; no es necesario añadirlo si CodeGraph ya resuelve el caso de uso.

```bash
brew install uv
uv tool install graphifyy
# Registra la skill para los asistentes detectados
graphify install
```

Desde Claude Code: `/graphify .`. El paquete oficial de PyPI es `graphifyy` (doble `y`). Compara cobertura y utilidad antes de mantener dos indexadores.

**Fuente de CodeGraph:** [instalación oficial](https://colbymchenry.github.io/codegraph/getting-started/installation/). **Fuente de Graphify:** [guía oficial](https://github.com/Graphify-Labs/graphify).

## Riesgos

- Un servidor MCP ejecuta código o accede a datos con tus credenciales: instala solo servidores de confianza.
- Su contenido puede incluir instrucciones maliciosas (_prompt injection_); ver [Seguridad y limitaciones](../../fundamentos/seguridad.md).
- No guardes secretos en `.mcp.json`; usa variables de entorno.
- Cada servidor añade descripciones de herramientas al contexto; desactiva los que no uses con `/mcp`.

## Referencias

- [MCP en Claude Code](https://code.claude.com/docs/en/mcp)
