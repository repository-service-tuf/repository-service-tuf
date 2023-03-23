==========
Deployment
==========

RSTUF Services and tools
========================

Repository Service for TUF (RSTUF) is a combination of micro-services provided
as containers:

 - :ref:`guide/repository-service-tuf-api/index:Repository Service for TUF API`  (``repository-service-tuf-api``)
 - :ref:`guide/repository-service-tuf-worker/index:Repository Service for TUF Worker` (``repository-service-tuf-worker``)


Those RSTUF services also require some auxiliary services

- Broker server (Redis or RabbitMQ)
- Redis server
- PostgreSQL server

Repository Service for TUF (RSTUF) also provides a Command Line Interface tool
to manage your RSTUF deployment.

 - :ref:`guide/repository-service-tuf-cli/index:Repository Service for TUF CLI`  (``repository-service-tuf-cli``)

RSTUF and TUF key management
============================

RSTUF deployment will require some keys as defined by The Update Framework
(TUF).

RSTUF uses these for signing the initial Root TUF Metadata and adding/removing
targets to the TUF Metadata.

During the deployment, it will require key(s) for Root and one key used by the
RSTUF Worker service (the "online key").

The Root key(s)
`should be stored secured offline <https://theupdateframework.github.io/specification/latest/#key-management-and-migration>`_.

The online key will be provided during the deployment configuration and used in
a supported
`Key Vault Service <https://repository-service-tuf.readthedocs.io/en/latest/guide/repository-service-tuf-worker/Docker_README.html#required-rstuf-keyvault-backend>`_
by the RSTUF Worker service.

Deployment Guides
=================

Bellow, there are some documentations to guide the RSTUF deployment.

.. toctree::
   :maxdepth: 1

   all_in_one
   custom_deployment
