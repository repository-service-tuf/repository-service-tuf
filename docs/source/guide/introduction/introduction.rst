============
Introduction
============

Repository Service for TUF components
=====================================

The Repository Service for TUF (RSTUF) consists of two primary components,
``repository-service-tuf-api`` and ``repository-service-tuf-worker``.
We also provide a Command Line Interface (CLI) for interacting with RSTUF,
``repository-service-tuf-cli``.

`Each of the RSTUF components is represented in blue in this diagram of a
typical service deployment:`

.. image:: /_static/2_1_rstuf.png

Repository Service for TUF
--------------------------

Repository Service for TUF implements the microservices pattern for scalability
and reliability in different deployment scenarios.

The ``repository-service-tuf-api``, and ``repository-service-tuf-worker``
services are provided as Docker Images.

``repository-service-tuf-api`` is the API Service, and the
``repository-service-tuf-worker`` is a worker that manages TUF Metadata.

The Repository Service for TUF requires a Broker (``RabbitMQ`` or ``Redis``)
to be used by the RSTUF services (``repository-service-tuf-api``,
``repository-service-tuf-worker``).

.. note::
    TUF Metadata Storage and Key Storage (Key Vault) use the filesystem for
    storage. To use persistent data and share this volume, Docker Volumes
    are supported.

    We plan to add support for SaaS Services such as S3 and Cloud Key Vaults
    in the future milestones.

Repository Service for TUF Command Line
---------------------------------------

The Repository Service for TUF Command Line Interface
(``repository-service-tuf-cli``) is a CLI Python application to manage the
Repository Service for TUF.

The CLI supports the initial setup, termed a ceremony, where the first repository
metadata are signed and the service is configured, generating tokens to be used
by integration (i.e., CI/CD tools).

The Repository Metadata
=======================

Repository Service for TUF (RSTUF) secures downloads with signed repository
metadata using a design based on Python's `PEP 458 – Secure PyPI downloads
with signed repository metadata <https://peps.python.org/pep-0458/>`_.

.. image:: /_static/1_1_rstuf_metadata.png

Some configurations are possible during the
:ref:`guide/repository-service-tuf-cli/index:Ceremony (``ceremony\`\`)`, such
as the number of keys, thresholds, expiration, etc.

New targets (file, package, update, installer) can be added to the signed
repository metadata using REST API calls, making it easy to integrate into
CI/CD tools.

You can deploy Repository Service for TUF as a single server or a distributed
service (to scale for more active repositories) at the edge, on-premises, or
in cloud environments.

Check out the :ref:`how to deploy <guide/deployment/index:Deployment>`.

Below is a diagram of Repository Service for TUF in a building environment.

.. image:: /_static/2_2_rstuf.png

.. note::

    If you provide users with download or update tools, you need to add
    functionality to your tools to check the signed metadata.


Project background and motivation
=================================

`TUF`_ provides a flexible framework and specification that developers can
adopt and an excellent Python Library (`python-tuf`_) that provides two APIs
for low-level Metadata management and client implementation.

Implementing `TUF`_ requires sufficient knowledge of `TUF`_ to design how to
integrate the framework into your repository and hours of engineering work to
implement.

RSTUF was born as a consequence of working on the implementation of `PEP 458
<https://peps.python.org/pep-0458/>`_ in the `Warehouse
<https://warehouse.pypa.io>`_ project which powers the `Python Package Index
(PyPI) <https://pypi.org>`_.

Due to our experience with the complexity and fragility of deep integration into
an intricate platform, we began designing how to implement a reusable TUF platform
that is flexible to integrate into different flows and infrastructures.

Repository Service for TUF's goal is to be an easy-to-use tool for Developers,
DevOps, and DevOpsSec teams working on the delivery process.


.. _TUF: https://theupdateframework.io
.. _python-tuf: https://pypi.org/project/tuf/
