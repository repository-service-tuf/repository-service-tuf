#######
Volumes
#######

As the Repository Service for TUF provides containers images, it is required to
work with volumes for persistent data.

.. Note::
    For the :ref:`guide/deployment/planning/deployment:Required Infrastructure Services`,
    use persistent data.

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
