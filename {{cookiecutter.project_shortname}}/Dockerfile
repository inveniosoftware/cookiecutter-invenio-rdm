#
# Dockerfile that builds a fully functional image of your app.
#
# Note: It is important to keep the commands in this file in sync with your
# boostrap script located in ./scripts/bootstrap.
#
# In order to increase the build speed, we are extending this image from a base
# image (built with Dockerfile.base) which only includes your Python
# dependencies.

ARG DEPENDENCIES_VERSION=latest
FROM {{cookiecutter.project_shortname}}-base:${DEPENDENCIES_VERSION}

COPY ./ .
COPY ./docker/uwsgi/ ${INVENIO_INSTANCE_PATH}

RUN invenio collect -v  && \
    invenio webpack create && \
    # --unsafe needed because we are running as root
    invenio webpack install --unsafe && \
    invenio webpack build

ENV INVENIO_THEME_LOGO='images/logo.svg'
ADD ./{{cookiecutter.project_shortname}}/static/images/logo.svg ${INVENIO_INSTANCE_PATH}/static/images/logo.svg

ENTRYPOINT [ "bash", "-c"]
