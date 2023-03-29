==========
Deployment
==========

RSTUF Services and Tools
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

The root key(s)
`should be stored secured offline <https://theupdateframework.github.io/specification/latest/#key-management-and-migration>`_.

The online key will be provided during the deployment configuration and used in
a supported
`Key Vault Service <https://repository-service-tuf.readthedocs.io/en/latest/guide/repository-service-tuf-worker/Docker_README.html#required-rstuf-keyvault-backend>`_
by the RSTUF Worker service.

RSTUF CLI provides a feature to generate keys.
See :ref:`guide/repository-service-tuf-cli/index:Repository Service for TUF CLI`

The deployment will require the online key to deploy and start RSTUF Worker
service(s).

The Update Framework requires all these keys (root and online key) to generate
the initial metadata. This process is the ceremony of signing the TUF metadata.

TUF Metadata Signing Ceremony
=============================

This process generates the initial metadata and defines some settings of your
TUF service (such as metadata expiration, root signing threshold, etc.).

To make this process easier,
the :ref:`guide/repository-service-tuf-cli/index:Repository Service for TUF CLI`
provides an interactive guided process to perform the ceremony.

We have a video to show this process.

   .. raw:: html

      <div style="position: relative; padding-bottom: 56.25%; height: 0; margin-bottom: 2em; overflow: hidden; max-width: 100%; height: auto;">
         <iframe src="https://www.youtube.com/embed/j18NvkNfs2A" frameborder="0" allowfullscreen style="position: absolute; top: 0; left: 0; width: 100%; height: 100%;"></iframe>
      </div>

Deployment Guides
=================

Bellow, there are some documentations to guide the RSTUF deployment.

.. toctree::
   :maxdepth: 1

   all_in_one
   custom_deployment
