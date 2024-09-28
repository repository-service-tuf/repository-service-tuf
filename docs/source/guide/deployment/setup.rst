#############
Service Setup
#############

Repository Service for TUF (RSTUF) has two specific processes as part of the
initial setup: Ceremony and Bootstrap.

.. note::
    * The setup and configuration requirements:

      - Set of root key(s) and online key for signing
      - RSTUF service deployed


Ceremony and Bootstrap
######################

.. note::
    * It is a one-time process to setup the RSTUF service. If this process is
      completed during the :ref:`deployment <guide/deployment/index:Deployment>`
      do not run it again.

RSTUF Command Line Interface provides a guided process for the Ceremony and
Bootstrap.

To make this process easier,
the :ref:`guide/repository-service-tuf-cli/index:Repository Service for TUF CLI`
provides an interactive guided process to perform the
:ref:`Ceremony <guide/repository-service-tuf-cli/index:Ceremony (``ceremony\`\`)>`.

.. note::
    Required RSTUF CLI installed
    (See :ref:`guide/repository-service-tuf-cli/index:Installation`)

.. code::

    ❯ rstuf admin ceremony -h


Ceremony
========

The Ceremony defines the RSTUF settings/configuration and generates the initial
signed TUF root metadata.

It does not activate the RSTUF service. It generates the required JSON payload
to bootstrap the RSTUF service.

The Ceremony can be done :ref:`guide/deployment/setup:Connected` as a specific
step or :ref:`guide/deployment/setup:Disconnected`, combined with
:ref:`guide/deployment/setup:Bootstrap`.

This process generates the initial metadata and defines some settings of the
TUF service.

.. collapse:: See settings details

    * Timestamp, Snapshot, and  Targets metadata expiration policy

        Defines how long this metadata is valid. The metadata is invalid when it
        expires.

    * Delegations

        - Bins (online key only)

          The target metadata file might contain a large number of artifacts.
          The target role delegates trust to the hash bin roles to
          reduce the metadata overhead for clients.

          This metadata is signed using the online key.

        - Custom Delegations (online/offline keys)

          Allows the RSTUF admin to create custom delegation that can use the
          online key or offline key(s) to sign the metadata.
          The custom delegation can be used to define the roles and paths for
          the target metadata.

    * Root metadata expiration policy

        Defines how long this metadata is valid, for example, 365 days (year).
        This metadata is invalid when it expires.

    * Root threshold

        It defines the number of keys required to sign the Root metadata.

        The minimum number of keys required to update and sign the TUF Root
        metadata. It's required to be at least 2.

        .. note::
          * Updating the Root metadata with new expiration, changing/updating keys or
            the number of keys, threshold, or rotating a new online key and sign
            requires following the :ref:`guide/general/usage:Metadata Update`
            process.


        .. note::
            RSTUF requires at least a threshold number of Root key(s) defined
            to finish the ceremony. The same applies when performing
            :ref:`guide/general/usage:Metadata Update`.


    * Signing

        This process will also require the Online Key and Root Key(s) (offline) for
        signing the initial root TUF metadata.

The settings are guided during :ref:`Ceremony <guide/repository-service-tuf-cli/index:Ceremony (``ceremony\`\`)>`.

Disconnected
------------

The disconnected Ceremony will only generate the required JSON payload
(``ceremony-payload.json``) file. The :ref:`guide/deployment/setup:Bootstrap`
requires the payload.

.. note::
    The payload (``ceremony-payload.json``) contains only public data, it does
    not contain any private keys.

This process is appropriate when performing the Ceremony on a disconnected computer
to RSTUF API to perform the :ref:`guide/deployment/setup:Bootstrap` later as a
separate step.

.. code::

    ❯ rstuf admin ceremony --out
    Saved result to 'ceremony-payload.json'

If the Ceremony is done disconnected, the next step is to perform the bootstrap.


Connected
---------

The connected Ceremony generates the JSON payload file and run the Bootstrap
request to RSTUF API.

This process is appropriate when performing the Ceremony on a computer
connected to RSTUF API. It does not require a
:ref:`guide/deployment/setup:Bootstrap` step.

.. code::

    ❯ rstuf admin --api-server https://rstuf-api-url ceremony


Bootstrap
=========

If a Ceremony :ref:`guide/deployment/setup:Connected` is complete, skip this,
as the RSTUF service is ready.

To perform the boostrap you require the payload generated during the
:ref:`guide/deployment/setup:Bootstrap`.

You can do it using the rstuf admin-legacy

.. code::

    ❯ rstuf admin --api-server http://rstuf-api-url send bootstrap ceremony-payload.json
    Starting online bootstrap
    Bootstrap status: ACCEPTED (c1d2356d25784ecf90ce373dc65b05c7)
    Bootstrap status:  STARTED
    Bootstrap status:  SUCCESS
    Bootstrap completed using `ceremony-payload.json`. 🔐 🎉
