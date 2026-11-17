############
Signing Keys
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

Multiple online keys
====================

A repository may declare more than one online key. All of them are assigned
to the Targets, Snapshot, and Timestamp roles, and metadata for those roles
is signed by every one of them.

The online keys are managed by the repository administrator, either during
the :ref:`guide/deployment/setup:Ceremony` or through a
:ref:`guide/general/usage:Metadata Update`. Both flows offer an
add/remove/continue prompt to manage the collection.

Role-specific online keys
=========================

A custom delegation does not have to be signed by every repository online
key. When creating a delegation you can choose:

* **Online keys (repository defaults)** -- the delegation is signed by
  whichever online keys the repository currently declares. This is the
  default and matches the behavior of repositories that use a single online
  key.
* **Online keys (select subset)** -- the delegation is signed only by the
  selected subset of the repository online keys.
* **Add a role online key** -- an online key that only this delegation
  trusts. It is declared in the delegation metadata rather than in root, so
  it is never used to sign the top-level roles or any other delegation.
* **Add offline keys** -- the existing offline-key flow, unchanged.

Nested hash bins created under a delegation inherit the delegation's keys;
they are never configured separately.

.. note::
    Whichever option is used, the Worker needs access to the private key
    to sign automatically -- provision it in the Worker's key vault exactly
    as you would the repository online key. For file-based keys the CLI
    prints the file name the Worker expects.

.. caution::
    A delegation that trusts a repository online key has no privilege over
    it. Removing a repository online key from a role is rejected.
    Change the repository online keys through a
    :ref:`guide/general/usage:Metadata Update`, which requires the root
    keys. Keys that belong to the role itself (role online keys and offline
    keys) can be added and removed through the delegation flows.
