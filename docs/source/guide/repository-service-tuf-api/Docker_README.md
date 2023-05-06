# repository-service-tuf-api

repository-service-tuf-api API Service

repository-service-tuf-api is part of Repository Service for TUF (RSTUF)

## Getting Started

These instructions will cover usage information and for the docker container

## Prerequisities


In order to run this container you'll need docker installed.

Some required services:

* repository-service-tuf-worker
* Compatible Borker and Result Backend Service with
  [Celery](https://docs.celeryq.dev/en/stable/getting-started/backends-and-brokers/index.html).
  Recomended: [RabbitMQ](https://www.rabbitmq.com) or [Redis](https://redis.com)


## Usage

### Container Parameters

```shell

docker run -p 80:80 \
    --env="RSTUF_BROKER_SERVER=amqp://guest:guest@rabbitmq:5672" \
    --env="RSTUF_REDIS_SERVER=redis://redis" \
    --env="SECRETS_RSTUF_TOKEN_KEY=secret" \
    --env="SECRETS_RSTUF_ADMIN_PASSWORD=password" \
    ghcr.io/repository-service-tuf/repository-service-tuf-api:latest
```


### Environment Variables

#### (Required) `RSTUF_BROKER_SERVER`

Broker server address.

The broker must to be compatible with Celery. See [Celery Broker Instructions](https://docs.celeryq.dev/en/stable/getting-started/backends-and-brokers/index.html#broker-instructions)

Example: `amqp://guest:guest@rabbitmq:5672`

#### (Required) `RSTUF_REDIS_SERVER`

Redis server address.

#### (Optional) `RSTUF_REDIS_SERVER_PORT`

Redis Server port number. Default: 6379

#### (Optional) `RSTUF_REDIS_SERVER_DB_RESULT`

Redis Server DB number for Result Backend (tasks). Default: 0

Important: It should use the same db id as used by RSTUF Workers.

#### (Optional) `RSTUF_REDIS_SERVER_DB_REPO_SETTINGS`

Redis Server DB number for repository settings. Default: 1

These settings are shared with the repository workers
(``repository-service-tuf-worker``) to have dynamic configuration.

Important: It should use the same db id as used by RSTUF Workers.

#### (Optional) `RSTUF_AUTH`

Disable/Enable RSTUF built-in token authentication. Default: false

* Required variables (when enabled):
  - `SECRETS_RSTUF_TOKEN_KEY`
    Secret Token for hash the Tokens.

  - `SECRETS_RSTUF_ADMIN_PASSWORD`
    Secret admin password.

  These environment variables support container secrets when the volume is added
  to `/run/secrets` path.

  Example:
  ```
  SECRETS_RSTUF_ADMIN_PASSWORD=/run/secrets/SECRETS_RSTUF_ADMIN_PASSWORD
  SECRETS_RSTUF_TOKEN_KEY=/run/secrets/SECRETS_RSTUF_TOKEN_KEY`
  ```



#### (Optional) `RSTUF_DISABLED_ENDPOINTS`

Disable specific endpoints or endpoint methods from the API.

This variable receives a list separetad by `:`.

You can disable a whole endpoint.
For example:
`RSTUF_DISABLED_ENDPOINTS = "/api/v1/targets"`
Will disable all methods and all paths  related to v1 `targets`:  
GET `/api/v1/targets`, POST `/api/v1/targets`, POST `/api/v1/targets/publish` etc.

It is possible to disable a specific method endpoint with:
`{'POST'}/api/v1/targets/publish`.

Note: If you give both
`RSTUF_DISABLE_ENDPOINTS={'POST'}/api/v1/targets/publish:/api/v1/targets` then
the `/api/v1/targets` has a higher priority and will disable all v1 targets related endpoints.

A list can be given as shown in the example bellow:
`RSTUF_DISABLE_ENDPOINTS={'POST'}/api/v1/bootstrap/:/api/v1/metadata/:/api/v1/token/:{'DELETE'}/api/v1/targets/`


#### (Optional) `SECRETS_RSTUF_SSL_CERT`

SSL Certificate file. Example ``/path/to/api.crt``

Conainer running port will be 443

Requires a another environment variable ``SECRETS_RSTUF_SSL_KEY`` with the
certificate key file. Example ``/path/to/api.key``

These environment variables supports container secrets when the volume is added
to `/run/secrets` path.

Example:
```
SECRETS_RSTUF_SSL_CERT=/run/secrets/SECRETS_RSTUF_SSL_CERT
SECRETS_RSTUF_SSL_KEY=/run/secrets/SECRETS_RSTUF_SSL_KEY
```

#### (Optional) `DATA_DIR`

Data Directory. Default: `/data/`.

### Volumes

* `/data` - File location


### Ports

Default port 80

If using ``SECRETS_RSTUF_SSL_CERT``, port 443
