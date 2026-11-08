#!/usr/bin/env bash
# Comprobación determinista: corrige, indexa y verifica con las mismas reglas que el commit y el push.
set -euo pipefail
cd "$(dirname "$0")/.."
PC=.venv/bin/pre-commit

git add -A                                            # pre-commit valida lo indexado, no el working tree
$PC run --all-files >/dev/null || true                # 1.ª pasada: los hooks con --fix reescriben archivos
git add -A                                            # indexa las correcciones
$PC run --all-files                                   # 2.ª pasada: debe pasar sin modificar nada
$PC run --all-files --hook-stage pre-push             # incluye mkdocs build
echo "OK: listo para git commit"
