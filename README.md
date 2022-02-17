<!-- This file is part of Invenio.
Copyright (C) 2019 CERN.
Copyright (C) 2019 Northwestern University.

    Invenio is free software; you can redistribute it and/or modify it
    under the terms of the MIT License; see LICENSE file for more details. -->

# Cookiecutter-OARepo-Instance

This [Cookiecutter](https://github.com/audreyr/cookiecutter) template is designed to help you to bootstrap an OARepo flavour of [Invenio](https://github.com/inveniosoftware/invenio) instance service.

## Quickstart

Install the latest Cookiecutter if you haven't installed it yet::

    pip install -U cookiecutter

Generate your OARepo instance:

    cookiecutter https://github.com/oarepo/cookiecutter-oarepo-instance.git

More detailed steps can be found in the <https://inveniosoftware.org/#getstarted>

## Features

- **Python package:** Python package for your service.
- **Boilerplate files:** `README` including important badges.
- **License:** [MIT](https://opensource.org/licenses/MIT) file and headers.
- **TODO**

## Configuration

To generate correct files, please provide the following input to Cookiecutter:

- `project_name` Full project name, might contain spaces.
- `project_shortname` Project shortname, no spaces allowed, use `-` as a separator.
- `project_site` Project website host.
- `package_name` Package/Module name for Python, must follow `PEP 0008 <https://www.python.org/dev/peps/pep-0008/>`\_.
- `github_repo` GitHub repository of the project in form of `USER/REPO`, not the full GitHub URL.
- `app_package` Name of an [OARepo application package](https://github.com/oarepo/cookiecutter-oarepo-app) this site should be using.
- `**TODO**` `**TODO**`
