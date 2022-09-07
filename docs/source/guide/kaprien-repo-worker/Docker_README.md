# kaprien-repo-worker

Kaprien Repository Worker

kaprien-repo-worker is part of Kaprien

## Getting Started

These instructions will cover usage information and for the docker container

## Prerequisities


In order to run this container you'll need docker installed.

Some required services:

* kaprien-rest-api
* Compatible Borker and Result Backend Service with
  [Celery](https://docs.celeryq.dev/en/stable/getting-started/backends-and-brokers/index.html).
  Recomended: [RabbitMQ](https://www.rabbitmq.com) or [Redis](https://redis.com)

## Usage

### Container Parameters

```shell
docker run --env="KAPRIEN_WORKER_ID=worker1" \
    --env="KAPRIEN_STORAGE_BACKEND=LocalStorage" \
    --env="KAPRIEN_LOCAL_STORAGE_BACKEND_PATH=storage" \
    --env="KAPRIEN_KEYVAULT_BACKEND=LocalKeyVault" \
    --env="KAPRIEN_LOCAL_KEYVAULT_PATH=keyvault" \
    --env="KAPRIEN_BROKER_SERVER=guest:guest@rabbitmq:5672" \
    --env="KAPRIEN_RESULT_BACKEND_SERVER=redis://redis" \
    ghcr.io/kaprien/kaprien-repo-worker:latest \
    celery -A app worker -B -l debug -Q metadata_repository -n kaprien@dev
```


### Environment Variables

#### (Required) `KAPRIEN_BROKER_SERVER`

Broker server address.

The broker must to be compatible with Celery.
See [Celery Broker Instructions](https://docs.celeryq.dev/en/stable/getting-started/backends-and-brokers/index.html#broker-instructions)

Example: `guest:guest@rabbitmq:5672`

#### (Required) `KAPRIEN_RESULT_BACKEND_SERVER`

Redis server address.

The result backend must to be compatible with Celery. See
[Celery Task result backend settings](https://docs.celeryq.dev/en/stable/userguide/configuration.html#task-result-backend-settings)

Example: `redis://redis`

#### (Required) `KAPRIEN_STORAGE_BACKEND`

Select a supported type of Storage Service.

Available types:

* LocalStorage (local file system)
    - Requires variable ``KAPRIEN_LOCAL_STORAGE_BACKEND_PATH``
      - Define the directory where the data will be saved, example: `storage`

#### (Required) `KAPRIEN_KEYVAULT_BACKEND`

Select a supported type of Key Vault Service.

Available types:

* LocalKeyVault (local file system)
  - Requires variable ``KAPRIEN_LOCAL_KEYVAULT_PATH``
    - Define the directory where the data will be saved, example: `keyvault`


#### (Optional) `DATA_DIR`

Container data directory. Default: `/data`

### Volumes

* `/data` - File location
