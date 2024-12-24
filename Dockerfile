
#syntax=docker/dockerfile:1.9 

FROM ubuntu:noble AS build

SHELL [ "/bin/bash" , "-exc" ] # set shell to bash

RUN <<EOT
    apt-get update
    apt-get install -y \
        -o APT::Install-Recommends=false -o APT::Install-Suggests=false \
        build-essential \
        ca-certificates \
        python3-setuptools \
        python3.12-dev \
EOT

# The above command will install the necessary packages for building the python package like setuptools, python3.12-dev, etc. and also the build-essential package which is required for building the python package.

COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv 

# The above command will copy the uv binary from the uv image to the /usr/local/bin/uv path in the base image.

ENV UV_LINK_MODE=copy \ 
    UV_COMPILE_BYTECODE=1 \
    UV_PYTHON_DOWNLOADS=never \
    UV_PYTHON=python3.12 \
    UV_PYTHON_ENVIRONMENT=/app

# The above command will set the environment variables for the uv binary.
# UV_LINK_MODE=copy: This will copy the python environment to the /app path in the base image.
# UV_COMPILE_BYTECODE=1: This will compile the python bytecode.
# UV_PYTHON_DOWNLOADS=never: This will prevent the uv binary from downloading the python environment.
# UV_PYTHON=python3.12: This will set the python version to python3.12.
# UV_PYTHON_ENVIRONMENT=/app: This will set the python environment path to /app.



### End build prep -- this is where your app Dockerfile should start.

COPY pyproject.toml /_lock
COPY uv.lock /_lock

RUN --mount=type=cache,target=/root/.cache <<EOT
    uv sync \
    --locked \
    --no-dev \
    --no-install-project 
EOT

# run and cache the mount at /root/.cache
# will sync the python environment based on the pyproject.toml and uv.lock files via the uv binary.
# --locked: This will instruct uv to use lockfile for resolving dependencies.
# --no-dev: This will prevent uv from installing the development dependencies.
# --no-install-project: This will prevent uv from installing the project dependencies.

COPY . /src
RUN --mount=type=cache,target=/root/.cache \
    uv pip install \
    --python=${UV_PYTHON_ENVIRONMENT} \
    --no-deps \
    /src

