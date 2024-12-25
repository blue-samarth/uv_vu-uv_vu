# syntax=docker/dockerfile:1.9

FROM ubuntu:noble AS builder
SHELL [ "/bin/bash" , "-exc" ]

RUN <<EOT
    apt-get update && apt-get install -y \
        -o APT::Install-Recommends=false -o APT::Install-Suggests=false \
        build-essential \
        ca-certificates \
        python3-setuptools \
        python3.12-dev &&
    apt-get clean && rm -rf /var/lib/apt/lists/*
EOT

COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv

ENV UV_LINK_MODE=copy \
    UV_COMPILE_BYTECODE=1 \
    UV_PYTHON_DOWNLOADS=never \
    UV_PYTHON=python3.12 \
    UV_PYTHON_ENVIRONMENT=/app

RUN mkdir -p /_lock
COPY pyproject.toml uv.lock /_lock/
WORKDIR /_lock

RUN --mount=type=cache,target=/root/.cache <<EOT
    uv sync \
        --locked \
        --no-dev \
        --no-install-project 
EOT

COPY . /src
RUN --mount=type=cache,target=/root/.cache \
    uv pip install \
        --python=${UV_PYTHON} \
        --no-deps \
        /src

FROM ubuntu:noble AS runtime
SHELL [ "/bin/bash" , "-exc" ]


COPY --from=builder /usr/local/bin/uv /usr/local/bin/uv

COPY . /app
ENV PATH=/app/bin:$PATH

WORKDIR /app

EXPOSE 5000

ENTRYPOINT ["uv", "run", "gunicorn", "-b", "0.0.0.0:5000", "--workers=2", "--threads=4", "app:app"]