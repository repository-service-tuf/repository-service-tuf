=====================================
All-in-one host installation (Docker)
=====================================

The All-in-one host installation is the simplest way to Deploy TUF Repository Service Server.
There are limitations to scaling this installation (limited to the host).

This deployment will use Docker Stack with Docker Compose and Docker Swarn for
the Token and Admin user password.

Requirements
============

    - Docker Engine (with docker-compose)
    - Python >= 3.10
    - pip


Steps
=====

1. Prepare the Docker Swarm credentials TUF Repository Service API admin user and a random
   Token Key.

   -  ``TRS_ADMIN_PASSWORD`` is the initial password for `admin`
   -  ``SECRETS_TRS_TOKEN_KEY`` it the TOKEN KEY used to hash the API Tokens

    .. code:: shell

      $ docker swarm init
      $ printf "secret password" | docker secret create SECRETS_TRS_ADMIN_PASSWORD -
      $ printf $(openssl rand -base64 32) | docker secret create SECRETS_TRS_TOKEN_KEY -

    .. note::

      **HTTPS**

      Add your Certificate and your Key in the secrets

      .. code:: shell

        $ docker secret create API_KEY /path/to/api.key
        $ docker secret create API_CRT /path/to/api.crt


2. Create a Docker Compose (functional example above)

   - It uses Docker Volume for the persistent data.
   - It uses Docker Secrets to store/use the ``TRS_TOKEN_KEY`` (Used to
     generate API Tokens) and ``TRS_ADMIN_PASSWORD``.

     .. note::
        **HTTPS**

        Uncoment ``API_KEY`` and ``API_CRT`` in the `secrets` section
        (lines 18-21).

   - It uses RabbitMQ as a `broker` for the tasks.
   - It uses Redis for the task results and internal tasks.
   - It adds the ``tuf-repository-service-worker`` configuration as environment
     variables (storage/key vault type and paths, broker, backend, and repo
     worker id). The volumes for storage and key storage as Docker Volume.
   - It configures the ``tuf-repository-service-api`` using environment variables for
     the secrets, and the data as Docker Volume.

     .. note::
      **HTTPS**

      - Uncoment environment variables for the certificate and key (lines 86-87)
      - Uncoment the in `tuf-repository-service-api secrets` section (lines 93-93)
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

        $ docker stack deploy -c docker-compose.yml trs
        Ignoring unsupported options: restart

        Creating network trs_default
        Creating service trs_tuf-repository-service-worker
        Creating service trs_web-server
        Creating service trs_tuf-repository-service-api
        Creating service trs_rabbitmq
        Creating service trs_redis

4. Repository Ceremony

    It will require the CLI :ref:`guide/tuf-repository-service-cli/index:Installation`.

    Once you have the service running is required to do the
    :ref:`guide/tuf-repository-service-cli/index:Ceremony (``ceremony\`\`)`.

    The Ceremony is the process of creating the initial signed Repository
    Metadata.

    Example of Ceremony process using TUF Repository Service CLI.

    .. raw:: html

      <div style="position: relative; padding-bottom: 56.25%; height: 0; margin-bottom: 2em; overflow: hidden; max-width: 100%; height: auto;">
        <iframe src="https://www.youtube.com/embed/1SK703ZTTwM" frameborder="0" allowfullscreen style="position: absolute; top: 0; left: 0; width: 100%; height: 100%;"></iframe>
      </div>


Uninstall All-in-one
====================

Remove the Stack

.. code:: shell

  $ docker stack rm trs
  Removing service trs_tuf-repository-service-worker
  Removing service trs_tuf-repository-service-api
  Removing service trs_rabbitmq
  Removing service trs_redis
  Removing service trs_web-server
  Removing network trs_default


Remove all data

.. code:: shell

  $ docker volume rm trs_tuf-repository-service-worker-data \
    trs_tuf-repository-service-storage \
    trs_tuf-repository-service-keystorage \
    trs_tuf-repository-service-redis-data \
    trs_tuf-repository-service-api-data \
    trs_tuf-repository-service-mq-data