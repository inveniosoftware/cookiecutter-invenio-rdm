..
    This file is part of Invenio.
    Copyright (C) 2019 CERN.
    Copyright (C) 2019-2025 Northwestern University.

    Invenio is free software; you can redistribute it and/or modify it
    under the terms of the MIT License; see LICENSE file for more details.

==============================
 Cookiecutter-Invenio-RDM
==============================

.. image:: https://img.shields.io/github/license/inveniosoftware/cookiecutter-invenio-rdm.svg
        :target: https://github.com/inveniosoftware/cookiecutter-invenio-rdm/blob/master/LICENSE

This `Cookiecutter <https://github.com/audreyr/cookiecutter>`_ template is
designed to help you to bootstrap an `InvenioRDM
<https://inveniordm.docs.cern.ch/>`_ instance. It is used under the hood by
`invenio-cli <https://github.com/inveniosoftware/invenio-cli>`_,
the command line tool to install InvenioRDM, so under normal circumstances you should not have
to use this directly. Please follow the InvenioRDM installation documentation at https://inveniordm.docs.cern.ch/install/
instead.

If for some reason you want to run this manually nevertheless, follow the instuctions below.

Manual usage
------------

Install the latest Cookiecutter if you haven't installed it yet::

    pip install -U cookiecutter

Generate your InvenioRDM files::

    cookiecutter https://github.com/inveniosoftware/cookiecutter-invenio-rdm.git -c <version>

Replace ``<version>`` by the tag in this repository corresponding to the version of InvenioRDM you are targeting.
