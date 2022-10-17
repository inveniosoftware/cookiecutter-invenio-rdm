#!/usr/bin/env sh
#
# -*- coding: utf-8 -*-
#
# This file is part of Invenio.
#
# Copyright (C) 2019 CERN.
# Copyright (C) 2019 Northwestern University.
#
# Invenio is free software; you can redistribute it and/or modify it
# under the terms of the MIT License; see LICENSE file for more details.
#

echo "-------------------------------------------------------------------------------"
echo
echo "Generating SSL certificate and private key for testing...."

openssl req -x509 -newkey rsa:4096 -nodes -out docker/nginx/test.crt -keyout docker/nginx/test.key -days 365 -subj "/C=CH/ST=./L=./O=./OU=./CN=localhost/emailAddress=."

echo "-------------------------------------------------------------------------------"

{%- if cookiecutter.file_storage == 'S3' %}
mkdir -p data/default
touch data/default/.gitkeep
{%- endif %}

{%- if cookiecutter.site_code == 'no'%}
DIR="site"
if [ -d "$DIR" ]; then
  rm -r site
fi
{% endif %}
