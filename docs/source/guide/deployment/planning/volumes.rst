#######
Volumes
#######

As the Repository Service for TUF provides containers images, it is required to
work with volumes for persistent data.

.. Note::
    For the :ref:`guide/deployment/planning/deployment:Required Infrastructure Services`,
    use persistent data.

Repository Service for TUF API (RSTUF API)
##########################################

DATA [optional]
===============

It requires a persistent volume only if using the built-in
authentication/authorization.

.. Caution::
    Using the built-in RSTUF
    :ref:`guide/deployment/planning/deployment:Authentication/Authorization` is not recommended.

Share the persistent volume between all RSTUF API instances and mount it on the
container's path ``/data``.

To modify the default path ``/data``, use the
:ref:`guide/repository-service-tuf-api/Docker_README:(Optional) `DATA_DIR\``

Repository Service for TUF Worker (RSTUF Worker)
################################################

LocalStorage [Optional]
=======================

The ``LocalStorage`` is a type of RSTUF Worker
:ref:`RSTUF_STORAGE_BACKEND <guide/repository-service-tuf-worker/Docker_README:(Required) `RSTUF_STORAGE_BACKEND\`>`

It stores the public TUF metadata. It requires a persistent volume to store the
metadata.

Share the persistent volume with all RSTUF Workers and mount it on the
container's path defined in the required variable
:ref:`RSTUF_LOCAL_STORAGE_BACKEND_PATH <guide/repository-service-tuf-worker/Docker_README:(Required) `RSTUF_STORAGE_BACKEND\`>`
environment variable when ``RSTUF_STORAGE_BACKEND=LocalStorage``

.. Note::
    This volume contains the public TUF metadata used by TUF clients.
    Sharing this content using a Web Server is an easy way to achieve it.
    See :ref:`guide/deployment/planning/deployment:[Optional] Content Server: Webserver`

LocalKeyVault [Optional]
========================

The ``LocalKeyVault`` is a type of RSTUF Worker
:ref:`RSTUF_KEYVAULT_BACKEND <guide/repository-service-tuf-worker/Docker_README:(Required) `RSTUF_KEYVAULT_BACKEND\`>`

It can be used to store the online key for signing the TUF metadata.

Share the persistent volume with all RSTUF Workers and mount it on the
container's path defined in the required variable
:ref:`RSTUF_LOCAL_KEYVAULT_PATH <guide/repository-service-tuf-worker/Docker_README:(Required) `RSTUF_KEYVAULT_BACKEND\`>`
environment variable when ``RSTUF_KEYVAULT_BACKEND=LocalKeyVault``

.. Warning::
    DO NOT EXPOSE THIS VOLUME.
    Restrict the volume to RSTUF Worker(s) only.