#!/usr/bin/env bash
# SPDX-FileCopyrightText: 2019 CERN.
# SPDX-FileCopyrightText: 2019 Northwestern University.
# SPDX-FileCopyrightText: 2024-2025 KTH Royal Institute of Technology.
# SPDX-License-Identifier: MIT

# quit on errors:
set -o errexit

# quit on unbound symbols:
set -o nounset

WORKDIR=$(mktemp -d)
TESTDIR=$(pwd)

finish() {
    echo "Cleaning up."
    docker compose -f ${PROJECTDIR}/docker-compose.full.yml down --volumes --remove-orphans &
    rm -rf "${PROJECTDIR}/.venv" || true
    rm -rf "${WORKDIR}"
    echo "Test setup cleaned."
}

trap finish EXIT

PROJECT_NAME="my-site"
export PROJECT_NAME

cookiecutter --no-input -o "$WORKDIR" . \
    project_name=${PROJECT_NAME} \
    base_image=${COOKIECUTTER_BASE_IMAGE:-debian} \
    database=${COOKIECUTTER_DATABASE:-postgresql} \
    opensearch=${COOKIECUTTER_OPENSEARCH:-opensearch2} \
    file_storage=${COOKIECUTTER_FILE_STORAGE:-local}

PROJECTDIR=${WORKDIR}/${PROJECT_NAME}
export PROJECTDIR

# Check local installation (this also generates the uv.lock)
${TESTDIR}/scripts/bootstrap

cd ${PROJECTDIR}

# Initialize git in the repository for 'check-manifest' to work
git init
git add -A

# Update MANIFEST.in
uv run --with check-manifest check-manifest -u || true

# Build application docker images
${TESTDIR}/scripts/build-images.sh
# Fire up a full instance via docker-compose.full.yml
# We will use the services (DB, OS/ES, etc) for running the tests locally
docker compose -f docker-compose.full.yml up -d
${TESTDIR}/scripts/wait-for-services.sh --full
echo "All services are up."

docker compose -f docker-compose.full.yml down
echo "Services successfully stopped"

# Fire up the services we need for testing
docker compose up -d
${TESTDIR}/scripts/wait-for-services.sh
# Run the instance tests
# REQUIREMENTS=prod ./run-tests.sh
