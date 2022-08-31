# kaprien-rest-api

kaprien-rest-api Rest API Service

kaprien-rest-api is part of Kaprien

## Getting Started

These instructions will cover usage information and for the docker container

## Prerequisities


In order to run this container you'll need docker installed.

Some required services:

* kaprien-repo-worker
* Compatible Borker Service with [Celery](http://docs.celeryq.dev/),
  recommended [RabbitMQ](https://www.rabbitmq.com) or
  [Redis](https://redis.com)


## Usage

### Container Parameters

```shell
docker run --env="KAPRIEN_RABBITMQ_SERVER=guest:guest@rabbitmq:5672" \
    --env="KAPRIEN_REDIS_SERVER=redis://redis" \
    --env="SECRETS_KAPRIEN_TOKEN_KEY=secret" \
    --env="SECRETS_KAPRIEN_ADMIN_PASSWORD=password" \
    ghcr.io/kaprien/kaprien-repo-worker:latest \
    uvicorn app:kaprien_app --host 0.0.0.0 --port 8000 --reload
```


### Environment Variables

#### `KAPRIEN_RABBITMQ_SERVER`

Broker server address. This is required.

Example: `guest:guest@rabbitmq:5672`

#### `KAPRIEN_REDIS_SERVER`

Description: Redis server address.. This is required.

Example: `redis://redis`

#### `SECRETS_KAPRIEN_TOKEN_KEY`

Secret Token to hash the Tokens. . This is required.


#### `SECRETS_KAPRIEN_ADMIN_PASSWORD`

Secret admin password. This is required.

### Volumes

* `/data` - File location
