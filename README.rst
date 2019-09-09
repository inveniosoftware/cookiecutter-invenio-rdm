# Cookiecutter Invenio RDM

## Steps

``` console
# --- INIT ---
$ cookiecutter gh:inveniosoftware/cookiecutter-invenio-rdm --checkout dev
$ cd my-site # This will go to python working_dir
$ pipenv lock # It can be handled by the user

# --- BUILD ---
$ docker build -f Dockerfile.base -t my-site-base:latest .
$ docker build -t my-site:latest .

# --- SERVER ---
# Might need to increase virtual memory to avoid OOM (code 78)
# sudo sysctl -w vm.max_map_count=524288
$ docker-compose up

# --- SETUP --- # JUST ONCE

# PROD
$ docker exec ${CONTAINER_ID} /bin/bash -c "/bin/bash /opt/invenio/src/scripts/bootstrap"
$ docker exec ${CONTAINER_ID} /bin/bash -c "/bin/bash /opt/invenio/src/scripts/setup"

# DEV
$ scripts/bootstrap
$ scripts/setup --dev
$ scripts/server

# --- USE IT! ---

# PROD
$ curl -k -H "Content-Type: application/json" https://localhost/api/records/

# DEV
$ curl -k -H "Content-Type: application/json" https://localhost:5000/api/records/


# --- UPGRADE ---
# Run a pipenv upgrade inside the docker container and echo the output outside the container
# to the pipenv.lock file so the user has it
$ generate pipenv.lock files

```

NOTE: Pipfile contains Github commits as reference for:
    - invenio-rdm-records
    - invenio-app-rdm
    - invenio-records-permissions

## Upgrade instructions

- UPGRADE
- BUILD
- SERVER