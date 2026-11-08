---
title: "Plugins de optimización: Caveman y Ponytail"
description: "Instalación global en macOS, modos, configuración, comprobaciones y límites de Caveman y Ponytail en Claude Code."
---

# Plugins de optimización: Caveman y Ponytail

## Resumen

| Herramienta | Objetivo | No garantiza |
|-------------|----------|--------------|
| **Caveman** | Respuestas más concisas | Reducir el contexto de entrada o la factura total |
| **Ponytail** | Evitar complejidad y código innecesarios | Cumplir automáticamente SOLID o una arquitectura concreta |
| [CodeGraph](mcp.md#codegraph-grafos-del-repositorio) | Explorar relaciones del código | Indexar proyectos sin `codegraph init` |
| [Skills CLI](skills.md#gestionar-skills-con-skills-cli) | Descubrir e instalar capacidades | La calidad o seguridad de las skills instaladas |

`--scope user` instala plugins para el usuario de Claude Code, no para una sola carpeta. El _plugin_ se instala por equipo: usar la misma cuenta en otro Mac no implica que esté instalado allí.

## Instalar en macOS

Requisito: Claude Code instalado y operativo (`claude --version`). Ponytail utiliza hooks de Node.js; comprueba también `node --version`.

```bash
# Caveman
claude plugin marketplace add JuliusBrussee/caveman
claude plugin install caveman@caveman --scope user

# Ponytail
claude plugin marketplace add DietrichGebert/ponytail
claude plugin install ponytail@ponytail --scope user

# Verificar
claude plugin list
```

Si ya aparecen instalados y habilitados, **no repitas la instalación**. Para actualizarlos:

```bash
claude plugin update caveman@caveman
claude plugin update ponytail@ponytail
```

Reinicia la sesión de Claude Code después de actualizar: los hooks se cargan al inicio.

## Caveman: extensión de respuestas

| Modo | Activación dentro de Claude Code | Resultado |
|------|---------------------------------|-----------|
| `caveman` | `/caveman` | Conciso, manteniendo información técnica |
| `ultracave` | `/ultracave` | Compresión extrema de la expresión |
| `megacave` | `/megacave` | Estilo chino clásico; poco adecuado para documentación en castellano |
| Desactivar | `stop caveman` | Vuelve a la respuesta normal de esa sesión |

```text
/caveman status   # Estado de la sesión
/caveman-help     # Ayuda y modos
```

El modo por defecto para **sesiones nuevas** se configura así:

```bash
mkdir -p ~/.config/caveman
printf '{"defaultMode":"caveman"}\n' > ~/.config/caveman/config.json
cat ~/.config/caveman/config.json
printf '%s\n' "${CAVEMAN_DEFAULT_MODE:-variable no definida}"
```

La variable `CAVEMAN_DEFAULT_MODE` o un `.caveman.json` del proyecto pueden prevalecer sobre la configuración de usuario. El modo de la sesión actual puede diferir: consúltalo con `/caveman status`.

**Advertencia de dependencias:** si `claude plugin list` indica que no instaló paquetes por usar _lockfiles_ Yarn/pnpm, el plugin puede estar habilitado sin que todas sus dependencias estén disponibles. Verifica comandos y hooks; no des por hecho ni que esté roto ni que funcione íntegramente. Instalar pnpm por sí solo no resuelve el mensaje del instalador.

**Límite:** este plugin cambia primordialmente la **forma de las respuestas**. La compresión de entradas y herramientas mediante el CLI/proxy Caveman es un componente distinto; no supongas ahorros medidos solo por activar el plugin.

## Ponytail: evitar el _overengineering_

| Modo | Comando | Uso |
|------|---------|-----|
| `lite` | `/ponytail lite` | Menor intervención, útil al diseñar arquitectura nueva |
| `full` (por defecto) | `/ponytail full` | Simplificación habitual sin introducir abstracciones especulativas |
| `ultra` | `/ponytail ultra` | Cuestiona más intensamente complejidad y requisitos accesorios |
| `off` | `/ponytail off` | Desactiva sus reglas |

Sin argumento, `/ponytail` muestra el modo actual. Otros comandos: `/ponytail-review` (diff), `/ponytail-audit` (repositorio) y `/ponytail-help` (ayuda).

```bash
mkdir -p ~/.config/ponytail
printf '{"defaultMode":"full"}\n' > ~/.config/ponytail/config.json
cat ~/.config/ponytail/config.json
printf '%s\n' "${PONYTAIL_DEFAULT_MODE:-variable no definida}"
```

**Criterio de diseño:** Ponytail favorece reutilizar el código, las convenciones y los componentes existentes, y aplicar YAGNI/KISS. No es un analizador formal de SOLID, DDD, Clean Architecture, Factory, Strategy ni Repository. Un patrón puede estar justificado por requisitos reales de extensibilidad o separación de responsabilidades; la reducción de líneas no debe prevalecer sobre la corrección.

Para dejar la arquitectura explícita, utiliza [`CLAUDE.md`](contexto-reglas.md) en cada proyecto:

```text
- Preserve existing architectural boundaries and conventions.
- Apply design patterns only when justified by concrete requirements.
- Avoid speculative abstractions and dependencies.
- Prioritize correctness, maintainability, testability and clarity over line count.
- Never remove required validation, security checks, error handling or tests.
- Write project documentation in Spanish.
```

Las reglas de `CLAUDE.md` son orientación para el modelo, **no garantías ejecutables**. En casos críticos utiliza tests, CI, hooks y permisos.

## Diagnóstico rápido

| Síntoma | Comprobación |
|---------|-------------|
| Un plugin no aparece | `claude plugin list` y comprobar `--scope user` |
| El modo parece incorrecto | `/caveman status` o `/ponytail`; comprobar JSON y variables de entorno |
| La configuración no cambia | Abrir una sesión nueva; revisar reglas locales del proyecto |
| Aparece advertencia Yarn/pnpm | Probar comandos y hooks antes de asumir fallo |
| Claude genera código demasiado simple | Especificar restricciones en `CLAUDE.md`; usar `ponytail lite` si procede |
| El coste no desciende | Comparar tareas equivalentes con [`/usage`](optimizacion.md) y revisar tamaño del contexto |

## Fuentes

- [Caveman: instalación](https://github.com/JuliusBrussee/caveman/blob/main/INSTALL.md)
- [Ponytail: instalación](https://github.com/DietrichGebert/ponytail/blob/main/INSTALL.md)
- [Ponytail: funcionamiento y comandos](https://github.com/DietrichGebert/ponytail/blob/main/README.md)
- [Plugins de Claude Code](https://code.claude.com/docs/en/plugins)
