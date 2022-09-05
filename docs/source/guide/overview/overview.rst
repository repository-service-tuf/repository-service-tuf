============
Introduction
============

Kaprien components
==================

Kaprien has three components Kaprien Server and Kaprien Command Line Interface.

Kaprien Server has two main services, ``kaprien-rest-api``, and
``kaprien-repo-worker``.
Kaprien Command Line Interface is a Python Application, ``kaprien-cli``.

* `All represented in blue`

.. uml:: ../../../diagrams/2_1_kaprien.puml

Kaprien Server
--------------

The ``kaprien-rest-api``, and ``kaprien-repo-worker`` services are available as
Docker Images.

``kaprien-rest-api`` is the Kaprien Server API service, and the
``kaprien-repo-worker``` is a TUF Repository Manager worker that handles the TUF
Metadata.

The Kaprien Server requires a Broker (``RabbitMQ`` or ``Redis``) to be used by
Kaprien Services (``kaprien-rest-api``, ``kaprien-repo-worker``).

.. note::
    TUF Metadata Storage and online keys (Key Vault) use File Systems.
    To use persistent data and share this volume, Docker Volumes are supported.

    The plan is to add support for SaaS Services such as S3 and Cloud Key
    Vaults.

The idea of using Kaprien as microservices is the possibility of bringing
scalability and reliability in different deployment scenarios.

Kaprien Command Line
--------------------

The Kaprien Command Line Interface is a Python Application (``kaprien-cli``) to
manage the Kaprien Server.

The command line supports the Ceremony (signing the initial Repository Metadata
and Kaprien Service setup), generating Tokens to be used by CI/CD for example.

Usage
=====

Kaprien is to secure downloads with signed Repository Metadata.
Kaprien implements The Update Framework (TUF) As a Service as part of your
release process.

The Kaprien has pre-defined TUF Roles and some Roles to protect and enable
integration with build systems based on Python PEP 458.

.. uml:: ../../../diagrams/1_1_kaprien_metadata.puml

Some configurations are possible during the
:ref:`guide/kaprien-cli/index:Ceremony (``ceremony\`\`)`, such as the number
of keys, thresholds, expiration, etc.

New targets (file, package, update, installer) can be added to the signed
repository metadata using REST API calls, making it easy to integrate into
CI/CD tools.

You can deploy Kaprien as a single server or a distributed service in edge,
private, or cloud environments.

Check out the :ref:`installation guide to see how to deploy.<guide/installation/server:Kaprien Server Installation>`

Above is a diagram of Kaprien in a building environment.

.. uml:: ../../../diagrams/2_2_kaprien.puml

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

Kaprien goal is to be an easy tool/platform to be used by Developers, DevOps,
DevOpsSec in the delivery process.


.. _TUF: https://theupdateframework.io
.. _python-tuf: https://pypi.org/project/tuf/
