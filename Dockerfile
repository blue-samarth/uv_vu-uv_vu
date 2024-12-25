
#syntax=docker/dockerfile:1.9 

FROM ubuntu:noble AS prebuild

SHELL [ "/bin/bash" , "-exc" ] 
#set shell to bash

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

# The above command will install the project dependencies using the uv binary without installing the dependencies
# `/src` will not be copied to the runtime image, only the installed dependencies will be copied.
# As of uv 0.4.11, you can also use `cd /src && uv sync --locked --no-dev --no-editable` instead.
# --python=${UV_PYTHON_ENVIRONMENT}: This will set the python environment path to /app.
# --no-deps: This will prevent uv from installing the dependencies.


FROM ubuntu:noble as build
SHELL [ "/bin/bash" , "-exc" ] 

ENV PATH=/app/bin:$PATH

RUN <<EOT
    groupadd -r app
    useradd -r -d /app -g app -N app
EOT

# we create a new user and group called app with the home directory /app.
# The user app will be the owner of the /app directory.
# groupadd -r app: This will create a system group called app.
# useradd -r -d /app -g app -N app: This will create a system user called app with the home directory /app and the group app.


# ENTRYPOINT ["gunicorn", "-b", "0.0.0.0:5000", "app:app"]
#this is a flask app so we don't necessarily need to specify the command to run the app as it will be done by the flask app itself. so this is a placeholder

# STOPSIGNAL SIGINT
# we set the stop signal to SIGINT. This will send an interrupt signal to the container when it is stopped. basically, it will stop the container gracefully.
# SIGINT: This is the interrupt signal. This signal is sent when you press Ctrl+C in the terminal.
# also we don't need to specify the command to run the app as it will be done by the flask app itself. so this is a placeholder

RUN <<EOT
    apt-get update -qy
    apt-get install -qyy \
        -o APT::Install-Recommends=false -o APT::Install-Suggests=false \
        python3.12 \
        libpython3.12 \
        libprce3 \
        libxml12
    
    apt-get clean
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
EOT


FROM ubuntu:noble as runtime
SHELL [ "/bin/bash" , "-exc" ]

COPY --from=build /app /app
COPY --from=build /etc/passwd /etc/passwd
COPY --from=build /etc/group /etc/group


USER app
WORKDIR /app

EXPOSE 5000

# Set the entry point for the Flask app
ENTRYPOINT ["gunicorn", "-b", "0.0.0.0:5000", "--workers=2", "--threads=4", "app:app"]
