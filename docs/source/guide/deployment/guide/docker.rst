======
Docker
======

.. Warning::
  There are limitations to scaling this deployment strategy, as all nodes are
  running in the same host.

  This deployment is recommended for Tests, Development, POC and POV.

.. Note::
    * For this deployment RabbitMQ will be used as the
      :ref:`message queue/broker <guide/deployment/planning/deployment:Message Queue/Broker: Redis or RabbitMQ server>`.

    * This deployment uses the built-in RSTUF Authentication/Authorization


The All-in-one host deployment Repository Service for TUF (RSTUF) uses Docker
Engine and Docker Compose yaml file to deploy RSTUF and all the services as
containers.

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

Steps
=====

1. Create a folder ``local-keyvault`` and add the online key

  .. code:: shell

    $ mkdir local-keyvault
    $ cp path/my/online.key local-keyvault/

2. Prepare the Docker Swarm to store RSTUF credentials:

   * ``SECRETS_POSTGRES_PASSWORD`` is the `postgres` password
   * ``SECRETS_RSTUF_ADMIN_PASSWORD`` is the `admin`, user used to manage the
     RSTUF API tokens.
   * ``SECRETS_RSTUF_TOKEN_KEY`` is the token key used to hash the API tokens.
   * ``SECRETS_RSTUF_ONLINE_KEY`` is the online key.

    Initiating the Docker Swarm

    .. caution::
        Do not use these credentials, as they are provided as example.

    .. code:: shell

      $ docker swarm init

    Postgres password

    .. code:: shell

      $ printf "secret-postgres" | docker secret create SECRETS_POSTGRES_PASSWORD -

    RSTUF admin password

    .. code:: shell

      $ printf "secret-password" | docker secret create SECRETS_RSTUF_ADMIN_PASSWORD -

    RSTUF API token key

    .. code:: shell

      $ printf $(openssl rand -base64 32) | docker secret create SECRETS_RSTUF_TOKEN_KEY -

    RSTUF Worker online key password

    .. code:: shell

      $ printf "online.key,strongPass" | docker secret create SECRETS_RSTUF_ONLINE_KEY -

    .. note::

      **HTTPS**

      Add the Certificate and the Key in the secrets

      .. code:: shell

        $ docker secret create API_KEY /path/to/api.key
        $ docker secret create API_CRT /path/to/api.crt


3. Create a Docker Compose (functional example below)

  The general explanation about this Docker Compose yaml file:

   * It uses Docker Volume for the persistent data and Volumes

    - ``rstuf-api-data``: Persist the
      :ref:`built-in RSTUF auth data <guide/deployment/planning/volumes:DATA [optional]>`.
    - ``rstuf-storage``: public TUF Metadata. Using RSTUF Worker with
      :ref:`LocalKeyVault storage backend <guide/deployment/planning/volumes:LocalStorage [Optional]>`.
    - ``rstuf-redis-data``: Persistent Redis data
    - ``rstuf-pgsql-data``: Persistent PostgresSQL data
    - ``rstuf-mq-data``:  Persistent RabbitMQ data

   * It uses Docker Secrets to store:

     - ``SECRETS_POSTGRES_PASSWORD``
     - ``SECRETS_RSTUF_TOKEN_KEY``
     - ``SECRETS_RSTUF_ADMIN_PASSWORD``
     - ``SECRETS_RSTUF_ONLINE_KEY``

     .. note::
        **HTTPS**

        Uncoment ``API_KEY`` and ``API_CRT`` in the `secrets` section
        (lines 18-22).

   * It uses RabbitMQ as the :ref:`broker/message queue <guide/deployment/planning/deployment:Message Queue/Broker: Redis or RabbitMQ server>`
   * It uses Redis for the :ref:`task results and RSTUF configuration <guide/deployment/planning/deployment:Result Backend and RSTUF Settings: Redis server>`.
   * It uses a simple python container as the webserver to expose the public
     TUF metadata from ``rstuf-storage``
   * It provisions the ``repository-service-tuf-api`` configuration as
     environment variables:
     - Broker Server: ``RSTUF_BROKER_SERVER``
     - Redis Server: ``RSTUF_REDIS_SERVER``
     - Enable the RSTUF Authentication/Authorization: ``RSTUF_AUTH``, ``SECRETS_RSTUF_TOKEN_KEY``, ``SECRETS_RSTUF_ADMIN_PASSWORD``

   * It provisions the ``repository-service-tuf-worker`` configuration as environment
     variables:

     - Storage backend: ``RSTUF_STORAGE_BACKEND``, ``RSTUF_LOCAL_STORAGE_BACKEND_PATH``
     - Key Vault backend: ``RSTUF_KEYVAULT_BACKEND``, ``RSTUF_LOCAL_KEYVAULT_PATH``, ``RSTUF_LOCAL_KEYVAULT_KEYS``
     - Broker Server: ``RSTUF_BROKER_SERVER``
     - Redis Server: ``RSTUF_REDIS_SERVER``
     - SQL (Postgres) Server: ``RSTUF_SQL_SERVER``, ``RSTUF_SQL_USER``, ``RSTUF_SQL_PASSWORD``


     .. note::
      **HTTPS**

      - Uncomment repository-service-tuf-api environment ``SECRETS_RSTUF_SSL_CERT``, ``SECRETS_RSTUF_SSL_KEY``
        for the certificate and key
      - Uncomment the in repository-service-tuf-api secrets section ``API_CRT``, ``API_KEY``
      - (Optionally) Comment port ``- 80:80``


    ``docker-compose.yml``

    .. literalinclude:: docker-compose.yml
        :language: yaml
        :linenos:
        :name: docker-compose.yml



4. Run using Docker stack

    .. code:: shell

        $ docker stack deploy -c docker-compose.yml rstuf
        Ignoring unsupported options: restart

        Creating network rstuf_default
        Creating service rstuf_redis
        Creating service rstuf_postgres
        Creating service rstuf_rstuf-worker
        Creating service rstuf_web-server
        Creating service rstuf_rstuf-api
        Creating service rstuf_rabbitmq

6. Check if all services are running and health

  .. code:: shell

      $ docker ps -a
      CONTAINER ID   IMAGE                                                                 COMMAND                  CREATED              STATUS                        PORTS                                                                  NAMES
      f3eb8e38c244   postgres:15.1                                                         "docker-entrypoint.s…"   59 seconds ago       Up 58 seconds (healthy)       5432/tcp                                                               rstuf_postgres.1.n9bculkxiikst502oneq2y1tl
      00831512a35d   redis:4.0                                                             "docker-entrypoint.s…"   About a minute ago   Up About a minute (healthy)   6379/tcp                                                               rstuf_redis.1.gy8owq16qa0fbgyklr6ji1hyy
      75be8062673e   rabbitmq:3-management-alpine                                          "docker-entrypoint.s…"   About a minute ago   Up About a minute (healthy)   4369/tcp, 5671-5672/tcp, 15671-15672/tcp, 15691-15692/tcp, 25672/tcp   rstuf_rabbitmq.1.rw9xdy0bc2n2vszayz8z6onij
      a15dc8f6f3c9   ghcr.io/repository-service-tuf/repository-service-tuf-api:latest      "bash entrypoint.sh"     About a minute ago   Up About a minute                                                                                    rstuf_rstuf-api.1.o8zmoccz2n4vnxemczlrrg3o9
      40d410b9c6ff   python:3.10-slim-buster                                               "python -m http.serv…"   About a minute ago   Up About a minute                                                                                    rstuf_web-server.1.s29tparemtrj5tut6l41in8ah
      5762860c1ccc   ghcr.io/repository-service-tuf/repository-service-tuf-worker:latest   "bash entrypoint.sh"     About a minute ago   Up About a minute (healthy)                                                                          rstuf_rstuf-worker.1.aq20wunul0z9lla0nkpo303zn


  Verify ``rstuf_rstuf-worker`` logs

  .. code:: shell

      docker service logs rstuf_rstuf-worker --raw


7. RSTUF Ceremony and Bootstrap

  .. include:: ../setup.rst

Uninstall All-in-one
====================

Remove the Stack

.. code:: shell

  $ docker stack rm rstuf
  Removing service rstuf_rstuf-worker
  Removing service rstuf_rstuf-api
  Removing service rstuf_rabbitmq
  Removing service rstuf_redis
  Removing service rstuf_web-server
  Removing network rstuf_default


Remove all data

.. code:: shell

  $ docker volume rm rstuf_repository-service-tuf-worker-data \
    rstuf_rstuf-storage \
    rstuf_rstuf-keystorage \
    rstuf_rstuf-redis-data \
    rstuf_rstuf-api-data \
    rstuf_rstuf-mq-data