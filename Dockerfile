# syntax=docker/dockerfile:1.9

FROM ubuntu:noble AS builder
SHELL [ "/bin/bash" , "-exc" ]

RUN <<EOT
    apt-get update && apt-get install -y \
        -o APT::Install-Recommends=false -o APT::Install-Suggests=false \
        python3.12-minimal &&
    apt-get clean && rm -rf /var/lib/apt/lists/*
EOT

COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv

ENV UV_LINK_MODE=copy \
    UV_COMPILE_BYTECODE=1 \
    UV_PYTHON_DOWNLOADS=never \
    UV_PYTHON=python3.12 \
    UV_PYTHON_ENVIRONMENT=/app \
    UV_NO_BINARY=:all: \
    UV_INDEX_URL=https://pypi.org/simple \
    UV_WHEELS_ONLY=1

WORKDIR /app

# Copy only dependency files first
COPY pyproject.toml uv.lock ./

# Pre-download wheels using UV's wheel-only mode
RUN --mount=type=cache,target=/root/.cache/uv \
    uv pip sync uv.lock --wheel-only 

# Install from pre-downloaded wheels
RUN --mount=type=cache,target=/root/.cache/uv \
    uv pip install \
        --find-links=/wheels \
        --no-index \
        --no-deps \
        -r uv.lock

# Copy and install application
COPY . .
RUN --mount=type=cache,target=/root/.cache/uv \
    uv pip install \
        --no-deps \
        .

FROM gcr.io/distroless/python3:nonroot AS runtime

COPY --from=builder /usr/local/bin/uv /usr/local/bin/uv
COPY --from=builder /app /app

USER nonroot
WORKDIR /app

EXPOSE 5000

ENTRYPOINT ["uv", "run", "gunicorn", "-b", "0.0.0.0:5000", "--workers=2", "--threads=4", "app:app"]