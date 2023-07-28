
###################
Architecture Design
###################

The principles
##############


   * RSTUF uses `The Update Framework (TUF) <http://www.theupdateframework.io>`_.

     - It enables RSTUF to be artifact agnostic.

   * RSTUF is easy to deploy.

   * RSTUF has an API-first design.

     - RSTUF is language agnostic, allowing integration by any programming language

   * RSTUF is process agnostic.

     - Add/Remove artifacts doesn't interfere with the existing organization
       release/publish processes.

   * RSTUF focuses on scalability and Metadata consistency.

   * RSTUF guides users on TUF processes.


The architecture design principles:
###################################

The Repository Service for TUF (RSTUF) has two services
(``repository-service-tuf-api``, ``repository-service-tuf-worker``) and one
command line tool (``repository-service-cli``), as described in
:ref:`guide/general/introduction:RSTUF Components`.

.. note::
    Other services can be added as optional or required

RSTUF also requires some third-party services described in
:ref:`guide/deployment/planning/deployment:Required Infrastructure Services`.

.. image:: /_static/2_1_rstuf.png

The below definitions allow RSTUF API and RSTUF Worker scalability.

RSTUF is Asynchronous
=====================

    * RSTUF uses `Celery <https://docs.celeryq.dev>`_.
    * Every API request is a task.
    * RSTUF centralizes all tasks in the :ref:`devel/design:Message Queue`.
    * RSTUF stores all task results in the :ref:`devel/design:Backend Result`.
    * :ref:`devel/design:Repository Service TUF API` **publishes** RSTUF tasks.
    * :ref:`devel/design:Repository Service TUF Worker` **consumes** RSTUF tasks.

RSTUF Repository Settings/Configuration
=======================================

    * :ref:`guide/general/introduction:RSTUF Components` are **stateless**.

      - Components are configured by runtime environment variables.
      - Components uses runtime :ref:`devel/design:TUF Repository Settings`.

    * :ref:`devel/design:Redis` stores the
      :ref:`devel/design:TUF Repository Settings` using
      `Dynaconf <https://www.dynaconf.com>`_.

    * :ref:`devel/design:Repository Service TUF Worker` **writes** settings.
    * :ref:`devel/design:Repository Service TUF API` **reads** settings.

        .. note::
          A single exception is during a bootstrap process. If the
          :ref:`devel/design:Repository Service TUF API` detects a failure
          **writes** :ref:`devel/design:TUF Repository Settings`
          ``BOOTSTRAP`` to ``None``.

TUF Repository Settings
-----------------------

TUF Repository Settings are key configurations for the Metadata Repository
operations.

    .. list-table:: RSTUF reserved settings/configuration
        :header-rows: 1
        :widths: 30 30 40

        * - Key
          - Value(s)
          - Description
        * - ``BOOTSTRAP``
          - | ``None``
            | ``<task id>``
            | ``pre-<task id>``
            | ``sign-<task id>``
          - | RSTUF bootstrap state
            | ``None``: No bootstrap
            | ``<task id>``: Finished
            | ``pre-<task id>``: Initial process
            | ``sign-<task id>``: Signing process
        * - ``<ROLE NAME>_EXPIRATION``
          - | ``int``
          - | Role Metadata expiration policy in days
            | It uses the role name uppercase
            | Example: ``ROOT_EXPIRATION``
        * - ``<ROLE NAME>_NUM_KEYS``
          - | ``int``
          - | Role number of keys
            | It uses the role name uppercase
            | Example: ``ROOT_NUM_KEYS``
        * - ``<ROLE NAME>_THRESHOLD``
          - | ``int``
          - | Role key threshold
            | It uses the role name uppercase
            | Example: ``ROOT_THRESHOLD``
        * - ``NUMBER_OF_DELEGATED_BINS``
          - | ``int``
          - Number of delegated hash bin roles
        * - ``SIGNING_<ROLE NAME>``
          - | ``None``
            | ``<json>``
          - | ``None``: No pending signature(s)
            | ``json``: TUF Metadata pending signature
            | It uses the role name uppercase
            | Example ``SIGNING_ROOT``

Target Files and Target Roles
=============================

    * The TUF top-level Targets Role is only used for delegation.
      This role does not register target files (artifacts).
    * :ref:`devel/design:PostgreSQL` stores the artifacts (``TargetFiles``) and
      Targets delegated roles.
    * :ref:`devel/design:Repository Service TUF Worker` manages the
      :ref:`devel/design:PostgreSQL` database.
    * :ref:`devel/design:Repository Service TUF Worker` implements and manages
      the Key Vault and Storage Services.

      - Access to the Key Vault Service is restricted to
        :ref:`devel/design:Repository Service TUF Worker`. (read-only)
      - Writing the TUF Metadata in the Storage Service  is limited to
        :ref:`devel/design:Repository Service TUF Worker`.
      - The Storage Service is the only public data.

RSTUF Components Design
#######################

Repository Service TUF API
==========================

* Integration (add/remove artifacts)
* TUF metadata process (bootstrap, sign, update, etc)

.. note::
    The service can implement other features without interfering with the
    RSTUF principles and architecture design principles.

`See component development documentation
<https://repository-service-tuf.readthedocs.io/projects/rstuf-api/en/latest/devel/>`_.


Repository Service TUF Worker
=============================

* Manages the TUF metadata
* Manages the Key Vault and Storage Services

.. note::
    The service can implement other features without interfering with the
    RSTUF principles and architecture design principles.

`See component development documentation
<https://repository-service-tuf.readthedocs.io/projects/rstuf-worker/en/latest/devel/>`_.

Repository Service TUF CLI
==========================

* Command Line Interface for the API
* Guide users in the processes

.. note::
    The service can implement other features without interfering with the
    RSTUF principles and architecture design principles.

`See component development documentation
<https://repository-service-tuf.readthedocs.io/projects/rstuf-cli/en/latest/devel/>`_.


RSTUF Infrastructure Services Design
####################################

The Infrastructure Services have key functionality on RSTUF

Message Queue
=============

* It is a centralized queue service for tasks.
* This queue is used as `Broker by Celery
  <https://docs.celeryq.dev/en/stable/getting-started/backends-and-brokers/index.html#broker-overview>`_.
* :ref:`devel/design:Repository Service TUF Worker` defines the supported Queue
  servers.

Backend Result
==============

* It is a centralized `backend result used by Celery for task results
  <https://docs.celeryq.dev/en/stable/getting-started/backends-and-brokers/index.html>`_.
* :ref:`devel/design:Repository Service TUF Worker` defines the supported
  backend results servers.


Redis
=====

* It is a centralized key/cache service.
* Stores :ref:`devel/design:RSTUF Repository Settings/Configuration`
* Optional:

  - Used as :ref:`devel/design:Message Queue`.
  - Used as :ref:`devel/design:Backend Result`.

    .. Note::
        See :ref:`guide/deployment/planning/deployment:Required Infrastructure Services`

PostgreSQL
==========

* Stores :ref:`devel/design:Target Files and Target Roles`
