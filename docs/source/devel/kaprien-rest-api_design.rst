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

Service configuration settings. To be considered service configuration
setting must be related to the kaprien-rest-api functionality.

Repository configuration settings. Any configuration related to the
Metadata Repository. To be considered, the Repository Configuration must be
a configuration for the TUF Metadata Repository. This configuration is
stored in the ``kaprien-rest-api`` to efficiently distribute to the
``kaprien-repo-workers`` that execute operations in the Metadata.

The `kaprien-rest-api`` service stores the User database used to manage the
tokens in the filesystem.

All operations to the Repository Metadata, the service publish to the Broker as
a task, and ``kaprien-repo-worker`` will consume it. The
``kaprien-repo-worker`` publishes back to the Backend, and ``kaprien-rest-api``
can consume it.


.. uml:: ../../diagrams/kaprien-rest-api-C2.puml
