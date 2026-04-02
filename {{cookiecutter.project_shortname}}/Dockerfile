{%- if cookiecutter.base_image == "debian" %}
# syntax=docker/dockerfile:1

#
# Copyright (C) {{ cookiecutter.year }} Northwestern University.
# Copyright (C) {{ cookiecutter.year }} Frontmatter.
# Copyright (C) {{ cookiecutter.year }} KTH Royal Institute of Technology.
#
# Invenio is free software; you can redistribute it and/or modify it
# under the terms of the MIT License; see LICENSE file for more details.
#

# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# TODO delete once the test is successful
ARG BUILD_PLATFORM=linux/amd64
ARG PYTHON_VERSION=3.14
ARG OS_VERSION=trixie
ARG NODE_VERSION=24

FROM --platform=${BUILD_PLATFORM} python:${PYTHON_VERSION}-${OS_VERSION} AS base

LABEL org.opencontainers.image.source=https://github.com/inveniosoftware/docker-invenio

ENV \
    WORKING_DIR=/opt/invenio \
    INVENIO_INSTANCE_PATH=/opt/invenio/var/instance \
    INVENIO_USER_ID=1000 \
    PATH=/opt/invenio/src/.venv/bin:${PATH}

# Create relevant application directories
RUN mkdir -p \
    ${WORKING_DIR}/src \
    ${INVENIO_INSTANCE_PATH}/data \
    ${INVENIO_INSTANCE_PATH}/archive \
    ${INVENIO_INSTANCE_PATH}/static

# Invenio file will be in <WORKING_DIR>/src
WORKDIR ${WORKING_DIR}/src

# Set folder permissions
RUN chgrp -R 0 ${WORKING_DIR} && \
    chmod -R g=u ${WORKING_DIR} && \
    useradd invenio --uid ${INVENIO_USER_ID} --gid 0 && \
    chown -R invenio:root ${WORKING_DIR}

RUN \
    --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update && apt-get upgrade --yes \
    && \
    # Install Node.js deb source
    curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash - \
    && \
    # Install system dependencies
    apt-get install --yes --no-install-recommends \
        build-essential \
        fonts-dejavu \
        locales \
        nodejs \
        npm \
    && \
    # Install pnpm
    npm install -g pnpm@latest-10

# Setup uv
# From https://docs.astral.sh/uv/guides/integration/docker/
# but using docker.io/astral/uv because failure to fetch oauth token
COPY --from=docker.io/astral/uv:0.11 /uv /uvx /bin/

# Set locale
RUN localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

# Delete the above code and replace it with:
# FROM <published-debian-base> AS base
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FROM base AS build-base

FROM build-base AS builder

COPY README.md pyproject.toml uv.lock ./
COPY site ./site
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --frozen --no-dev --no-editable

COPY ./docker/uwsgi/ ${INVENIO_INSTANCE_PATH}
COPY ./invenio.cfg ${INVENIO_INSTANCE_PATH}
COPY ./templates/ ${INVENIO_INSTANCE_PATH}/templates/
COPY ./app_data/ ${INVENIO_INSTANCE_PATH}/app_data/
COPY ./translations/ ${INVENIO_INSTANCE_PATH}/translations/
COPY ./assets/ ./assets/
COPY ./static/ ./static/

RUN cp -r ./static/. ${INVENIO_INSTANCE_PATH}/static/ && \
    cp -r ./assets/. ${INVENIO_INSTANCE_PATH}/assets/ && \
    invenio collect --verbose && \
    invenio webpack buildall && \
    rm -rf ${INVENIO_INSTANCE_PATH}/assets && \
    rm -rf \
        /root/.cache \
        /tmp/* \
        ${INVENIO_INSTANCE_PATH}/assets/node_modules \
        ${INVENIO_INSTANCE_PATH}/assets/.cache

FROM base AS app-base

COPY . .
COPY --from=builder ${WORKING_DIR}/src/.venv ./.venv
COPY --from=builder ${INVENIO_INSTANCE_PATH}/static/ ${INVENIO_INSTANCE_PATH}/static/
COPY ./docker/uwsgi/ ${INVENIO_INSTANCE_PATH}
COPY ./invenio.cfg ${INVENIO_INSTANCE_PATH}
COPY ./templates/ ${INVENIO_INSTANCE_PATH}/templates/
COPY ./app_data/ ${INVENIO_INSTANCE_PATH}/app_data/
COPY ./translations/ ${INVENIO_INSTANCE_PATH}/translations/

ENTRYPOINT ["bash", "-c"]
{%- endif %}
