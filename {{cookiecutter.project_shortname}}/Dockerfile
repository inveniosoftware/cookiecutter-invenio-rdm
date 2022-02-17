# Dockerfile that builds a fully functional image of your app.
#
# This image installs all Python dependencies for your application. It's based
# on CentOS 7 with Python 3 (https://github.com/inveniosoftware/docker-invenio)
# and includes Pip, Pipenv, Node.js, NPM and some few standard libraries
# Invenio usually needs.
#
# Note: It is important to keep the commands in this file in sync with your
# bootstrap script located in ./scripts/bootstrap.

{% if cookiecutter.python_version.split()[0] == '3.6' -%}
FROM inveniosoftware/centos7-python:3.6
{%- elif cookiecutter.python_version.split()[0] == '3.7' -%}
FROM inveniosoftware/centos8-python:3.7
{%- elif cookiecutter.python_version.split()[0] == '3.8' -%}
FROM inveniosoftware/centos8-python:3.8
{%- elif cookiecutter.python_version.split()[0] == '3.9' -%}
# TODO: switch to official Invenio image when released
FROM python:3.9-slim-buster

# # install nodejs version 14
RUN curl -sL https://rpm.nodesource.com/setup_14.x | bash - && \
    yum install -y nodejs

# setuptools v58 removed 2to3 support: https://setuptools.pypa.io/en/latest/history.html#v58-0-0
# the `fs` package relies on `2to3`
RUN pip3.9 install --upgrade pip pipenv "setuptools<58" wheel

# Create working directory
ENV WORKING_DIR=/opt/invenio
ENV INVENIO_INSTANCE_PATH=${WORKING_DIR}/var/instance
RUN mkdir -p ${INVENIO_INSTANCE_PATH}

# Create files mountpoints
RUN mkdir ${INVENIO_INSTANCE_PATH}/data
RUN mkdir ${INVENIO_INSTANCE_PATH}/archive
RUN mkdir ${INVENIO_INSTANCE_PATH}/static

# copy everything inside /src
RUN mkdir -p ${WORKING_DIR}/src
WORKDIR ${WORKING_DIR}/src

# Set `npm` global under Invenio instance path
RUN mkdir ${INVENIO_INSTANCE_PATH}/.npm-global
ENV NPM_CONFIG_PREFIX=$INVENIO_INSTANCE_PATH/.npm-global
RUN mkdir npm_install && cd npm_install && \
    curl -SsL https://registry.npmjs.org/npm/-/npm-6.14.5.tgz | tar -xzf - && \
    cd package && \
    node bin/npm-cli.js rm npm -g && \
    node bin/npm-cli.js install -g $(node bin/npm-cli.js pack | tail -1) && \
    cd ../.. && rm -rf npm_install

RUN npm config set prefix '${INVENIO_INSTANCE_PATH}/.npm-global'
ENV PATH=${INVENIO_INSTANCE_PATH}/.npm-global/bin:$PATH

# Set folder permissions
ENV INVENIO_USER_ID=1000
RUN chgrp -R 0 ${WORKING_DIR} && \
    chmod -R g=u ${WORKING_DIR}
RUN useradd invenio --uid ${INVENIO_USER_ID} --gid 0 && \
    chown -R invenio:root ${WORKING_DIR}
{%- endif %}

COPY Pipfile Pipfile.lock ./
RUN pipenv install --deploy --system --pre

COPY ./docker/uwsgi/ ${INVENIO_INSTANCE_PATH}
COPY ./invenio.cfg ${INVENIO_INSTANCE_PATH}
COPY ./templates/ ${INVENIO_INSTANCE_PATH}/templates/
COPY ./app_data/ ${INVENIO_INSTANCE_PATH}/app_data/
COPY ./ .

RUN cp -r ./static/. ${INVENIO_INSTANCE_PATH}/static/ && \
    cp -r ./assets/. ${INVENIO_INSTANCE_PATH}/assets/ && \
    invenio collect --verbose  && \
    invenio webpack create && \
    invenio webpack install --unsafe && \
    invenio webpack build

ENTRYPOINT [ "bash", "-c"]
