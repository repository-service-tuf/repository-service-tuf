##########
Deployment
##########

RSTUF is provided as a set of Container Images that can be deployed in various environments.
This section provides guides for deploying RSTUF in different environments.

For a more detailed guide on planning a deployment,
see :ref:`guide/deployment/planning/deployment:Deployment Configuration`.

Deployment Guides
#################

.. toctree::
   :maxdepth: 2

   guide/quick-start
   guide/helm
   guide/docker
   guide/kubernetes

Configuration and Setup
#######################

.. toctree::
   :maxdepth: 2

   setup

Deployment Planning
###################

.. toctree::
   :maxdepth: 3

   planning/deployment
   planning/volumes
   planning/services
   planning/networking


Security Updates and Maintenance
-------------------------------

Deployments should be kept up to date to apply security patches.

The RSTUF deployment includes multiple components that require regular updates:
* API (Repository Service for TUF API)
* Worker (Repository Service for TUF Worker)
* Redis (message queue and result backend)
* PostgreSQL (metadata storage)

Update Strategy
===============

Regularly pull updated Docker images and restart services to apply changes.

Example update workflow:

.. code-block:: shell

   docker compose pull
   docker compose up -d

Security Communication
======================

Security updates are communicated through:
* GitHub Releases
* GitHub Security Advisories

Operational Responsibility
==========================

Administrators should monitor for updates and apply patches in a timely manner.

Updates should be tested before being applied to production systems.

