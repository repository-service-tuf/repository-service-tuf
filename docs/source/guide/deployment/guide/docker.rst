======
Docker
======

This deployment uses Docker Engine and Docker Compose yaml file to deploy RSTUF.

.. Warning::
  * There are limitations to scaling this deployment strategy, as all nodes are
    running in the same host.

  * This deployment is recommended for Tests, Development, POC and POV.

  * This deployment does not use secrets for sensitive credentials.


.. note::
  See the complete :ref:`guide/deployment/planning/deployment:Deployment Configuration`
  for in-depth details.

Requirements
============

Software and tools
------------------

  * Docker Engine (with docker-compose)
  * Python >= 3.10
  * pip


Online Key
----------

This deployment requires the :ref:`guide/general/keys:Online Key`.
See the chapter :ref:`guide/general/keys:Signing Keys`

.. centered:: Skip this section if an online key has already been generated.

RSTUF Command Line Interface (CLI) provides a feature for
:ref:`guide/repository-service-tuf-cli/index:Key Generation (``generate\`\`)`

.. include:: ../../repository-service-tuf-cli/index.rst
    :start-after: Key Generation (``generate``)
    :end-before: Key Information (``info``)

Steps
=====

1. Create a folder ``local-keyvault`` and add the online key

  .. code:: shell

    $ mkdir local-keyvault
    $ cp path/my/online.key local-keyvault/

2. Create a Docker Compose (functional example below)

    ``docker-compose.yml``

    .. literalinclude:: docker-compose.yml
        :language: yaml
        :linenos:
        :name: docker-compose.yml


  The general explanation about this Docker Compose yaml file:

   * It uses Docker Volume for the persistent data and Volumes

    - ``rstuf-storage``: public TUF Metadata. Using RSTUF Worker with
      :ref:`LocalKeyVault storage backend <guide/deployment/planning/volumes:LocalStorage [Optional]>`.
    - ``rstuf-redis-data``: Persistent Redis data
    - ``rstuf-pgsql-data``: Persistent PostgresSQL data

   * It uses Redis for the :ref:`task results and RSTUF configuration <guide/deployment/planning/deployment:Result Backend and RSTUF Settings: Redis server>`.
   * It uses a simple python container as the webserver to expose the public
     TUF metadata from ``rstuf-storage`` volume
   * It provisions the ``repository-service-tuf-api`` configuration as
     environment variables:
     - Broker Server: ``RSTUF_BROKER_SERVER``
     - Redis Server: ``RSTUF_REDIS_SERVER``

   * It provisions the ``repository-service-tuf-worker`` configuration as
     environment variables:

     - Storage backend: ``RSTUF_STORAGE_BACKEND``, ``RSTUF_LOCAL_STORAGE_BACKEND_PATH``
     - Key Vault backend: ``RSTUF_KEYVAULT_BACKEND``, ``RSTUF_LOCAL_KEYVAULT_PATH``, ``RSTUF_LOCAL_KEYVAULT_KEYS``
     - Broker Server: ``RSTUF_BROKER_SERVER``
     - Redis Server: ``RSTUF_REDIS_SERVER``
     - SQL (Postgres) Server: ``RSTUF_SQL_SERVER``

3. Run using Docker stack

    .. code:: shell

        $ docker stack deploy -c docker-compose.yml rstuf
        Ignoring unsupported options: restart

        Creating network rstuf_default
        Creating service rstuf_redis
        Creating service rstuf_postgres
        Creating service rstuf_rstuf-worker
        Creating service rstuf_web-server
        Creating service rstuf_rstuf-api

4. Check if all services are running and health

  .. code:: shell

      $ docker ps -a
      CONTAINER ID   IMAGE                                                                 COMMAND                  CREATED              STATUS                        PORTS                                                                  NAMES
      f3eb8e38c244   postgres:15.1                                                         "docker-entrypoint.s…"   59 seconds ago       Up 58 seconds (healthy)       5432/tcp                                                               rstuf_postgres.1.n9bculkxiikst502oneq2y1tl
      00831512a35d   redis:4.0                                                             "docker-entrypoint.s…"   About a minute ago   Up About a minute (healthy)   6379/tcp                                                               rstuf_redis.1.gy8owq16qa0fbgyklr6ji1hyy
      a15dc8f6f3c9   ghcr.io/repository-service-tuf/repository-service-tuf-api:latest      "bash entrypoint.sh"     About a minute ago   Up About a minute                                                                                    rstuf_rstuf-api.1.o8zmoccz2n4vnxemczlrrg3o9
      40d410b9c6ff   python:3.10-slim-buster                                               "python -m http.serv…"   About a minute ago   Up About a minute                                                                                    rstuf_web-server.1.s29tparemtrj5tut6l41in8ah
      5762860c1ccc   ghcr.io/repository-service-tuf/repository-service-tuf-worker:latest   "bash entrypoint.sh"     About a minute ago   Up About a minute (healthy)                                                                          rstuf_rstuf-worker.1.aq20wunul0z9lla0nkpo303zn


  Verify ``rstuf_rstuf-worker`` logs

  .. code:: shell

      docker service logs rstuf_rstuf-worker --raw


5. RSTUF Ceremony and Bootstrap

  .. include:: ../setup.rst

Remove RSTUF deployment
=======================

Remove the Stack

.. code:: shell

  $ docker stack rm rstuf
  Removing service rstuf_rstuf-worker
  Removing service rstuf_rstuf-api
  Removing service rstuf_redis
  Removing service rstuf_web-server
  Removing network rstuf_default


Remove all data

.. code:: shell

  $ docker volume rm rstuf_repository-service-tuf-worker-data \
    rstuf_rstuf-storage \
    rstuf_rstuf-keystorage \
    rstuf_rstuf-redis-data \
