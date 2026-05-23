#!/usr/bin/env bash
# SPDX-FileCopyrightText: 2019-2020 CERN.
# SPDX-FileCopyrightText: 2019-2020 Northwestern University.
# SPDX-License-Identifier: MIT

cd ${PROJECTDIR}

# Build application image
docker build . --tag ${PROJECT_NAME} --build-arg include_assets=true
