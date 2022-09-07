# kaprien-rest-api

kaprien-rest-api Rest API Service

kaprien-rest-api is part of Kaprien

## Getting Started

These instructions will cover usage information and for the docker container

## Prerequisities


In order to run this container you'll need docker installed.

Some required services:

* kaprien-repo-worker
* Compatible Borker and Result Backend Service with
  [Celery](https://docs.celeryq.dev/en/stable/getting-started/backends-and-brokers/index.html).
  Recomended: [RabbitMQ](https://www.rabbitmq.com) or [Redis](https://redis.com)


## Usage

### Container Parameters

```shell
docker run --env="KAPRIEN_BROKER_SERVER=amqp://guest:guest@rabbitmq:5672" \
    --env="KAPRIEN_RESULT_BACKEND_SERVER=redis://redis" \
    --env="SECRETS_KAPRIEN_TOKEN_KEY=secret" \
    --env="SECRETS_KAPRIEN_ADMIN_PASSWORD=password" \
    ghcr.io/kaprien/kaprien-repo-worker:latest \
    uvicorn app:kaprien_app --host 0.0.0.0 --port 8000 --reload
```


### Environment Variables

#### (Required) `KAPRIEN_BROKER_SERVER`

Broker server address.

The broker must to be compatible with Celery. See [Celery Broker Instructions](https://docs.celeryq.dev/en/stable/getting-started/backends-and-brokers/index.html#broker-instructions)

Example: `amqp://guest:guest@rabbitmq:5672`

#### (Required) `KAPRIEN_RESULT_BACKEND_SERVER`

Redis server address.

The result backend must to be compatible with Celery. See
[Celery Task result backend settings](https://docs.celeryq.dev/en/stable/userguide/configuration.html#task-result-backend-settings)

Example: `redis://redis`

#### (Required) `SECRETS_KAPRIEN_TOKEN_KEY`

Secret Token for hash the Tokens.

#### (Required) `SECRETS_KAPRIEN_ADMIN_PASSWORD`

Secret admin password.

#### (Optional) `DATA_DIR`

Data Directory. Default: `/data/`.

### Volumes

* `/data` - File location
