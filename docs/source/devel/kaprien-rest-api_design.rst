kaprien-rest-api design
=======================

kaprien-rest-api context level
------------------------------

The kaprien-rest-api, in the context perspective, is an HTTP Rest API for the
TUF Metadata Repository that works asynchronously with the Metadata Repository,
sending the requests to a Broker.

.. uml:: ../../diagrams/kaprien-rest-api-C1.puml


kaprien-rest-api container level
--------------------------------

The ``kaprien-rest-api``, in the container perspective, is a HTTP Rest API that
will receive requests from ``kaprien-cli`` (using HTTP + Token) as usual, not
limited but also from third part software using HTTP + Token.

The ``kaprien-rest-api`` writes synchronously some data to the filesystem
``$DATA_DIR``. ``kaprien-rest-api`` uses the file system, but the volume
is part of the OS.

``kaprien-rest-api`` has two type of settings, **Service Configuration
Settings** and the **Repository Settings**.

**Service Configuration Settings**: To be considered service configuration
setting must be related to the ``kaprien-rest-api`` functionality.

**Repository Settings**: Any configuration related to the
Metadata Repository. To be considered, the Repository Configuration must be
a configuration for the TUF Metadata Repository.

This configuration is stored in the ``KAPRIEN_REDIS_SERVER`` (Redis Server) to
efficiently distribute to the ``kaprien-repo-workers`` that execute operations
in the Metadata. A copy of this settings is stored localy in
``$DATA_DIR/repository_settings.ini``.

.. note::

    The Redis Server should have its persistent data setup and recovery
    mechanism. There is an implementation ``sync_redis`` that identifies
    that Redis doesn't have the Repository Settings and send it again.


The ``kaprien-rest-api`` service stores the User database used to manage the
tokens in the filesystem.

All operations to the Repository Metadata, the service publish to the Broker as
a task, and ``kaprien-repo-worker`` will consume it. The
``kaprien-repo-worker`` publishes back to the ``KAPRIEN_REDIS_SERVER``, and
``kaprien-rest-api`` can consume it.


.. uml:: ../../diagrams/kaprien-rest-api-C2.puml
