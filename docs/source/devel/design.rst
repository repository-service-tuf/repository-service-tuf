
###################
Architecture Design
###################

The principles
##############


   * RSTUF uses `The Update Framework (TUF) <http://www.theupdateframework.io>`_.

     - It enables RSTUF to be artifact agnostic.

   * RSTUF is easy to deploy.

   * RSTUF has API first design.

     - RSTUF is language agnostic, making any language use/integrate easily.

   * RSTUF is process agnostic.

     - Adding/removing artifacts goes with the existing releasing/publishing
       process.

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

    * Every API request is a task.
    * RSTUF centralizes all tasks in the :ref:`devel/design:Message Queue`.
    * RSTUF stores all task results in the :ref:`devel/design:Backend Result`.
    * :ref:`devel/design:Repository Service TUF API` **publishes** RSTUF tasks.
    * :ref:`devel/design:Repository Service TUF Worker` **consumes** RSTUF tasks.

RSTUF Repository Settings/Configuration
=======================================

    * :ref:`guide/general/introduction:RSTUF Components` are RSTUF
      **stateless** about the Repository Settings, relying on
      :ref:`devel/design:RSTUF settings`.

    * :ref:`devel/design:RSTUF settings` stores in
      :ref:`devel/design:Redis` using `Dynaconf <https://www.dynaconf.com>`_.

    * :ref:`devel/design:Repository Service TUF Worker` **writes** settings
    * :ref:`devel/design:Repository Service TUF API` **reads** settings.

        .. note::
          A unique exception is when a bootstrap process fails and the API
          **writes** it back to ``None``.

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
        :ref:`devel/design:Repository Service TUF Worker`
      - Writing the TUF Metadata in the Storage Service  is limited to
        :ref:`devel/design:Repository Service TUF Worker`
      - The Storage Service is the only public data

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

* It is a centralized queue

Backend Result
==============

* It is a centralized backend result for tasks

Redis
=====

* It is a centralized key/cache service
* Stores :ref:`devel/design:RSTUF Repository Settings/Configuration`
* Optional:

  - Used as :ref:`devel/design:Message Queue`
  - Used as :ref:`devel/design:Backend Result`

    .. Note::
        See :ref:`guide/deployment/planning/deployment:Required Infrastructure Services`

PostgreSQL
==========

* Stores :ref:`devel/design:Target Files and Target Roles`
