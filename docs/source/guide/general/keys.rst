############
Singing Keys
############

Repository Service for TUF (RSTUF) requires two sets of keys for
:ref:`guide/deployment/index:Deployment` and
:ref:`guide/deployment/setup:Service Setup`:
:ref:`guide/general/keys:Root Key(s) (offline)` and the
:ref:`guide/general/keys:Online Key`.


Root Key(s) (offline)
#####################

The Root key(s) delegates trust to TUF. The number of keys is
the number of identities/people who administer the top-level TUF Metadata.

RSTUF requires all Root key(s) only during the
:ref:`guide/deployment/setup:Service Setup` specifically during the
:ref:`guide/deployment/setup:Ceremony` process. This process also defines the
Root key threshold, representing the number of Root key(s) for future offline
operations.

.. note::
  .. collapse:: See the number of Root keys/threshold example

      An organization declares that it will utilize 5 (five) Root keys in order
      to administer the RSTUF Service. All 5 (five) people will be required
      to utilize their keys individually during the Ceremony process.

      During the Ceremony process, the same organization defines that the
      threshold for Root metadata is 2 (two).

      .. code::

        Root keys: 5
        Root keys threshold: 2

      The organization to perform :ref:`guide/general/usage:Metadata Update`
      process requires at least 2 (two) people to use their keys.

.. caution::
  The root key(s)
  `should be stored secured offline <https://theupdateframework.github.io/specification/latest/#key-management-and-migration>`_.

The key must be compatible with `Secure Systems Library <https://github.com/secure-systems-lab/securesystemslib>`_.

Online Key
##########

The online key signs TUF metadata for the roles
:ref:`that use the online key<guide/general/Introduction:TUF Metadata>`.

RSTUF requires the online key during the
:ref:`guide/deployment/setup:Service Setup`, specifically during the
:ref:`guide/deployment/setup:Ceremony` process.

During RSTUF Worker service deployment, configure the online key using a
supported `Key Vault Service <https://repository-service-tuf.readthedocs.io/en/latest/guide/repository-service-tuf-worker/Docker_README.html#required-rstuf-keyvault-backend>`_

.. caution::
  * Do not expose the online private key.
  * The online key should be stored and secured with limited access by RSTUF
    Workers only.

.. note::
    Targets, Snapshot, and Timestamp's metadata use the online key for signing.

Generating Keys with RSTUF
##########################

RSTUF Command Line Interface (CLI) provides a feature for
:ref:`guide/repository-service-tuf-cli/index:Key Generation (``generate\`\`)`


.. include:: ../repository-service-tuf-cli/index.rst
    :start-after: Key Generation (``generate``)