#############
Service Setup
#############

Repository Service for TUF (RSTUF) has two specific processes as part of the
initail setup: Ceremony and Bootstrap.

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


We have a video to show this process.

   .. raw:: html

      <div style="position: relative; padding-bottom: 56.25%; height: 0; margin-bottom: 2em; overflow: hidden; max-width: 100%; height: auto;">
         <iframe src="https://www.youtube.com/embed/j18NvkNfs2A" frameborder="0" allowfullscreen style="position: absolute; top: 0; left: 0; width: 100%; height: 100%;"></iframe>
      </div>



Ceremony
========

The Ceremony defines the RSTUF settings/configuration and generates the initial
signed TUF root metadata.

It doesn't activate the RSTUF service. It generates the required JSON payload
to bootstrap your RSTUF service.

The Ceremony can be done :ref:`guide/deployment/setup:Connected` as a specific
step or :ref:`guide/deployment/setup:Disconnected`, combined with
:ref:`guide/deployment/setup:Bootstrap`.

This process generates the initial metadata and defines some settings of your
TUF service.

.. collapse:: See settings details

    * Root metadata expiration policy

        Defines how long this metadata is valid, for example, 365 days (year).
        This metadata is invalid when it expires.

    * Root number of keys

        It is the total number of root keys (offline keys) used by the TUF Root
        metadata.
        The number of keys implies that the number of identities is the TUF
        Metadata’s top-level administrator.

        .. note::
          * Updating the Root metadata with new expiration, changing/updating keys or
            the number of keys, threshold, or rotating a new online key and sign
            requires following the :ref:`guide/general/usage:Metadata Update`
            process.

        .. note::
            RSTUF requires all Root key(s) during the
            :ref:`guide/deployment/setup:Ceremony`.

        .. note::
            RSTUF requires at least the threshold number of Root key(s) for
            :ref:`guide/general/usage:Metadata Update`.


    * Root key threshold

        The minimum number of keys required to update and sign the TUF Root
        metadata.

    * Targets, BINS, Snapshot, and Timestamp metadata expiration policy

        Defines how long this metadata is valid. The metadata is invalid when it
        expires.

    * Targets number of delegated hash bin roles

        The target metadata file might contain a large number of artifacts.
        That’s why the target role delegates trust to the hash bin roles to
        reduce the metadata overhead for clients.

    * Targets base URL

        The base URL path for downloading all artifacts.
        Example: https://www.example.com/download/

    * Singing

        This process will also require the Online Key and Root Key(s) (offline) for
        signing the initial root TUF metadata.

The settings are guided during :ref:`Ceremony <guide/repository-service-tuf-cli/index:Ceremony (``ceremony\`\`)>`.

Disconnected
------------

The disconnected Ceremony will only generate the required JSON payload
(``payload.json``) file. The :ref:`guide/deployment/setup:Bootstrap` requires the
payload.

.. note::
    The payload (``payload.json``) contains only public data, it do not contain
    private keys.

This process is proper when performing the Ceremony on a disconnected computer
to RSTUF API to perform the :ref:`guide/deployment/setup:Bootstrap` later as a
separate step.

.. code::

    ❯ rstuf admin ceremony


Connected
---------


The connected Ceremony generates the JSON payload file and run the Bootstrap
request to RSTUF API.

This process is proper when performing the Ceremony on a computer
connected to RSTUF API. It doesn't require a
:ref:`guide/deployment/setup:Bootstrap` step.

.. code::

    ❯ rstuf --no-auth admin ceremony -b

.. note::

    if using authentication/authorization the login is required

    .. code::

        ❯ rstuf admin login
        ❯ rstuf admin ceremony -b


Bootstrap
=========

If a Ceremony :ref:`guide/deployment/setup:Connected` is complete, skip this,
your RSTUF service is ready.

If a Ceremony :ref:`guide/deployment/setup:Disconnected` is complete, it
requires running the Bootstrap from a computer connected to the RSTUF API.


.. code::

    ❯ rstuf admin ceremony -b -u

