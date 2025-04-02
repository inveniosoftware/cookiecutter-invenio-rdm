# Dockerfile that builds a fully functional image of your app.
#
# This image installs all Python dependencies for your application. It's based
# on Alpine Linux. For other base images (AlmaLinux, Debian, etc.) see the
# multiple flavors available at https://github.com/inveniosoftware/docker-invenio.
# This image includes Python, uv, Node.js, PNPM
# and includes Pip, Pipenv, Node.js, PNPM and some few standard libraries
# Invenio usually needs.

ARG ALPINE_VERSION=3.23.3
ARG PYTHON_SERIES=3.12
ARG JS_PACKAGE_MANAGER=pnpm@10.29.2
ARG WORKING_DIR=/opt/invenio
ARG VIRTUAL_ENV=/opt/env
ARG INVENIO_INSTANCE_PATH=${WORKING_DIR}/var/instance

FROM ghcr.io/astral-sh/uv:alpine AS builder
ARG JS_PACKAGE_MANAGER
ARG PYTHON_SERIES
ARG WORKING_DIR
ARG VIRTUAL_ENV
ARG INVENIO_INSTANCE_PATH

ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8 \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    UV_NO_MANAGED_PYTHON=1 \
    UV_PYTHON_DOWNLOADS=never \
    UV_SYSTEM_PYTHON=1 \
    UV_PROJECT_ENVIRONMENT=${VIRTUAL_ENV} \
    UV_CACHE_DIR=/opt/.cache/uv \
    WORKING_DIR=${WORKING_DIR} \
    VIRTUAL_ENV=${VIRTUAL_ENV} \
    INVENIO_INSTANCE_PATH=${INVENIO_INSTANCE_PATH} \
    PATH=${VIRTUAL_ENV}/bin:${PATH}

WORKDIR ${WORKING_DIR}

RUN apk add --no-cache \
    "python3~=${PYTHON_SERIES}" \
    "python3-dev~=${PYTHON_SERIES}" \
    autoconf automake bash binutils build-base cairo file gcc ghostscript git \
    libtool libxml2-dev libxslt-dev linux-headers musl-dev nodejs npm openssl xmlsec xmlsec-dev

RUN npm install -g "${JS_PACKAGE_MANAGER}"

RUN set -eux; \
    uv venv "${VIRTUAL_ENV}"; \
    "${VIRTUAL_ENV}/bin/python" -m ensurepip --upgrade; \
    "${VIRTUAL_ENV}/bin/python" -m pip install --no-cache-dir --upgrade pip; \
    mkdir -p "${INVENIO_INSTANCE_PATH}" /opt/.cache/uv

COPY . .
COPY ./invenio.cfg ${INVENIO_INSTANCE_PATH}/
COPY ./docker/uwsgi/ ${INVENIO_INSTANCE_PATH}/
COPY ./app_data/ ${INVENIO_INSTANCE_PATH}/app_data/
COPY ./templates/ ${INVENIO_INSTANCE_PATH}/templates/
COPY ./translations/ ${INVENIO_INSTANCE_PATH}/translations/

RUN --mount=type=cache,target=/opt/.cache/uv uv sync --frozen --no-dev

ENV INVENIO_WEBPACKEXT_NPM_PKG_CLS=pynpm:PNPMPackage \
    PNPM_HOME=/root/.local/share/pnpm

RUN --mount=type=cache,target=/root/.local/share/pnpm/store \
    set -eux; \
    export PATH="${PNPM_HOME}:${PATH}"; \
    mkdir -p "${INVENIO_INSTANCE_PATH}/static" "${INVENIO_INSTANCE_PATH}/assets"; \
    cp -r ./static/. "${INVENIO_INSTANCE_PATH}/static/"; \
    cp -r ./assets/. "${INVENIO_INSTANCE_PATH}/assets/"; \
    uv run invenio collect --verbose; \
    uv run invenio webpack buildall; \
    uv cache clean; \
    rm -rf "${INVENIO_INSTANCE_PATH}/assets/node_modules" \
        "${INVENIO_INSTANCE_PATH}/assets/.pnpm-store" \
        "${INVENIO_INSTANCE_PATH}/assets/.npm"

FROM alpine:${ALPINE_VERSION} AS runtime
ARG PYTHON_SERIES
ARG WORKING_DIR
ARG VIRTUAL_ENV
ARG INVENIO_INSTANCE_PATH
ARG IMAGE_BUILD_TIMESTAMP
ARG SENTRY_RELEASE

ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8 \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    UV_NO_MANAGED_PYTHON=1 \
    UV_PYTHON_DOWNLOADS=never \
    UV_SYSTEM_PYTHON=1 \
    UV_PROJECT_ENVIRONMENT=${VIRTUAL_ENV} \
    UV_NO_CACHE=1 \
    HOME=/opt/invenio \
    WORKING_DIR=${WORKING_DIR} \
    VIRTUAL_ENV=${VIRTUAL_ENV} \
    INVENIO_INSTANCE_PATH=${INVENIO_INSTANCE_PATH} \
    INVENIO_IMAGE_BUILD_TIMESTAMP="${IMAGE_BUILD_TIMESTAMP}" \
    SENTRY_RELEASE="${SENTRY_RELEASE}" \
    PATH=${VIRTUAL_ENV}/bin:${PATH}

WORKDIR ${WORKING_DIR}

RUN apk add --no-cache \
    "python3~=${PYTHON_SERIES}" \
    bash cairo fontconfig ghostscript libxslt ttf-dejavu uwsgi-python3 xmlsec

COPY --from=builder ${VIRTUAL_ENV} ${VIRTUAL_ENV}
COPY --from=builder ${WORKING_DIR} ${WORKING_DIR}

# we can remove these 2 lines if we do not want to include uv and uvx in the runtime image
COPY --from=builder /usr/local/bin/uv /usr/local/bin/uv
COPY --from=builder /usr/local/bin/uvx /usr/local/bin/uvx

RUN set -eux; \
    mkdir -p ${INVENIO_INSTANCE_PATH}/data ${INVENIO_INSTANCE_PATH}/archive; \
    chown -R 100:101 ${INVENIO_INSTANCE_PATH}; \
    chmod -R u+w ${INVENIO_INSTANCE_PATH}

USER 100:101
ENTRYPOINT ["bash", "-c"]
