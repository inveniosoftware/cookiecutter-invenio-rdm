..
    This file is part of Invenio.
    Copyright (C) 2019 CERN.
    Copyright (C) 2019 Northwestern University.

    Invenio is free software; you can redistribute it and/or modify it
    under the terms of the MIT License; see LICENSE file for more details.

==============================
 Cookiecutter-Invenio-RDM
==============================

.. image:: https://img.shields.io/github/license/inveniosoftware/cookiecutter-invenio-rdm.svg
        :target: https://github.com/inveniosoftware/cookiecutter-invenio-rdm/blob/master/LICENSE

.. image:: https://img.shields.io/travis/inveniosoftware/cookiecutter-invenio-rdm.svg
        :target: https://travis-ci.org/inveniosoftware/cookiecutter-invenio-rdm

This `Cookiecutter <https://github.com/audreyr/cookiecutter>`_ template is
designed to help you to bootstrap an `Invenio
<https://github.com/inveniosoftware/invenio>`_ service.

Quickstart
----------

Install the latest Cookiecutter if you haven't installed it yet::

    pip install -U cookiecutter

Generate your Invenio RDM instance::

    cookiecutter https://github.com/inveniosoftware/cookiecutter-invenio-rdm.git -c v1.0

More detailed steps can be found in the https://inveniosoftware.org/#getstarted

Features
--------

- **Python package:** Python package for your service.
- **Boilerplate files:** `README` including important badges.
- **License:** `MIT <https://opensource.org/licenses/MIT>`_ file and headers.
- ** TODO **


Configuration
-------------
To generate correct files, please provide the following input to Cookiecutter:

============================ ==============================================================
`project_name`                Full project name, might contain spaces.
`project_shortname`           Project shortname, no spaces allowed, use `-` as a
                              separator.
`project_site`                Project website host.
`package_name`                Package/Module name for Python, must follow `PEP 0008
                              <https://www.python.org/dev/peps/pep-0008/>`_.
`github_repo`                 GitHub repository of the project in form of `USER/REPO`,
                              not the full GitHub URL.
`site_code`                   Project code folder. Used for extending existing codebase.
`**TODO**`                    `**TODO**`
============================ ==============================================================
