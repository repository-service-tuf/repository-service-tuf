##########
RSTUF mini
##########

.. warning::
    RSUF mini is recommend for demonstration or tests only.
    Do not use it in production! See our
    :ref:`guide/deployment/guide/docker:Docker` or
    :ref:`guide/deployment/guide/kubernetes:Kubernetes` deployments guide.

RSTUF mini are scripts and a series of files used to quickly run RSTUF
deployment (using Docker) using latest versions available.

.. note::

    .. collapse::
        Downloads and Installation

        * Downloads

          -  docker-compose.yml
          -  RSTUF keys

        * Installations

          - Repository Service for TUF Python Package (Command Line Interface)
            and its dependencies

Quick start
###########

Requirements
============

- Docker CLI >= 24.0.0
- Docker Engine >= 24.0.0
- Python

Create a directory
==================

.. code:: console

    $ mkdir rstuf-mini
    $ cd rstuf-mini


Download RSTUF mini
===================

.. code:: console

    $ wget https://raw.githubusercontent.com/repository-service-tuf/repository-service-tuf/rstuf_mini/rstuf-mini/rstuf-mini.sh
    $ chmod +x rstuf-mini.sh


Running RSTUF mini
==================