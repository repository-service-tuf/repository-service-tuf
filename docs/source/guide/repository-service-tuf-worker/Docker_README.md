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
    --env="RSTUF_LOCAL_KEYVAULT_PATH=keyvault" \
    --env="RSTUF_LOCAL_KEYVAULT_KEYS=online.key,strongPass" \
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

RSTUF requires [PostgreSQL](https://www.postgresql.org).

Example: `postgres:secret@postgres:5432`

* Optional variables:

  * `RSTUF_SQL_USER` optional information about the user name

    If using this optional variable:
    - Do not include the user in the `RSTUF_SQL_SERVER`.
    - The `RSTUF_SQL_PASSWORD` becomes required

  * `RSTUF_SQL_PASSWORD` use this variable to provide the password separately.
    - Do not include the password in the `RSTUF_SQL_SERVER`
    - This environment variable supports container secrets when the `/run/secrets`
      volume is added to the path.

  Example:
  ```
  RSTUF_SQL_SERVER=sqlserver:5432
  RSTUF_SQL_USER=postgres
  RSTUF_SQL_PASSWORD=/run/secrets/POSTGRES_PASSWORD
  ```

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

* `LocalStorage` (container volume)
* `AWSS3` (AWS S3)

##### `LocalStorage` (container volume)

* (Required) ``RSTUF_LOCAL_STORAGE_BACKEND_PATH``

  - Define the directory where the data will be saved, example: `storage`

##### `AWSS3` (AWS S3)

* (Required) ``RSTUF_AWSS3_STORAGE_BUCKET``

  The name of the region associated with the S3.

* (Required) ``RSTUF_AWSS3_STORAGE_ACCESS_KEY``

  The access key to use when creating the client session to the S3.

  This environment variable supports container secrets when the ``/run/secrets``
  volume is added to the path.
  Example: `RSTUF_AWSS3_STORAGE_ACCESS_KEY=/run/secrets/S3_ACCESS_KEY`

* (Required) ``RSTUF_AWSS3_STORAGE_SECRET_KEY``

  The secret key to use when creating the client session to the S3.

  This environment variable supports container secrets when the ``/run/secrets``
  volume is added to the path.
  Example: ``RSTUF_AWSS3_STORAGE_ACCESS_KEY=/run/secrets/S3_SECRET_KEY``

* (Optional) ``RSTUF_AWSS3_STORAGE_REGION``

  The name of the region associated with the S3.

* (Optional) ``RSTUF_AWSS3_STORAGE_ENDPOINT_URL``

  The complete URL to use for the constructed client. Normally, the
  client automatically constructs the appropriate URL to use when
  communicating with a service.

**_NOTE:_**  The AWS3 supports all `boto3`
[environment variables](https://boto3.amazonaws.com/v1/documentation/api/latest/guide/configuration.html#using-environment-variables).

#### (Optional) `RSTUF_LOCK_TIMEOUT`

Timeout for publishing JSON metadata files. Default: 60.0 (seconds)

This timeout avoids race conditions leading to publishing JSON metadata files by multiple
Worker's services. It guarantees that the metadata is consistent in the backend
storage service (`RSTUF_STORAGE_BACKEND`).

In most use cases, the timeout of 60.0 seconds is sufficient.

#### `RSTUF_KEYVAULT_BACKEND`

Select a supported type of Key Vault Service. 
Available types:

* `LocalKeyVault` (container volume)

**_NOTE:_** You can start the worker
service without a keyvault backend, but you need to configure one before the 
[bootstrap ceremony](https://repository-service-tuf.readthedocs.io/en/latest/guide/repository-service-tuf-cli/index.html#ceremony-ceremony).

##### `LocalKeyVault` (container volume)

* (Required) ``RSTUF_LOCAL_KEYVAULT_PATH``

  Define the path for the container volume mounted
  Example: ``RSTUF_LOCAL_KEYVAULT_PATH=/var/opt/repository-service-tuf/key_storage``

* (Required) ``RSTUF_LOCAL_KEYVAULT_KEYS``

  Define the key(s) with format ``<file>,<password>,<(optional) type>``

  - `file`: defines the key file
    + `base64|<key content in base64>` allows to inform directly the key content.
      It will dynamically manage and write a key file in
      ``RSTUF_LOCAL_KEYVAULT_PATH`` (write permissions required).

      Requires content as base64.

      Example: ``RSTUF_LOCAL_KEYVAULT_KEYS=base64|LnRveC8KdmVudi8KLmlkZWEvCi52c2NvZGUvC...,strongPass,rsa``

  - `password`: credential used to load the key
  - (optional) `type`: The key type. Default: `ed25519`

    [Note: At the moment RSTUF Worker supports `ed25519`, `rsa`, `ecdsa`]

    Example: ``RSTUF_LOCAL_KEYVAULT_KEYS=online.key,strongPass,rsa``

  Accepts multiple keys separated by "``:``".

  It accepts multiple keys, but RSTUF supports the usage of only one
  online key for signing.

  The Local Key Vault will find the key that matches the online key
  defined in the root metadata.

  Allowing multiple keys is helpful for performing metadata/key
  rotation without disruption.

  Example: ``RSTUF_LOCAL_KEYVAULT_KEYS=online.key,strongPass:online-rsa.key,newStrongPass,rsa``

  This environment variable supports container secrets when the
  ``/run/secrets`` volume is added to the path. The content must be
  in the standard format ``<file>,<password>,<(optional) type>``

  Example: ``RSTUF_LOCAL_KEYVAULT_KEYS=/run/secrets/ONLINE_KEY_1:/run/secrets/ONLINE_KEY_2``

#### (Optional, *experimental*) `RSTUF_ONLINE_KEY_DIR`

Directory path for online signing key file. Expected file format is unencrypted PKCS8/PEM.

Make sure to use the secrets management service of your deployment platform to
protect the private key!

Replaces `RSTUF_KEYVAULT_BACKEND` and related settings.

Example:
- `RSTUF_ONLINE_KEY_DIR=/run/secrets`
- RSTUF worker expects related private key under  `/run/secrets/<file name>`




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
