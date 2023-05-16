
FROM oarepo/oarepo-base-development:11
ARG REPOSITORY_SITE_NAME
ENV SITE_DIR=/repository/sites/${REPOSITORY_SITE_NAME}

RUN ${INVENIO_VENV}/bin/pip install -U pipenv

RUN mkdir /repository

COPY ./ui /repository/ui
COPY ./models /repository/models
COPY ./sites /repository/sites

WORKDIR ${SITE_DIR}
RUN ls -la .
RUN cp invenio.cfg ${INVENIO_INSTANCE_PATH}

RUN ${INVENIO_VENV}/bin/pipenv requirements > requirements-orig.txt
RUN cat requirements-orig.txt | \
    egrep -iv '^cffi=|^cairocffi=|^uwsgi=|^packaging=|^pip=|^setuptools=|^pyparsing=|^xcffib=|^cchardet=' \
    > requirements.txt

RUN ${INVENIO_VENV}/bin/pip install -r requirements.txt --no-deps
RUN ${INVENIO_VENV}/bin/pip check || echo "check failed. cairocffi and pypackaging should be expected"

RUN cp -r ./static/. ${INVENIO_INSTANCE_PATH}/static/ && \
    cp -r ./assets/. ${INVENIO_INSTANCE_PATH}/assets/ && \
    ${INVENIO_CLI} collect --verbose  && \
    ${INVENIO_CLI} webpack buildall