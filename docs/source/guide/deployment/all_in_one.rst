===================================
All-in-one host deployment (Docker)
===================================

The All-in-one host deployment is the simplest way to Deploy Repository Service
for TUF Server.
There are limitations to scaling this deployment (limited to the host).

This deployment will use Docker Stack with Docker Compose and Docker Swarn for
the Token and Admin user password.

Requirements
============

    - Docker Engine (with docker-compose)
    - Python >= 3.10
    - pip


Steps
=====

1. Prepare the Docker Swarm credentials Repository Service for TUF API admin user and a random
   Token Key.

   -  ``RSTUF_ADMIN_PASSWORD`` is the initial password for `admin`
   -  ``SECRETS_RSTUF_TOKEN_KEY`` it the TOKEN KEY used to hash the API Tokens

    .. code:: shell

      $ docker swarm init
      $ printf "secret password" | docker secret create SECRETS_RSTUF_ADMIN_PASSWORD -
      $ printf $(openssl rand -base64 32) | docker secret create SECRETS_RSTUF_TOKEN_KEY -

    .. note::

      **HTTPS**

      Add your Certificate and your Key in the secrets

      .. code:: shell

        $ docker secret create API_KEY /path/to/api.key
        $ docker secret create API_CRT /path/to/api.crt


2. Create a Docker Compose (functional example above)

   - It uses Docker Volume for the persistent data.
   - It uses Docker Secrets to store/use the ``RSTUF_TOKEN_KEY`` (Used to
     generate API Tokens) and ``RSTUF_ADMIN_PASSWORD``.

     .. note::
        **HTTPS**

        Uncoment ``API_KEY`` and ``API_CRT`` in the `secrets` section
        (lines 18-21).

   - It uses RabbitMQ as a `broker` for the tasks.
   - It uses Redis for the task results and internal tasks.
   - It adds the ``repository-service-tuf-worker`` configuration as environment
     variables (storage/key vault type and paths, broker, backend, and repo
     worker id). The volumes for storage and key storage as Docker Volume.
   - It configures the ``repository-service-tuf-api`` using environment variables for
     the secrets, and the data as Docker Volume.

     .. note::
      **HTTPS**

      - Uncoment environment variables for the certificate and key (lines 86-87)
      - Uncoment the in `repository-service-tuf-api secrets` section (lines 93-93)
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
        Creating service rstuf_rstuf-worker
        Creating service rstuf_web-server
        Creating service rstuf_rstuf-api
        Creating service rstuf_rabbitmq
        Creating service rstuf_redis

4. Repository Ceremony

    It will require the :ref:`guide/repository-service-tuf-cli/index:Repository Service for TUF CLI`.

    Once you have the service running is required to do the
    :ref:`guide/repository-service-tuf-cli/index:Ceremony (``ceremony\`\`)`.

    The Ceremony is the process of creating the initial signed Repository
    Metadata.

    Example of Ceremony process using Repository Service for TUF CLI.

    .. raw:: html

      <div style="position: relative; padding-bottom: 56.25%; height: 0; margin-bottom: 2em; overflow: hidden; max-width: 100%; height: auto;">
        <iframe src="https://www.youtube.com/embed/1SK703ZTTwM" frameborder="0" allowfullscreen style="position: absolute; top: 0; left: 0; width: 100%; height: 100%;"></iframe>
      </div>


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