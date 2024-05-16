##########
Kubernetes
##########

Multiple RSTUF API instances/replicas can be deployed in a distributed
environment to support multiple requests.

This example uses Kubernetes

.. note::
  This deployment guide does not show the Kubernetes cluster configuration.
  It requires a Kubernetes cluster running with ``kubectl`` configured.

.. note::
  For this deployment Redis is used as the
  :ref:`message queue/broker <guide/deployment/planning/deployment:Message Queue/Broker: Redis or RabbitMQ server>`.

.. Warning::
  This deployment does not have :ref:`guide/deployment/planning/deployment:Authentication/Authorization`
  for the API.

  This API is fully accessible for unauthorized users. Consider using an
  API :ref:`guide/deployment/planning/deployment:Authentication/Authorization`
  service.

.. note::
  See the complete :ref:`guide/deployment/planning/deployment:Deployment Configuration`
  for in-depth details.

Requirements
############

Software and tools
==================

  * Kubernetes Cluster
  * kubectl
  * Python >= 3.10
  * pip

Online Key
##########

This deployment requires the :ref:`guide/general/keys:Online Key`.
See the chapter :ref:`guide/general/keys:Signing Keys`

Secrets
#######

.. caution::
    Do not use this credential, it is just an example.

onlinekey secret
================

Generating the secrets for RSTUF Online Key

1. Get the key content and encode it to base 64

.. code:: shell

  ❯ base64 -i tests/files/keys/0d9d3d4bad91c455bc03921daa95774576b86625ac45570d0cac025b08e65043
  YWI2ODU0YzE5MjlmNjYxNTc4MTBhNDBjMjQ1ZGU0NGJAQEBAMTAwMDAwQEBAQGUxZTk4MzMyZTZiYmNkM2M2ZjdmMGFiZjczNTdmNDNmZGJhN2QwMTRkYzYwMDk2YzNkODRkZjIyYTc3NDUwYmVAQEBANDgxNWEzNTgxZTB


postgrespassword secret
=======================

Generating the secrets for Postgres password

.. code:: shell

    ❯ echo -n "PostgreSQLstrongPassword" | base64
    UG9zdGdyZVNRTHN0cm9uZ1Bhc3N3b3Jk


Secrets example
---------------

``k8s/secrets.yml``

.. literalinclude:: k8s/secrets.yml
    :language: yaml
    :linenos:
    :name: secrets.yml


Applying secrets
================

.. code:: shell

    ❯ kubectl apply -f secrets.yml
    secret/onlinekey created
    secret/postgrespassword created

    ❯ kubectl get secrets
    NAME                  TYPE                                  DATA   AGE
    default-token-dqt9k   kubernetes.io/service-account-token   3      22d
    onlinekey             Opaque                                1      2s
    postgrespassword      Opaque                                1      2s


Volumes
#######

The following volumes will be defined:

rstuf-storage persistent volume
===============================

RSTUF Workers will use the :ref:`guide/deployment/planning/deployment:Storage Backend Service`
type as ``LocalStorage`` which requires a
:ref:`guide/deployment/planning/volumes:LocalStorage [Optional]`

* RSTUF Workers will use the ``RSTUF_STORAGE_BACKEND_PATH`` as this volume

* WebServer will use the same volume the HTTP root document (htdocs) to
  expose the TUF Metadata at ``http://webserver/``

redis-data persistent volume
============================

Redis persistent data volume

postgres-data persistent volume
===============================

Postgres persistent data volume

Volumes example
---------------

.. literalinclude:: k8s/volumes.yml
    :language: yaml
    :linenos:
    :name: volumes.yml



Applying Volumes
================

.. code:: shell

    ❯ kubectl apply -f volumes.yml
    persistentvolumeclaim/rstuf-storage created
    persistentvolumeclaim/redis-data created
    persistentvolumeclaim/postgres-data created

    ❯ kubectl get pv
    NAME                   CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                     REASON   AGE
    pvc-5184d98009604a73   10Gi       RWO            Retain           Bound    default/redis-data                  7s
    pvc-79aff76456bd433f   10Gi       RWO            Retain           Bound    default/rstuf-storage               9s
    pvc-c3ee2645d4114816   10Gi       RWO            Retain           Bound    default/postgres-data               8s


Services
########

redis service
=============

* Exposes the port 6379 in the deployment network

postgres service
================

* Exposes the port 5432 in the deployment network

web-metadata
============
* Exposes the port 80 externally, using a load balancer

rstuf-api
=========
* Exposes the port 80 externally, using a load balancer

Services example
----------------

.. literalinclude:: k8s/services.yml
    :language: yaml
    :linenos:
    :name: services.yml

Applying services
=================

.. code:: shell

  ❯ kubectl apply -f services.yml
  service/redis created
  service/postgres created
  service/web-metadata created
  service/rstuf-api created

  ❯ kubectl get services
  NAME           TYPE           CLUSTER-IP       EXTERNAL-IP       PORT(S)        AGE
  kubernetes     ClusterIP      10.128.0.1       <none>            443/TCP        32d
  postgres       ClusterIP      10.128.54.79     <none>            5432/TCP       30s
  redis          ClusterIP      10.128.202.49    <none>            6379/TCP       30s
  rstuf-api      LoadBalancer   10.128.44.53     <PUBLIC_IP>       80:30158/TCP   30s
  web-metadata   LoadBalancer   10.128.135.249   <PUBLIC_IP>       80:32744/TCP   30s

Deployment
##########

The following deployment will be applied:

redis deployment
================

* Redis will use the :ref:`guide/deployment/guide/kubernetes:redis-data persistent volume` mounted on ``/data``
* Redis container will use port as 6379 (default)

postgres deployment
===================

* Postgres will use the :ref:`guide/deployment/guide/kubernetes:postgres-data persistent volume`
  mounted on ``/var/lib/postgresql/data/rstuf``
* Postgres will use environment variable ``POSTGRES_PASSWORD`` set as the
  secrets ``postgrespassword``

web-metadata deployment
=======================

web-metadata is the Web Server is Apache which exposes the TUF Metadata

* Web Server will use :ref:`guide/deployment/guide/kubernetes:rstuf-storage persistent volume`
  mounted on ``/usr/local/apache2/htdocs``
* Web Server container will use port 80

rstuf-api deployment
====================

* RSTUF API will use environment variables ``RSTUF_BROKER_SERVER`` and
  ``RSTUF_REDIS_SERVER`` as :ref:`guide/deployment/guide/kubernetes:redis deployment`
  address (``redis://redis``).
* RSTUF API container will use port 80 to serve the API (internally)

rstuf-worker deployment
=======================

* RSTUF Worker will use:
  
  - :ref:`guide/deployment/guide/kubernetes:rstuf-storage persistent volume`
    mounted on ``/var/opt/repository-service-tuf/storage``

  - environment variables ``RSTUF_BROKER_SERVER`` and ``RSTUF_REDIS_SERVER`` as
    :ref:`guide/deployment/guide/kubernetes:redis deployment` (``redis://redis``).

  - environment variables ``RSTUF_SQL_SERVER`` as
    the :ref:`guide/deployment/guide/kubernetes:postgres deployment`
    (``postgres:5432``), ``RSTUF_SQL_USER`` as ``postgres``, and
    ``RSTUF_SQL_PASSWORD`` as the :ref:`guide/deployment/guide/kubernetes:postgrespassword secret`.

  - environment variable ``RSTUF_ONLINE_KEY_DIR`` as
    :ref:`guide/deployment/guide/kubernetes:onlinekey secret`

  - environment variable ``RSTUF_STORAGE_BACKEND`` as ``LocalStorage``

  - environment variable ``RSTUF_LOCAL_STORAGE_BACKEND_PATH`` as
    ``/var/opt/repository-service-tuf/storage``

Deployment example
------------------

.. literalinclude:: k8s/deployment.yml
    :language: yaml
    :linenos:
    :name: deployment.yml


Applying deployment
===================

.. code:: shell

  ❯ kubectl apply -f deployment.yml
  deployment.apps/redis created
  deployment.apps/postgres created
  deployment.apps/web-metadata created
  deployment.apps/rstuf-worker created
  deployment.apps/rstuf-api created

  ❯ kubectl get pods
  NAME                            READY   STATUS    RESTARTS   AGE
  postgres-64866cf7f9-p4clt       1/1     Running   0          4m12s
  redis-6f6fbbd9ff-ckrrt          1/1     Running   0          4m12s
  rstuf-api-7cd78b65f7-sn56n      1/1     Running   0          4m12s
  rstuf-worker-5b89554c95-xrlgb   1/1     Running   0          4m12s
  web-metadata-75f59886f-h274h    1/1     Running   0          4m12s


RSTUF Ceremony and Bootstrap
############################

  .. include:: ../setup.rst