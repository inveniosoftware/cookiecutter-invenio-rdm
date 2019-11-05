#!/usr/bin/env bash
# -*- coding: utf-8 -*-
#
# This file is part of Invenio.
#
# Copyright (C) 2019 CERN.
# Copyright (C) 2019 Northwestern University.
#
# Invenio is free software; you can redistribute it and/or modify it
# under the terms of the MIT License; see LICENSE file for more details.

# quit on errors:
set -o errexit

# quit on unbound symbols:
set -o nounset

WORKDIR=$(mktemp -d)

finish() {
    echo "Cleaning up."
    docker-compose -f docker-compose.full.yml down --volumes --remove-orphans &
    pipenv --rm || true
    rm -rf "${WORKDIR}"
}

trap finish EXIT

PROJECT_NAME="my-site"

cookiecutter --no-input -o "$WORKDIR" . \
    project_name=${PROJECT_NAME} \
    database=${COOKIECUTTER_DATABASE:-postgresql} \
    elasticsearch=${COOKIECUTTER_ELASTICSEARCH:-elasticsearch6}

cd "${WORKDIR}/${PROJECT_NAME}"

# Check local installation (this also generates the Pipfile.lock)
./scripts/bootstrap

# Initialize git in the repository for 'check-manifest' to work
git init
git add -A

# Update MANIFEST.in
pipenv run check-manifest -u || true

# Build application docker images
./docker/build-images.sh
# Fire up a full instance via docker-compose.full.yml
# We will use the services (DB, ES, etc) for running the tests locally
docker-compose -f docker-compose.full.yml up -d
./docker/wait-for-services.sh --full
echo "All services are up."

docker-compose -f docker-compose.full.yml down
echo "Services successfully stopped"

# Fire up the services we need for testing
docker-compose up -d
./docker/wait-for-services.sh
# Run the instance tests
# REQUIREMENTS=prod ./run-tests.sh
