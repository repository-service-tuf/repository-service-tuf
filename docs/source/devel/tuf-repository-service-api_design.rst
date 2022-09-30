API Design
==========

Context level
-------------

The tuf-repository-service-api, in the context perspective, is an HTTP Rest API for the
TUF Metadata Repository that works asynchronously with the Metadata Repository,
sending the requests to a Broker.

.. uml:: ../../diagrams/tuf-repository-service-api-C1.puml


Container level
---------------

The ``tuf-repository-service-api``, in the container perspective, is a HTTP Rest API that
will receive requests from ``tuf-repository-service-cli`` (using HTTP + Token) as usual, not
limited but also from third part software using HTTP + Token.

The ``tuf-repository-service-api`` writes synchronously some data to the filesystem
``$DATA_DIR``. ``tuf-repository-service-api`` uses the file system, but the volume
is part of the OS.

``tuf-repository-service-api`` has two type of settings, **Service Configuration
Settings** and the **Repository Settings**.

**Service Configuration Settings**: To be considered service configuration
setting must be related to the ``tuf-repository-service-api`` functionality.

**Repository Settings**: Any configuration related to the
Metadata Repository. To be considered, the Repository Configuration must be
a configuration for the TUF Metadata Repository.

This configuration is stored in the ``TRS_REDIS_SERVER`` (Redis Server) to
efficiently distribute to the ``tuf-repository-service-workers`` that execute operations
in the Metadata. A copy of this settings is stored localy in
``$DATA_DIR/repository_settings.ini``.

.. note::

    The Redis Server should have its persistent data setup and recovery
    mechanism. There is an implementation ``sync_redis`` that identifies
    that Redis doesn't have the Repository Settings and send it again.


The ``tuf-repository-service-api`` service stores the User database used to manage the
tokens in the filesystem.

All operations to the Repository Metadata, the service publish to the Broker as
a task, and ``tuf-repository-service-worker`` will consume it. The
``tuf-repository-service-worker`` publishes back to the ``TRS_REDIS_SERVER``, and
``tuf-repository-service-api`` can consume it.


.. uml:: ../../diagrams/tuf-repository-service-api-C2.puml
