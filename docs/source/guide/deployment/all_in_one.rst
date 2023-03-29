===================================
All-in-one host deployment (Docker)
===================================

.. note::

  There are limitations to scaling this deployment strategy, as all nodes are
  running in the same host.

  This deployment is recommended for Tests, Development, POC and POV.

The All-in-one host deployment Repository Service for TUF (RSTUF) uses Docker
Engine and Docker Compose yaml file to deploy RSTUF and all the services as
containers.

Requirements
============

Software and tools
------------------

  * Docker Engine (with docker-compose)
  * Python >= 3.10
  * pip


Key management
--------------

As introduced before by :ref:`guide/deployment/index:RSTUF and TUF key management`,
this deployment requires an online key. You need to make sure
you have generated it and you can use it.

Steps
=====

1. Create a folder ``local-keyvault`` and add your online key

  .. code:: shell

    $ make local-keyvault
    $ cp path/my/online.key local-keyvault/

2. Prepare the Docker Swarm to store RSTUF credentials:


   * ``SECRETS_RSTUF_ADMIN_PASSWORD`` is the `admin`, user used to manage the
     RSTUF API Tokens.
   * ``SECRETS_RSTUF_TOKEN_KEY`` is the Token key used to hash the API Tokens.
   * ``SECRETS_RSTUF_ONLINE_KEY_PASSWORD`` is the online key password used by
workers for signing the TUF metadata.

    Initiating the Docker Swarm

    .. code:: shell

      $ docker swarm init

    RSTUF admin password

    .. code:: shell

      $ printf "secret-password" | docker secret create SECRETS_RSTUF_ADMIN_PASSWORD -

    RSTUF API token key

    .. code:: shell

      $ printf $(openssl rand -base64 32) | docker secret create SECRETS_RSTUF_TOKEN_KEY -

    RSTUF Worker online key password

    .. code:: shell

      $ printf "strongPass" | docker secret create SECRETS_RSTUF_ONLINE_KEY_PASSWORD -

    .. note::

      **HTTPS**

      Add your Certificate and your Key in the secrets

      .. code:: shell

        $ docker secret create API_KEY /path/to/api.key
        $ docker secret create API_CRT /path/to/api.crt


3. Create a Docker Compose (functional example below)

  The general explanation about this Docker Compose yaml file:

   * It uses Docker Volume for the persistent data.
   * It uses Docker Secrets to store/use the ``SECRETS_RSTUF_TOKEN_KEY``,
     ``SECRETS_RSTUF_ADMIN_PASSWORD`` and ``SECRETS_RSTUF_ONLINE_KEY_PASSWORD``.

     .. note::
        **HTTPS**

        Uncoment ``API_KEY`` and ``API_CRT`` in the `secrets` section
        (lines 18-22).

   * It uses RabbitMQ as a `broker` for the tasks.
   * It uses Redis for the task results and internal tasks.
   * It adds the ``repository-service-tuf-worker`` configuration as environment
     variables (storage/key vault type and paths, broker, backend, and repo
     worker id). The volumes for storage and key storage as Docker Volume.
   * It configures the ``repository-service-tuf-api`` using environment variables for
     the secrets, and the data as Docker Volume.

     .. note::
      **HTTPS**

      - Uncoment `repository-service-tuf-api environment`
        for the certificate and key (lines 103-106)
      - Uncoment the in `repository-service-tuf-api secrets` section (lines
        110-112)
      - (Optionally) Comment port 80:80 (line 77)

   - Web Server uses a Python container that exposes the docker volume with
     the Repository Metadata as  HTTP in 8080 port.

    ``docker-compose.yml``

    .. literalinclude:: docker-compose.yml
        :language: yaml
        :linenos:
        :name: docker-compose.yml



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
        Creating service rstuf_rabbitmq

4. Repository Ceremony

  This will generate the ``payload.json`` which containes the initial root
  TUF metadata and RSTUF settings.

  References:
    * :ref:`guide/deployment/index:RSTUF and TUF key management`,
    * :ref:`guide/deployment/index:TUF Metadata signing Ceremony`

  Install the RSTUF CLI, using pip

  .. code:: shell

    $ pip install repository-service-tuf

  Run the RSTUF Ceremony

  .. code:: shell

    $ rstuf admin ceremony


5. RSTUF Bootstrap

  To bootstrap your RSTUF deployment using the `payload.json` from previous
  step.

  .. code:: shell

    $ rstuf admin login
    $ rstuf admin ceremony -b -u -f payload.json

6. Importing existing repository targets

  If you want to import a huge existing data,
  see :ref:`guide/deployment/importing-targets:Importing existing targets`

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