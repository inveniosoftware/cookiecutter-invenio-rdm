# syntax=docker/dockerfile:1
#
# SPDX-FileCopyrightText: {{ cookiecutter.year }} Northwestern University.
# SPDX-FileCopyrightText: {{ cookiecutter.year }} Frontmatter.
# SPDX-FileCopyrightText: {{ cookiecutter.year }} KTH Royal Institute of Technology.
# SPDX-License-Identifier: MIT

{%- if cookiecutter.base_image == "debian" %}
FROM ghcr.io/inveniosoftware/invenio:14-debian AS base

FROM base AS builder

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
