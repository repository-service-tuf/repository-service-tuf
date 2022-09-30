============
Introduction
============

TUF Repository Service components
=================================

TUF Repository Service (TRS) have two component services,
``tuf-repository-service-api`` and ``tuf-repository-service-worker``.
TRS also have a Command Line Interface that is a Python Application,
``tuf-repository-service-cli``.

* `All represented in blue`

.. uml:: ../../../diagrams/2_1_trs.puml

TUF Repository Service
----------------------

The ``tuf-repository-service-api``, and ``tuf-repository-service-worker``
services are provided as Docker Images.

``tuf-repository-service-api`` is the API Service, and the
``tuf-repository-service-worker``` is a Task Manager Worker that handles the
TUF Metadata.

The TUF Repository Service requires a Broker (``RabbitMQ`` or ``Redis``)
to be used by the TRS services (``tuf-repository-service-api``,
``tuf-repository-service-worker``).

.. note::
    TUF Metadata Storage and Sorage Keys (Key Vault) use File Systems.
    To use persistent data and share this volume, Docker Volumes are supported.

    The plan is to add support for SaaS Services such as S3 and Cloud Key
    Vaults in the following releases.

The idea of using TUF Repository Service as microservices is the possibility
of bringing scalability and reliability in different deployment scenarios.

TUF Repository Service Command Line
-----------------------------------

The TUF Repository Service Command Line Interface
(``tuf-repository-service-cli``) is a Command Line Interface (CLI) Python
Application to manage the TUF Repository Service.

The CLI supports the Ceremony (signing the initial Repository Metadata
and TUF Repository Service setup), generating Tokens to be used by integration
(i.e. CI/CD tools).

The Repository Metadata
=======================

TUF Repository Service (TRS) is to secure downloads with signed Repository
Metadata.
TRS implements The Update Framework (TUF) As a Service as part of your release
process.

The TRS has pre-defined TUF Roles and some Roles to protect and enable
integration with build systems based on Python PEP 458.

.. uml:: ../../../diagrams/1_1_trs_metadata.puml

Some configurations are possible during the
:ref:`guide/tuf-repository-service-cli/index:Ceremony (``ceremony\`\`)`, such
as the number of keys, thresholds, expiration, etc.

New targets (file, package, update, installer) can be added to the signed
repository metadata using REST API calls, making it easy to integrate into
CI/CD tools.

You can deploy TUF Repository Service as a single server or a distributed
service in edge, private, or cloud environments.

Check out the :ref:`installation guide to see how to deploy.
<guide/installation/server:TUF Repository Service  Installation>`

Below is a diagram of TUF Repository Service in a building environment.

.. uml:: ../../../diagrams/2_2_trs.puml

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

TUF Repository Service goal is to be an easy tool/platform to be used by Developers, DevOps,
DevOpsSec in the delivery process.


.. _TUF: https://theupdateframework.io
.. _python-tuf: https://pypi.org/project/tuf/
