# repository-service-tuf-worker

Repository Service for TUF Worker

repository-service-tuf-worker is part of Repository Service for TUF (RSTUF)

## Getting Started

These instructions will cover usage information and for the docker container.

## Prerequisities


In order to run this container you'll need docker installed.

Other requirements include:

* repository-service-tuf-api service
* Compatible broker and result backend service with
  [Celery](https://docs.celeryq.dev/en/stable/getting-started/backends-and-brokers/index.html).
  Recomended: [RabbitMQ](https://www.rabbitmq.com) or [Redis](https://redis.com)
* PostgreSQL server
* Online key (see Online Key details below)

### Online Key
The RSTUF Worker requires an online key which is used for signing the TUF
metadata when a target is added or removed.

Here are some things you need to know:
* The key must be compatible with
  [Secure Systems Library](https://github.com/secure-systems-lab/securesystemslib).
  If you do not have a key we suggest you use the [RSTUF CLI tool to generate the key](https://repository-service-tuf.readthedocs.io/en/latest/guide/repository-service-tuf-cli/index.html).
* This key must be the same one used during the [RSTUF CLI ceremony](https://repository-service-tuf.readthedocs.io/en/latest/guide/repository-service-tuf-cli/index.html#ceremony-ceremony).
* This key must be available to RSTUF Worker using the `RSTUF_KEYVAULT_BACKEND`.

For more information read the [Deployment documentation](https://repository-service-tuf.readthedocs.io/en/latest/guide/deployment/index.html).

## Usage

### Container Parameters

```shell
docker run --env="RSTUF_STORAGE_BACKEND=LocalStorage" \
    --env="RSTUF_LOCAL_STORAGE_BACKEND_PATH=storage" \
    --env="RSTUF_KEYVAULT_BACKEND=LocalKeyVault" \
    --env="RSTUF_LOCAL_KEYVAULT_PASSWORD=mypass" \
    --env="RSTUF_BROKER_SERVER=guest:guest@rabbitmq:5672" \
    --env="RSTUF_REDIS_SERVER=redis://redis" \
    --env="RSTUF_SQL_SERVER=postgresql://postgres:secret@postgres:5432" \
    ghcr.io/repository-service-tuf/repository-service-tuf-worker:latest \
```


### Environment Variables

#### (Required) `RSTUF_BROKER_SERVER`

Broker server address.

The broker must to be compatible with Celery.
See [Celery Broker Instructions](https://docs.celeryq.dev/en/stable/getting-started/backends-and-brokers/index.html#broker-instructions)

Example: `guest:guest@rabbitmq:5672`

#### (Required) `RSTUF_REDIS_SERVER`

Redis server address.

The result backend must to be compatible with Celery. See
[Celery Task result backend settings](https://docs.celeryq.dev/en/stable/userguide/configuration.html#task-result-backend-settings)

Example: `redis://redis`

#### (Required) `RSTUF_SQL_SERVER`

SQL server address.

The SQL Server must to be compatible with
[SQLAlchemy](https://www.sqlalchemy.org). RSTUF recomends
[PostgreSQL](https://www.postgresql.org).

Example: `postgresql://postgres:secret@postgres:5432`

#### (Optional) `RSTUF_REDIS_SERVER_PORT`

Redis Server port number. Default: 6379

#### (Optional) `RSTUF_REDIS_SERVER_DB_RESULT`

Redis Server DB number for Result Backend (tasks). Default: 0

Important: It should use the same db id as used by RSTUF API.

#### (Optional) `RSTUF_REDIS_SERVER_DB_REPO_SETTINGS`

Redis Server DB number for repository settings. Default: 1

This settings are shared accress the Repository Workers
(``repository-service-tuf-worker``) to have dynamic configuration.

#### (Required) `RSTUF_STORAGE_BACKEND`

Select a supported type of Storage Service.

Available types:

* LocalStorage (local file system)
    - Requires variable ``RSTUF_LOCAL_STORAGE_BACKEND_PATH``
      - Define the directory where the data will be saved, example: `storage`

#### (Optional) `RSTUF_LOCK_TIMEOUT`

Timeout for publishing JSON metadata files. Default: 60.0 (seconds)

This timeout avoids race conditions leading to publishing JSON metadata files by multiple
Worker's services. It guarantees that the metadata is consistent in the backend
storage service (`RSTUF_STORAGE_BACKEND`).


In most use cases, the timeout of 60.0 seconds is sufficient.

#### (Required) `RSTUF_KEYVAULT_BACKEND`

Select a supported type of Key Vault Service.

Available types:

* LocalKeyVault (local file system)
  - Required variables:
    - ``RSTUF_LOCAL_KEYVAULT_PASSWORD``
      - password used to load the online key
  - Optional variables:
    - ``RSTUF_LOCAL_KEYVAULT_PATH``
      - file name of the online key
      - Default: `online.key`
    - ``RSTUF_LOCAL_KEYVAULT_TYPE``
      - cryptographic type of the online key, example: `ed25519`.
      - Default: `ed25519`
      - [Note: At the moment RSTUF Worker supports `ed25519`, `rsa`, `ecdsa`]

#### (Optional) `RSTUF_WORKER_ID`

Custom Worker ID.  Default: `hostname` (Container hostname)

#### (Optional) `DATA_DIR`

Container data directory. Default: `/data`


### Persistent data

* `$DATA_DIR`. Default: `/data`

### Customization/Tuning

The `repository-service-tuf-worker` uses supervisord and uses a
`supervisor.conf` from `$DATA_DIR`.

It can be used to customize/tuning performance of Celery.
