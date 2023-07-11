########################
Deployment Configuration
########################

The Deployment Planning aims to give in-depth details to RSTUF users that will
plan a more customized deployment.

This document describes all the aspects of deploying RSTUF independent of the
environment and focuses on the technology stacks required by RSTUF services.

This document also complements our straightforward deployment guides for
:ref:`guide/deployment/guide/docker:Docker` and
:ref:`guide/deployment/guide/kubernetes:Kubernetes` with some detailed
nformation.

.. image:: /_static/2_2_rstuf.png

Required Infrastructure Services
################################

Repository Service for TUF API and Worker some infrastructure services.

* :ref:`guide/deployment/planning/deployment:Message Queue/Broker: Redis or RabbitMQ server`
* :ref:`guide/deployment/planning/deployment:Result Backend and RSTUF Settings: Redis server`
* :ref:`guide/deployment/planning/deployment:Database: Postgres server`
* :ref:`guide/deployment/planning/deployment:[Optional] Content Server: Webserver`

Message Queue/Broker: Redis or RabbitMQ server
==============================================

* https://redis.io
* https://www.rabbitmq.com

RSTUF API and RSTUF Worker will use the message queue/broker.

RSTUF support Redis or RabbitMQ server. The decision to choose Redis or
RabbitMQ depends on your needs.

RSTUF uses Celery, and here you can find a `summary about Celery and these two
brokers <https://docs.celeryq.dev/en/stable/getting-started/backends-and-brokers/index.html#summaries>`_.

.. Caution::
   Make sure the Redis or RabbitMQ uses a persistent storage.

.. centered:: RSTUF configuration

* ``RSTUF_BROKER_SERVER`` :ref:`RSTUF API <guide/repository-service-tuf-api/Docker_README:(Required) `RSTUF_BROKER_SERVER\`>`
* ``RSTUF_BROKER_SERVER`` :ref:`RSTUF Worker <guide/repository-service-tuf-worker/Docker_README:(Required) `RSTUF_BROKER_SERVER\`>`

.. Caution::
   Both services, RSTUF API and Worker, must to access the same message
   queue/broker.

.. Note::
   RSTUF API and Worker can use an existing Redis or RabbitMQ server in your
   infrastructure.
   A specific Redis database id or specific RabbitMQ vhost is recommended.

   Give it a complete address to the ``RSTUF_BROKER_SERVER`` configuration on
   RSTUF API and Worker.

   - Example using Redis database id **5**: ``RSTUF_BROKER_SERVER=redis://redis/5``
   - Example using RabbitMQ vhost **rstuf_vhost**: ``RSTUF_BROKER_SERVER="amqp://guest:guest@rabbitmq:5672/rstuv_vhost"``

.. Note::
    RSTUF requires Redis server as a
    :ref:`result backend <guide/deployment/planning/deployment:Result Backend and RSTUF Settings: Redis server>`.

    If Redis server is a good choice for you as a message queue/broker, using
    this will simplify your deployment as it reduces one technology stack.


Result Backend and RSTUF Settings: Redis server
===============================================

* https://redis.io

RSTUF API and RSTUF Worker will use this Redis server as a backend result and
to store RSTUF Settings.

Every request to RSTUF API is a unique task. The task result is stored in the
backend result for `24 hours <https://docs.celeryq.dev/en/stable/userguide/configuration.html#result-expires>`_.

.. Caution::
   Make sure the Redis uses a persistent storage.

.. centered:: RSTUF configuration

* ``RSTUF_REDIS_SERVER`` :ref:`RSTUF API <guide/repository-service-tuf-api/Docker_README:(Required) `RSTUF_REDIS_SERVER\`>`
* ``RSTUF_REDIS_SERVER`` :ref:`RSTUF Worker <guide/repository-service-tuf-worker/Docker_README:(Required) `RSTUF_REDIS_SERVER\`>`

.. Caution::
   Both services, RSTUF API and Worker, must to access the same Redis.

.. Note::
   If you use Redis as a message queue/broker, you can use the same
   service/instance as the result backend and RSTUF repository settings.

   The advice is to keep the broker, result backend, and RSTUF settings in
   different Redis database ids.

   RSTUF provides optional settings in the container for it

   * ``RSTUF_REDIS_SERVER_DB_RESULT`` :ref:`RSTUF API <guide/repository-service-tuf-api/Docker_README:(Optional) `RSTUF_REDIS_SERVER_DB_RESULT\`>`
   * ``RSTUF_REDIS_SERVER_DB_RESULT`` :ref:`RSTUF Worker <guide/repository-service-tuf-worker/Docker_README:(Optional) `RSTUF_REDIS_SERVER_DB_RESULT\`>`
   * ``RSTUF_REDIS_SERVER_DB_REPO_SETTINGS`` :ref:`RSTUF API <guide/repository-service-tuf-api/Docker_README:(Optional) `RSTUF_REDIS_SERVER_DB_REPO_SETTINGS\`>`
   * ``RSTUF_REDIS_SERVER_DB_REPO_SETTINGS`` :ref:`RSTUF Worker <guide/repository-service-tuf-worker/Docker_README:(Optional) `RSTUF_REDIS_SERVER_DB_REPO_SETTINGS\`>`

   For example, if we are setting up a deployment that will use Redis as a
   broker, result backend, and settings, we could have a configuration for RSTUF
   API and Workers where we use respective Redis database ids 5, 6, and 7.

   .. code::

      RSTUF_BROKER_SERVER=redis://redis/5
      RSTUF_REDIS_SERVER=redis://redis
      RSTUF_REDIS_SERVER_DB_RESULT=6
      RSTUF_REDIS_SERVER_DB_REPO_SETTINGS=7

Database: Postgres server
=========================

* https://www.postgresql.org

Only the RSTUF Worker uses the Postgres server

It uses the database to perform the TUF metadata management.

.. Caution::
   Make sure the Postgres uses a persistent storage.

.. centered:: RSTUF configuration

* ``RSTUF_SQL_SERVER`` :ref:`RSTUF Worker <guide/repository-service-tuf-worker/Docker_README:(Required) `RSTUF_SQL_SERVER\`>`

[Optional] Content Server: Webserver
====================================

The content server is responsible for exposing the TUF metadata managed by the
RSTUF Worker(s). This metadata will be used by some TUF client implementations
such as python-tuf, go-tuf, etc.

We recommend a web server listing all JSON files stored and managed by RSTUF
Worker(s).

Suggestion:

* https://apache.org
* https://www.nginx.com


RSTUF
#####

RSTUF Worker configuration
==========================

Key Vault Backend Service
-------------------------

The Key Vault Backend Service is responsible for storing the
:ref:`guide/general/keys:Online Key`.

* :ref:`guide/repository-service-tuf-worker/Docker_README:(Required) `RSTUF_KEYVAULT_BACKEND\``

.. Warning::
    DO NOT EXPOSE THIS CONTENT. It must be restricted to the RSTUF Workers.

Storage Backend Service
-----------------------

The Storage Backend Service is responsible for storing
:ref:`guide/general/Introduction:TUF Metadata`.

* :ref:`guide/repository-service-tuf-worker/Docker_README:(Required) `RSTUF_STORAGE_BACKEND\``

.. Note::
    This content is the TUF Metadata and must to be exposed to TUF clients.

RSTUF best practices
====================

HTTP Rest API
-------------

Do not expose the HTTP REST API if it is not necessary

If you are integrating RSTUF into a specific content management or
distribution platform, restrict the API access to the hosts where this
integration is done.

If you need to expose public RSTUF API, deploy RSTUF API containers with
disabled administrative endpoints.

See:

* ``RSTUF_DISABLED_ENDPOINTS`` :ref:`RSTUF API <guide/repository-service-tuf-api/Docker_README:(Optional) `RSTUF_DISABLED_ENDPOINTS\`>`


Authentication/Authorization
----------------------------

Use the Authentication/Authorization to restrict scopes

Use such an API Gateway to manage API endpoints' access.

RSTUF API has a built-in authentication service, but we consider this feature
not for production. We recommend using external authentication technology.

SSL/HTTPS
---------

Use HTTPS on RSTUF API (SSL certificates).

RSTUF API supports SSL Certificates. We recommend enabling and using trusted
certificates.

See:

* ``SECRETS_RSTUF_SSL_CERT`` :ref:`RSTUF API <guide/repository-service-tuf-api/Docker_README:(Optional) `SECRETS_RSTUF_SSL_CERT\`>`

Secrets
-------

Use secrets always for sensitive configuration.

RSTUF API supports using secrets in the container deployment for sensitive
environment variables settings.
See :ref:`RSTUF API <guide/repository-service-tuf-api/Docker_README:Environment Variables>`
and :ref:`RSTUF Worker <guide/repository-service-tuf-api/Docker_README:Environment Variables>`
Environment variables for more details.

Scaling
-------

You can deploy multiple RSTUF API and Worker instances/replicas in a
distributed environment to support multiple HTTP Requests and
increase workload for processing the TU Metadata.
