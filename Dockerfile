# syntax=docker/dockerfile:1.7

ARG PYTHON_VERSION=3.12
FROM python:${PYTHON_VERSION}-slim-bookworm AS wheelhouse

ENV PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /src

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        git \
        libffi-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libopenjp2-7-dev \
        libpng-dev \
        libtiff-dev \
        libvips-dev \
        libxml2-dev \
        libxslt1-dev \
        pkg-config \
        zlib1g-dev && \
    rm -rf /var/lib/apt/lists/*

COPY pyproject.toml README.rst LICENSE CITATION.cff ./
COPY kraken ./kraken

RUN --mount=type=cache,target=/root/.cache/pip \
    python -m pip wheel --wheel-dir /wheels ".[pdf]"

FROM python:${PYTHON_VERSION}-slim-bookworm AS runtime

ENV PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        libgomp1 \
        libjpeg62-turbo \
        libopenjp2-7 \
        libpng16-16 \
        libtiff6 \
        libvips42 \
        libxml2 \
        libxslt1.1 && \
    rm -rf /var/lib/apt/lists/*

COPY --from=wheelhouse /wheels /wheels

RUN python -m pip install coremltools
RUN python -m pip install --no-index --find-links=/wheels "kraken[pdf]" && \
    rm -rf /wheels

WORKDIR /work
CMD ["sh"]