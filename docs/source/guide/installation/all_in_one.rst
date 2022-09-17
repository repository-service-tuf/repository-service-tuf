=====================================
All-in-one host installation (Docker)
=====================================

The All-in-one host installation is the simplest way to Deploy Kaprien Server.
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

1. Prepare the Docker Swarm credentials Kaprien API admin user and a random
   Token Key.

   -  ``KAPRIEN_ADMIN_PASSWORD`` is the initial password for `admin`
   -  ``SECRETS_KAPRIEN_TOKEN_KEY`` it the TOKEN KEY used to hash the API Tokens

    .. code:: shell

      $ docker swarm init
      $ printf "secret password" | docker secret create SECRETS_KAPRIEN_ADMIN_PASSWORD -
      $ printf $(openssl rand -base64 32) | docker secret create SECRETS_KAPRIEN_TOKEN_KEY -

    .. note::

      **HTTPS**

      Add your Certificate and your Key in the secrets

      .. code:: shell

        $ docker secret create API_KEY /path/to/api.key
        $ docker secret create API_CRT /path/to/api.crt


2. Create a Docker Compose (functional example above)

   - It uses Docker Volume for the persistent data.
   - It uses Docker Secrets to store/use the ``KAPRIEN_TOKEN_KEY`` (Used to
     generate API Tokens) and ``KAPRIEN_ADMIN_PASSWORD``.

     .. note::
        **HTTPS**

        Uncoment ``API_KEY`` and ``API_CRT`` in the `secrets` section
        (lines 18-21).

   - It uses RabbitMQ as a `broker` for the tasks.
   - It uses Redis for the task results and internal tasks.
   - It adds the ``kaprien-repo-worker`` configuration as environment
     variables (storage/key vault type and paths, broker, backend, and repo
     worker id). The volumes for storage and key storage as Docker Volume.
   - It configures the ``kaprien-rest-api`` using environment variables for
     the secrets, and the data as Docker Volume.

     .. note::
      **HTTPS**

      - Uncoment environment variables for the certificate and key (lines 86-87)
      - Uncoment the in `kaprien-rest-api secrets` section (lines 93-93)
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

        $ docker stack deploy -c docker-compose.yml kaprien
        Ignoring unsupported options: restart

        Creating network kaprien_default
        Creating service kaprien_kaprien-repo-worker
        Creating service kaprien_web-server
        Creating service kaprien_kaprien-rest-api
        Creating service kaprien_rabbitmq
        Creating service kaprien_redis


4. Repository Ceremony


    Once you have the service running is required to do the
    :ref:`guide/kaprien-cli/index:Ceremony (``ceremony\`\`)`.

    The Ceremony is the process of creating the initial signed Repository
    Metadata.

    Example of Ceremony process using Kaprien CLI.

    .. raw:: html

      <div style="position: relative; padding-bottom: 56.25%; height: 0; margin-bottom: 2em; overflow: hidden; max-width: 100%; height: auto;">
        <iframe src="https://www.youtube.com/embed/VuLQCT-7Qkk" frameborder="0" allowfullscreen style="position: absolute; top: 0; left: 0; width: 100%; height: 100%;"></iframe>
      </div>


Uninstall All-in-one
====================

Remove the Stack

.. code:: shell

  $ docker stack rm kaprien
  Removing service kaprien_kaprien-repo-worker
  Removing service kaprien_kaprien-rest-api
  Removing service kaprien_rabbitmq
  Removing service kaprien_redis
  Removing service kaprien_web-server
  Removing network kaprien_default


Remove all data

.. code:: shell

  $ docker volume rm kaprien_kaprien-repo-worker-data \
    kaprien_kaprien-storage \
    kaprien_kaprien-keystorage \
    kaprien_kaprien-redis-data \
    kaprien_kaprien-rest-api-data \
    kaprien_kaprien-mq-data