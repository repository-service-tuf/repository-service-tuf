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

Steps
=====

1. Create a folder ``local-keyvault`` and add the online key

  .. code:: shell

    $ mkdir local-keyvault
    $ cp path/my/keys/0d9d3d4bad91c455bc03921daa95774576b86625ac45570d0cac025b08e65043 local-keyvault/

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
     - Online Key directory: ``RSTUF_ONLINE_KEY_DIR``
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
      a15dc8f6f3c9   ghcr.io/repository-service-tuf/repository-service-tuf-api:latest      "bash entrypoint.sh"     About a minute ago   Up About a minute                                                                                    rstuf_rstuf-api.1.o8zmoccz2n4vnxemczlrrg3o9
      5762860c1ccc   ghcr.io/repository-service-tuf/repository-service-tuf-worker:latest   "bash entrypoint.sh"     About a minute ago   Up About a minute (healthy)                                                                          rstuf_rstuf-worker.1.aq20wunul0z9lla0nkpo303zn
      7dcc51a56f4d   redis:8.0.0-alpine3.21                                                "docker-entrypoint.s…"   About a minute ago   Up About a minute (healthy)     0.0.0.0:6379->6379/tcp, [::]:6379->6379/tcp                          repository-service-tuf-redis-1
      9e56cb40a145   python:3.13-slim                                                      "python -m http.serv…"   About a minute ago   Up About a minute               0.0.0.0:8080->8080/tcp, [::]:8080->8080/tcp                          repository-service-tuf-web-1
      fcd0dd134d5c   postgres:17.5-alpine3.21                                              "docker-entrypoint.s…"   About a minute ago   Up About a minute (healthy)     0.0.0.0:5433->5432/tcp, [::]:5433->5432/tcp                          repository-service-tuf-postgres-1
      cd7095179f70   python:3.13-slim                                                      "python -V"              About a minute ago   Exited (0) About a minute ago                                                                        repository-service-tuf-rstuf-ft-runner-1

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
