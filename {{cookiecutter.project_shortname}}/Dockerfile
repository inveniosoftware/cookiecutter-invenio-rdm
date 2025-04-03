# Dockerfile that builds a fully functional image of your app.
#
# This image installs all Python dependencies for your application. It's based
# on Almalinux (https://github.com/inveniosoftware/docker-invenio)
# This section includes essential tools and libraries such as Pip, UV / Pipenv, Node.js, NPM / Pnpm,
# and other standard libraries commonly required by Invenio applications.
#
# Note: It is important to keep the commands in this file in sync with your
# bootstrap script located in ./scripts/bootstrap.


# ---- Builder Stage ----
#------------------------

FROM ghcr.io/astral-sh/uv:alpine AS builder

# Args for configuration
ARG INVENIO_SERVER_NAME=localhost
# CHANGED: Default instance path to match docker compose command
ARG INVENIO_INSTANCE_PATH=/opt/invenio/var/instance

# Set environment variables
ENV INVENIO_SERVER_NAME=${INVENIO_SERVER_NAME}
# CHANGED: Instance path ENV to match docker compose command
ENV INVENIO_INSTANCE_PATH=${INVENIO_INSTANCE_PATH}
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8
# Venv path will be set later

# Install build dependencies using standard Alpine package names
RUN apk update && \
    apk add --no-cache \
        bash \
        build-base \
        cairo-dev \
        git \
        nodejs \
        npm \
        python3 \
        python3-dev && \
    npm install --global --ignore-scripts pnpm && \
    rm -rf /var/cache/apk/*

# Create the instance directory and set it as working directory
# This will now create /opt/invenio/var/instance
RUN mkdir -p "${INVENIO_INSTANCE_PATH}"
WORKDIR ${INVENIO_INSTANCE_PATH}

# Create and activate virtual environment using the available python3
# Venv will be inside /opt/invenio/var/instance
RUN python3 -m venv "${INVENIO_INSTANCE_PATH}/.venv"
ENV PATH="${INVENIO_INSTANCE_PATH}/.venv/bin:${PATH}"

# Install Python dependencies using uv
COPY pyproject.toml uv.lock* ./
RUN uv sync --locked --no-cache --compile-bytecode && \
    uv clean


# Copy essential config and code
COPY site ./site
COPY ./invenio.cfg ${INVENIO_INSTANCE_PATH}
COPY ./app_data/ ${INVENIO_INSTANCE_PATH}/app_data/

# Create temporary directories first
RUN mkdir -p /tmp/uwsgi /tmp/translations /tmp/assets /tmp/static /tmp/templates

# Copy optional/overridable components to temporary locations
COPY ./docker/uwsgi/ /tmp/uwsgi/
COPY ./translations/ /tmp/translations/
COPY ./assets/ /tmp/assets/
COPY ./static/ /tmp/static/
COPY ./templates/ /tmp/templates/

# Set environment variable for pnpm usage by Invenio-Cli/Webpack
ENV INVENIO_WEBPACKEXT_NPM_PKG_CLS=pynpm:PNPMPackage

# Build frontend assets
RUN set -e && \
    echo ">>> Running invenio collect..." && \
    invenio collect --verbose && \
    \
    mkdir -p ${INVENIO_INSTANCE_PATH}/assets \
                ${INVENIO_INSTANCE_PATH}/templates \
                ${INVENIO_INSTANCE_PATH}/translations && \
    \
    echo ">>> Copying local assets OVER collected assets for build..." && \
    cp -a /tmp/assets/. ${INVENIO_INSTANCE_PATH}/assets/ && \
    \
    echo ">>> Running invenio webpack buildall..." && \
    invenio webpack buildall && \
    \
    echo ">>> Copying local static/templates/translations OVER potentially collected/generated files..." && \
    cp -a /tmp/static/. ${INVENIO_INSTANCE_PATH}/static/ && \
    cp -a /tmp/templates/. ${INVENIO_INSTANCE_PATH}/templates/ && \
    cp -a /tmp/translations/. ${INVENIO_INSTANCE_PATH}/translations/ && \
    \
    echo ">>> Copying local uWSGI config..." && \
    # This now copies into /opt/invenio/var/instance/
    cp -a /tmp/uwsgi/. ${INVENIO_INSTANCE_PATH}/ && \
    \
    echo ">>> Cleaning up node_modules and caches..." && \
    rm -rf ${INVENIO_INSTANCE_PATH}/assets/node_modules && \
    pnpm store prune && \
    rm -rf /tmp/*


# ---- Runtime Stage ----
#------------------------

FROM ghcr.io/astral-sh/uv:alpine AS runtime

# Args & Env Vars
# CHANGED: Default instance path to match docker-compose command
ARG INVENIO_INSTANCE_PATH=/opt/invenio/var/instance

# CHANGED: Instance path ENV to match docker-compose command
ENV INVENIO_INSTANCE_PATH=${INVENIO_INSTANCE_PATH}
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8
# Set PATH to include the virtual environment copied from the builder
# Path will now include /opt/invenio/var/instance/.venv/bin
ENV PATH="${INVENIO_INSTANCE_PATH}/.venv/bin:${PATH}"

WORKDIR ${INVENIO_INSTANCE_PATH}

# Install runtime dependencies
RUN apk update && \
    apk add --no-cache \
        bash \
        cairo \
        font-dejavu \
        imagemagick \
        python3 \
        py3-setuptools \
        pcre2 \
        util-linux && \
    apk cache clean

# Copy the built application from the builder stage
# This copies /opt/invenio/var/instance from the builder
COPY --from=builder "${INVENIO_INSTANCE_PATH}" "${INVENIO_INSTANCE_PATH}"

# Ensure the application directory is writable by the group
RUN chmod -R g+w "${INVENIO_INSTANCE_PATH}" && \
    find ${INVENIO_INSTANCE_PATH}/.venv/bin/ -type f -exec chmod +x {} \;

EXPOSE 5000

ENTRYPOINT ["bash", "-c"]
