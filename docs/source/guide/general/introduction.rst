############
Introduction
############

Repository Service for TUF
##########################

RSTUF Components
================

.. image:: /_static/2_1_rstuf.png

Repository Service for TUF (RSTUF) is a combination of micro-services provided
as containers:

 * Repository Service for TUF API (RSTUF API ``repository-service-tuf-api``)
 * Repository Service for TUF Worker (RSTUF Worker ``repository-service-tuf-worker``)

Repository Service for TUF (RSTUF) also provides a Command Line Interface tool
to manage the RSTUF deployment.

 * Repository Service for TUF CLI (RSTUF CLI ``repository-service-tuf-cli``)

Repository Service for TUF API (RSTUF API)
------------------------------------------

The :ref:`guide/repository-service-tuf-api/index:Repository Service for TUF API`
(RSTUF API) servers an HTTP REST API for integration and service management.

The API integrates with the CI/CD or artifact release management flow.

Repository Service for TUF Worker (RSTUF Worker)
------------------------------------------------

The :ref:`guide/repository-service-tuf-worker/index:Repository Service for TUF Worker`
(RSTUF Worker) is an isolated workload service that manages TUF metadata.
It updates, signs, and publishes the TUF metadata.

Repository Service for TUF Command Line (RSTUF CLI)
---------------------------------------------------

The :ref:`guide/repository-service-tuf-cli/index:Repository Service for TUF CLI`
(RSTUF CLI) is a CLI  application to manage the Repository Service for TUF.


TUF Metadata
============

Repository Service for TUF (RSTUF) secures downloads with signed repository
metadata using a design based on Python's `PEP 458 – Secure PyPI downloads
with signed repository metadata <https://peps.python.org/pep-0458/>`_.

.. image:: /_static/1_1_rstuf_metadata.png


More details about the above roles in the TUF documentation:

* `Root <https://theupdateframework.io/metadata/#root-metadata-rootjson>`_
* `Targets <https://theupdateframework.io/metadata/#targets-metadata-targetsjson>`_
* bins as `Delegated Targets <https://theupdateframework.io/metadata/#delegated-targets-metadata-role1json>`_,
  using `succinct delegation <https://github.com/theupdateframework/taps/blob/master/tap15.md#abstract>`_
* `Snapshot <https://theupdateframework.io/metadata/#snapshot-metadata-snapshotjson>`_
* `Timestamp <https://theupdateframework.io/metadata/#timestamp-metadata-timestampjson>`_

Configurations are customizable during the initial
:ref:`guide/deployment/setup:Service Setup`, such as the number of keys,
thresholds, expiration, etc.
