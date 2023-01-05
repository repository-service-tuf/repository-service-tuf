# repository-service-tuf-worker

Repository Service for TUF Worker

repository-service-tuf-worker is part of Repository Service for TUF (RSTUF)

## Getting Started

These instructions will cover usage information and for the docker container

## Prerequisities


In order to run this container you'll need docker installed.

Some required services:

* repository-service-tuf-api
* Compatible Borker and Result Backend Service with
  [Celery](https://docs.celeryq.dev/en/stable/getting-started/backends-and-brokers/index.html).
  Recomended: [RabbitMQ](https://www.rabbitmq.com) or [Redis](https://redis.com)

## Usage

### Container Parameters

```shell
docker run --env="RSTUF_WORKER_ID=worker1" \
    --env="RSTUF_STORAGE_BACKEND=LocalStorage" \
    --env="RSTUF_LOCAL_STORAGE_BACKEND_PATH=storage" \
    --env="RSTUF_KEYVAULT_BACKEND=LocalKeyVault" \
    --env="RSTUF_LOCAL_KEYVAULT_PATH=keyvault" \
    --env="RSTUF_BROKER_SERVER=guest:guest@rabbitmq:5672" \
    --env="RSTUF_REDIS_SERVER=redis://redis" \
    ghcr.io/vmware/repository-service-tuf-worker:latest \
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

#### (Required) `RSTUF_KEYVAULT_BACKEND`

Select a supported type of Key Vault Service.

Available types:

* LocalKeyVault (local file system)
  - Requires variable ``RSTUF_LOCAL_KEYVAULT_PATH``
    - Define the directory where the data will be saved, example: `keyvault`


#### (Optional) `DATA_DIR`

Container data directory. Default: `/data`

### Persistent data

* `$DATA_DIR`. Default: `/data`

### Customization/Tuning

The `repository-service-tuf-worker` uses supervisord and uses a `supervisor.conf`
from `$DATA_DIR`.

It can be used to customize/tuning performance of Celery.
