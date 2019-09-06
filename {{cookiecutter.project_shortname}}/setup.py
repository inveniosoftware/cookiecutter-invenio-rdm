"""{{ cookiecutter.description }}"""

import os

from setuptools import find_packages, setup

readme = open('README.rst').read()

packages = find_packages()

# Get the version string. Cannot be done with import!
g = {}


# TODO: Remove invenio-records-permissions and invenio-rdm-records from Pipfile
# Packages should be in setup.py in ``invenio-app-rdm``.
setup(
    name='{{ cookiecutter.project_shortname }}',
    version='1.0.0',
    description=__doc__,
    long_description=readme,
    keywords='{{ cookiecutter.project_shortname }} Invenio',
    license='MIT',
    author='{{ cookiecutter.author_name }}',
    author_email='{{ cookiecutter.author_email }}',
    url='https://github.com/{{ cookiecutter.github_repo }}',
    packages=packages,
    zip_safe=False,
    include_package_data=True,
    platforms='any',
    entry_points={

    },
    classifiers=[
        'Environment :: Web Environment',
        'Intended Audience :: Developers',
        'License :: OSI Approved :: MIT License',
        'Operating System :: OS Independent',
        'Programming Language :: Python',
        'Topic :: Internet :: WWW/HTTP :: Dynamic Content',
        'Programming Language :: Python :: 3',
        'Programming Language :: Python :: 3.6',
        'Development Status :: 3 - Alpha',
    ],
)
