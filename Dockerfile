
#syntax=docker/dockerfile:1.9 

FROM ubuntu:noble
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
# The above command will copy the uv binary from the uv image to the /usr/local/bin/uv path in the base image.

ENV UV_LINK_MODE=copy \ 
    UV_COMPILE_BYTECODE=1 \
    UV_PYTHON_DOWNLOADS=never \
    UV_PYTHON=python3.12 \
    UV_PYTHON_ENVIRONMENT=/app


### End build prep -- this is where your app Dockerfile should start.

RUN mkdir -p /_lock
COPY pyproject.toml /_lock/
COPY uv.lock /_lock/


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

COPY . /app
ENV PATH=/app/bin:$PATH

WORKDIR /app

EXPOSE 5000

# Set the entry point for the Flask app
ENTRYPOINT ["uv", "run", "gunicorn", "-b", "0.0.0.0:5000", "--workers=2", "--threads=4", "app:app"]