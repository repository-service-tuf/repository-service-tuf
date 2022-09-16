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

docker run -p 80:80 \
    --env="KAPRIEN_BROKER_SERVER=amqp://guest:guest@rabbitmq:5672" \
    --env="KAPRIEN_REDIS_SERVER=redis://redis" \
    --env="SECRETS_KAPRIEN_TOKEN_KEY=secret" \
    --env="SECRETS_KAPRIEN_ADMIN_PASSWORD=password" \
    ghcr.io/kaprien/kaprien-rest-api:latest
```


### Environment Variables

#### (Optional) `KAPRIEN_BOOTSTRAP_NODE`

The value type is boolean (true/false [case sensitive](https://www.dynaconf.com/configuration/#available-options)).
Default: false

Enable the container to be a bootstrap node.

If the container is enabled to be a bootstrap node, the endpoint `/api/v1/bootstrap` will be visible and accept connections using token authentication and scope `write:bootstrap`

#### (Required) `KAPRIEN_BROKER_SERVER`

Broker server address.

The broker must to be compatible with Celery. See [Celery Broker Instructions](https://docs.celeryq.dev/en/stable/getting-started/backends-and-brokers/index.html#broker-instructions)

Example: `amqp://guest:guest@rabbitmq:5672`

#### (Required) `KAPRIEN_REDIS_SERVER`

Redis server address.

The result backend must to be compatible with Celery. See
[Celery Task result backend settings](https://docs.celeryq.dev/en/stable/userguide/configuration.html#task-result-backend-settings)

Example: `redis://redis`

#### (Optional) `KAPRIEN_REDIS_SERVER_PORT`

Redis Server port number. Default: 6379

#### (Optional) `KAPRIEN_REDIS_SERVER_DB_RESULT`

Redis Server DB number for Result Backend (tasks). Default: 0

#### (Optional) `KAPRIEN_REDIS_SERVER_DB_REPO_SETTINGS`

Redis Server DB number for repository settings. Default: 1

This settings are shared accress the Repository Workers
(``kaprien-repo-worker``) to have dynamic configuration.

#### (Required) `SECRETS_KAPRIEN_TOKEN_KEY`

Secret Token for hash the Tokens.

#### (Required) `SECRETS_KAPRIEN_ADMIN_PASSWORD`

Secret admin password.


#### (Optional) `SECRETS_KAPRIEN_SSL_CERT`

SSL Certificate file. Example ``/path/to/api.crt``

Conainer running port will be 443

Requires a another environment variable ``SECRETS_KAPRIEN_SSL_KEY`` with the
certificate key file. Example ``/path/to/api.key``

#### (Optional) `DATA_DIR`

Data Directory. Default: `/data/`.

### Volumes

* `/data` - File location


### Ports

Default port 80

If using ``SECRETS_KAPRIEN_SSL_CERT``, port 443
