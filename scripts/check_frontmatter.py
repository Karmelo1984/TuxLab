#!/usr/bin/env python3
"""Valida la cabecera YAML de los .md de mkdocs/docs: solo `title` y `description`."""

import pathlib
import re
import sys

import yaml

ROOT = pathlib.Path(__file__).resolve().parent.parent / "mkdocs" / "docs"
PLACEHOLDERS = re.compile(r"TODO|FIXME|\{\{|XXX", re.I)


class UniqueKeyLoader(yaml.SafeLoader):
    def construct_mapping(self, node, deep=False):
        keys = [self.construct_object(k, deep=deep) for k, _ in node.value]
        dup = {k for k in keys if keys.count(k) > 1}
        if dup:
            raise yaml.YAMLError(f"claves duplicadas: {sorted(dup)}")
        return super().construct_mapping(node, deep)


def check(path: pathlib.Path) -> str | None:
    m = re.match(r"---\n(.*?)\n---\n", path.read_text(encoding="utf-8"), re.S)
    if not m:
        return "sin bloque YAML inicial delimitado"
    try:
        meta = yaml.load(m.group(1), Loader=UniqueKeyLoader)  # noqa: S506
    except yaml.YAMLError as e:
        return f"YAML inválido: {e}"
    if not isinstance(meta, dict) or set(meta) != {"title", "description"}:
        return f"claves distintas de title y description: {sorted(meta) if isinstance(meta, dict) else meta}"
    for k, v in meta.items():
        if not isinstance(v, str) or not v.strip():
            return f"{k} vacío o no es texto"
        if PLACEHOLDERS.search(v):
            return f"{k} contiene texto provisional"
    return None


def main() -> int:
    errors = [(p, e) for p in sorted(ROOT.rglob("*.md")) if (e := check(p))]
    for p, e in errors:
        print(f"{p.relative_to(ROOT)}: {e}")
    return 1 if errors else 0


if __name__ == "__main__":
    sys.exit(main())
