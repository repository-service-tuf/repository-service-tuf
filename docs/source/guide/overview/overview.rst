============
Introduction
============

Repository Service for TUF components
=====================================

Repository Service for TUF (RSTUF) have two component services,
``repository-service-tuf-api`` and ``repository-service-tuf-worker``.
RSTUF also have a Command Line Interface that is a Python Application,
``repository-service-tuf-cli``.

* `All represented in blue`

.. uml:: ../../../diagrams/2_1_rstuf.puml

Repository Service for TUF
--------------------------

The ``repository-service-tuf-api``, and ``repository-service-tuf-worker``
services are provided as Docker Images.

``repository-service-tuf-api`` is the API Service, and the
``repository-service-tuf-worker``` is a Task Manager Worker that handles the
TUF Metadata.

The Repository Service for TUF requires a Broker (``RabbitMQ`` or ``Redis``)
to be used by the RSTUF services (``repository-service-tuf-api``,
``repository-service-tuf-worker``).

.. note::
    TUF Metadata Storage and Sorage Keys (Key Vault) use File Systems.
    To use persistent data and share this volume, Docker Volumes are supported.

    The plan is to add support for SaaS Services such as S3 and Cloud Key
    Vaults in the following releases.

The idea of using Repository Service for TUF as microservices is the possibility
of bringing scalability and reliability in different deployment scenarios.

Repository Service for TUF Command Line
---------------------------------------

The Repository Service for TUF Command Line Interface
(``repository-service-tuf-cli``) is a Command Line Interface (CLI) Python
Application to manage the Repository Service for TUF.

The CLI supports the Ceremony (signing the initial Repository Metadata
and Repository Service for TUF setup), generating Tokens to be used by integration
(i.e. CI/CD tools).

The Repository Metadata
=======================

Repository Service for TUF (RSTUF) is to secure downloads with signed Repository
Metadata.
RSTUF implements The Update Framework (TUF) As a Service as part of your release
process.

The RSTUF has pre-defined TUF Roles and some Roles to protect and enable
integration with build systems based on Python PEP 458.

.. uml:: ../../../diagrams/1_1_rstuf_metadata.puml

Some configurations are possible during the
:ref:`guide/repository-service-tuf-cli/index:Ceremony (``ceremony\`\`)`, such
as the number of keys, thresholds, expiration, etc.

New targets (file, package, update, installer) can be added to the signed
repository metadata using REST API calls, making it easy to integrate into
CI/CD tools.

You can deploy Repository Service for TUF as a single server or a distributed
service in edge, private, or cloud environments.

Check out the :ref:`how to deploy <guide/installation/server:Deployment>`.

Below is a diagram of Repository Service for TUF in a building environment.

.. uml:: ../../../diagrams/2_2_rstuf.puml

.. note::

    If you provide users with download or update tools, you need to add to your
    tools the functionality to check the signed metadata.


About the project and motivation
================================

`TUF`_ provides a flexible framework and specification that developers can adopt
and an excellent Python Library (`python-tuf`_) that provides two APIs for
low-level Metadata management and client implementation.

Implementing `TUF`_ to be used in building infrastructure and repository
infrastructure may require deep knowledge of the `TUF`_ and hours of engineering
implementation.

When I started implementing the `PEP 458 (Secure PyPI downloads with signed
repository metadata) <https://peps.python.org/pep-0458/>`_ , I began
designing how to implement a reusable platform in different flows and infrastructures.

Repository Service for TUF goal is to be an easy tool/platform to be used by Developers, DevOps,
DevOpsSec in the delivery process.


.. _TUF: https://theupdateframework.io
.. _python-tuf: https://pypi.org/project/tuf/
