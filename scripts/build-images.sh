#!/usr/bin/env bash

# -*- coding: utf-8 -*-
#
# This file is part of Invenio.
#
# Copyright (C) 2019-2020 CERN.
# Copyright (C) 2019-2020 Northwestern University.
#
# Invenio is free software; you can redistribute it and/or modify it
# under the terms of the MIT License; see LICENSE file for more details.

cd ${PROJECTDIR}

# Build application image
docker build . --tag ${PROJECT_NAME}
