# tuf-repository-service-worker

TUF Repository Service Worker

tuf-repository-service-worker is part of TUF Repository Service (TRS)

## Getting Started

These instructions will cover usage information and for the docker container

## Prerequisities


In order to run this container you'll need docker installed.

Some required services:

* tuf-repository-service-api
* Compatible Borker and Result Backend Service with
  [Celery](https://docs.celeryq.dev/en/stable/getting-started/backends-and-brokers/index.html).
  Recomended: [RabbitMQ](https://www.rabbitmq.com) or [Redis](https://redis.com)

## Usage

### Container Parameters

```shell
docker run --env="TRS_WORKER_ID=worker1" \
    --env="TRS_STORAGE_BACKEND=LocalStorage" \
    --env="TRS_LOCAL_STORAGE_BACKEND_PATH=storage" \
    --env="TRS_KEYVAULT_BACKEND=LocalKeyVault" \
    --env="TRS_LOCAL_KEYVAULT_PATH=keyvault" \
    --env="TRS_BROKER_SERVER=guest:guest@rabbitmq:5672" \
    --env="TRS_REDIS_SERVER=redis://redis" \
    ghcr.io/kaprien/tuf-repository-service-worker:latest \
```


### Environment Variables

#### (Required) `TRS_BROKER_SERVER`

Broker server address.

The broker must to be compatible with Celery.
See [Celery Broker Instructions](https://docs.celeryq.dev/en/stable/getting-started/backends-and-brokers/index.html#broker-instructions)

Example: `guest:guest@rabbitmq:5672`

#### (Required) `TRS_REDIS_SERVER`

Redis server address.

The result backend must to be compatible with Celery. See
[Celery Task result backend settings](https://docs.celeryq.dev/en/stable/userguide/configuration.html#task-result-backend-settings)

Example: `redis://redis`

#### (Optional) `TRS_REDIS_SERVER_PORT`

Redis Server port number. Default: 6379

#### (Optional) `TRS_REDIS_SERVER_DB_RESULT`

Redis Server DB number for Result Backend (tasks). Default: 0

#### (Optional) `TRS_REDIS_SERVER_DB_REPO_SETTINGS`

Redis Server DB number for repository settings. Default: 1

This settings are shared accress the Repository Workers
(``tuf-repository-service-worker``) to have dynamic configuration.

#### (Required) `TRS_STORAGE_BACKEND`

Select a supported type of Storage Service.

Available types:

* LocalStorage (local file system)
    - Requires variable ``TRS_LOCAL_STORAGE_BACKEND_PATH``
      - Define the directory where the data will be saved, example: `storage`

#### (Required) `TRS_KEYVAULT_BACKEND`

Select a supported type of Key Vault Service.

Available types:

* LocalKeyVault (local file system)
  - Requires variable ``TRS_LOCAL_KEYVAULT_PATH``
    - Define the directory where the data will be saved, example: `keyvault`


#### (Optional) `DATA_DIR`

Container data directory. Default: `/data`

### Persistent data

* `$DATA_DIR`. Default: `/data`

### Customization/Tuning

The `tuf-repository-service-worker` uses supervisord and uses a `supervisor.conf`
from `$DATA_DIR`.

It can be used to customize/tuning performance of Celery.
