# syntax=docker/dockerfile:1.7
# Imagen multi-arquitectura: linux/amd64 y linux/arm64.
ARG PYTHON_IMAGE=python:3.12-slim-bookworm

# Dependencias Python: los compiladores no se copian a las imágenes finales.
FROM ${PYTHON_IMAGE} AS python-deps
ENV PIP_DISABLE_PIP_VERSION_CHECK=1
RUN apt-get update \
    && apt-get install -y --no-install-recommends build-essential libffi-dev \
    && rm -rf /var/lib/apt/lists/*
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:${PATH}"
COPY requirements-mkdocs.txt /tmp/requirements-mkdocs.txt
RUN --mount=type=cache,target=/root/.cache/pip \
    python -m pip install --no-compile -r /tmp/requirements-mkdocs.txt \
    && python -m pip check \
    && python -m pip uninstall --yes pip

# Desarrollo: GitPython requiere el ejecutable git incluso si el plugin de fechas está desactivado.
FROM ${PYTHON_IMAGE} AS development
ENV PATH="/opt/venv/bin:${PATH}" \
    VIRTUAL_ENV=/opt/venv \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    HOME=/tmp \
    XDG_CACHE_HOME=/tmp/.cache
RUN apt-get update \
    && apt-get install -y --no-install-recommends git ca-certificates \
    && rm -rf /var/lib/apt/lists/* \
    && groupadd --gid 10001 mkdocs \
    && useradd --uid 10001 --gid 10001 --no-create-home \
    --home-dir /tmp --shell /usr/sbin/nologin mkdocs
COPY --from=python-deps /opt/venv /opt/venv
WORKDIR /mkdocs
USER 10001:10001
EXPOSE 8000
CMD ["mkdocs", "serve", "--dev-addr=0.0.0.0:8000"]

# Construcción de HTML estático: con Git real para obtener fechas históricas.
FROM ${PYTHON_IMAGE} AS site-builder
ENV PATH="/opt/venv/bin:${PATH}" \
    VIRTUAL_ENV=/opt/venv \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    CI=true
RUN apt-get update \
    && apt-get install -y --no-install-recommends git \
    && rm -rf /var/lib/apt/lists/*
COPY --from=python-deps /opt/venv /opt/venv
WORKDIR /src
COPY mkdocs/ /src/mkdocs/
# Requiere construir desde un clon Git local con historial completo.
COPY .git/ /src/.git/
COPY .git-blame-ignore-revs /src/.git-blame-ignore-revs
ARG SITE_URL=https://karmelo1984.github.io/TuxLab/
RUN git rev-parse --is-inside-work-tree \
    && sed -i "s|^site_url:.*|site_url: ${SITE_URL}|" /src/mkdocs/mkdocs.yml \
    && mkdocs build --clean \
    --config-file /src/mkdocs/mkdocs.yml \
    --site-dir /site

# Producción: solo web estática y servidor Caddy; sin MkDocs ni Python.
FROM caddy:2-alpine AS production
COPY deploy/Caddyfile /etc/caddy/Caddyfile
COPY --from=site-builder --chown=10001:10001 /site/ /usr/share/caddy/
USER 10001:10001
EXPOSE 8080

