
==============================
Repository Service for TUF CLI
==============================

``repository-service-tuf`` is a Command Line Interface for the Repository Service for TUF.

Installation
============

Using pip:

.. code:: shell

    $ pip install repository-service-tuf

.. code:: shell

    ❯ rstuf

    Usage: rstuf [OPTIONS] COMMAND [ARGS]...

    Repository Service for TUF Command Line Interface (CLI).

    ╭─ Options ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
    │ --config   -c  TEXT  Repository Service for TUF config file.                                                                                                                                                                 │
    │ --auth               Use of RSTUF built-in authentication.                                                                                                                                                                   │
    │ --version            Show the version and exit.                                                                                                                                                                              │
    │ --help     -h        Show this message and exit.                                                                                                                                                                             │
    ╰──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯
    ╭─ Commands ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
    │ admin                                    Administrative Commands                                                                                                                                                             │
    │ key                                      Cryptographic Key Commands                                                                                                                                                          │
    ╰──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯

.. rstuf-cli-admin

Administration (``admin``)
==========================

It executes administrative commands to the Repository Service for TUF.

.. code:: shell

    ❯ rstuf admin

    Usage: rstuf admin [OPTIONS] COMMAND [ARGS]...

    Administrative Commands

    ╭─ Options ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
    │ --help  -h    Show this message and exit.                                                                                                                                                                                    │
    ╰──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯
    ╭─ Commands ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
    │ ceremony                                              Start a new Metadata Ceremony.                                                                                                                                         │
    │ import-targets                                        Import targets to RSTUF from exported CSV file.                                                                                                                        │
    ╰──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯

.. rstuf-cli-admin-login

Login to Server (``login``)
---------------------------

.. note::
    requires ``--auth``

This command will log in to Repository Service for TUF and give you a token to run other commands
such as Ceremony, Token Generation, etc.

.. code:: shell

    ❯ rstuf admin login
    ╔══════════════════════════════════════════════════════════════════════════════════════╗
    ║                     Login to Repository Service for TUF                              ║
    ╚══════════════════════════════════════════════════════════════════════════════════════╝

    ┌──────────────────────────────────────────────────────────────────────────────────────┐
    │         The server and token will generate a token and it will be                    │
    │         stored in /Users/kairoaraujo/.rstuf.ini                                      │
    └──────────────────────────────────────────────────────────────────────────────────────┘

    Server Address: http://192.168.1.199
    Password for admin:
    Expire (in hours): 2
    Token stored in /Users/kairoaraujo/.repository_service_tuf.ini

    Login successful.

.. rstuf-cli-admin-ceremony

Ceremony (``ceremony``)
-----------------------

The Repository Service for TUF Metadata uses the following Roles: ``root``, ``timestamp``,
``snapshot``, ``targets``, and ``bins`` to build the Repository
Metadata (for more details, check out TUF Specification and PEP 458).

The Ceremony is a complex process that Repository Service for TUF CLI tries to simplify.
You can do the Ceremony offline. This means on a disconnected computer
(recommended once you will manage the keys).


.. code:: shell

    ❯ rstuf admin ceremony --help

    Usage: rstuf admin ceremony [OPTIONS]

    Start a new Metadata Ceremony.

    ╭─ Options ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
    │ --bootstrap  -b        Bootstrap a Repository Service for TUF using the Repository Metadata after Ceremony                       │
    │ --file       -f  TEXT  Generate specific JSON Payload compatible with TUF Repository Service bootstrap after Ceremony            │
    │                        [default: payload.json]                                                                                   │
    │ --upload     -u        Upload existent payload 'file'. Requires '-b/--bootstrap'. Optional '-f/--file' to use non default file.  │
    │ --save       -s        Save a copy of the metadata locally. This option saves the JSON metadata files in the 'metadata' folder   │
    │                        in the current directory.                                                                                 │
    │ --help       -h        Show this message and exit.                                                                               │
    ╰──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯

There are four steps in the ceremony.

.. note::

    We recommend running the ``rstuf admin ceremony`` to simulate and check
    the details of the instructions. It is more detailed.


Step 1: Configure the Roles
...........................

.. code:: shell

    ❯ rstuf admin ceremony

    (...)
    Do you want to start the ceremony? [y/n]: y
    ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
    ┃                         STEP 1: Configure the Roles                          ┃
    ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

    The TUF root role supports multiple keys and the threshold (quorum of trust)
    defines the minimal number of keys required to take actions using the root role.

    Reference: TUF Goals for PKI

    The TUF roles have an expiration, clients must not trust expired metadata.

    Reference: TUF expires

                                            root configuration

    What is the metadata expiration for the root role?(Days) (365):
    What is the number of keys for the root role? (2):
    What is the key threshold for the root role signing? (1):

                                        targets configuration

    What is the metadata expiration for the targets role?(Days) (365):


    The target metadata file might contain a large number of target files.
    That is why the targets role
    delegates trust to the hash bin roles to reduce the metadata overhead for
    clients.

    See: TUF Specification about succinct hash bin delegation.
    Show example? [y/n] (y): y

    Choose the number of delegated hash bin roles [2/4/8/16/32/64/128/256/512/1024/2048/4096/8192/16384] (256): 16

    What is the targets base URL? (i.e.: https://www.example.com/downloads/): http://www.example.com/downloads/

                                        snapshot configuration

    What is the metadata expiration for the snapshot role?(Days) (1):

                                        timestamp configuration

    What is the metadata expiration for the timestamp role?(Days) (1):

                                            bins configuration

    What is the metadata expiration for the bins role?(Days) (1):



1. root ``expiration``, ``number of keys``, and ``threshold``
2. targets ``expiration``, the ``base URL`` for the files (target files), and the
   ``number of delegated hash bins``
3. snapshot ``expiration``
4. timestamp ``expiration``
5. bins ``expiration``

- ``expiration`` is the number of days in which the metadata will expire
- ``number of keys`` the metadata will have
- ``threshold`` is the number of keys needed to sign the metadata
- ``base URL`` for the artifacts, example: http://www.example.com/download/
- ``number of delegated hash bins`` is the number of hash bin roles, How many
  delegated roles (``bins-X``) will it create?

Step 2: Load the Online Key
...........................

.. code::

    ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
    ┃                                   STEP 2: Load the Online Key                                    ┃
    ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛


                                            The Online Key

    The online key is the same one provided to the Repository Service for TUF Workers (RSTUF Worker).
    This key is responsible for signing the snapshot, timestamp, targets, and delegated targets (hash
    bin) roles.

    The RSTUF Worker uses this key during the process of managing the metadata.

    Note: the ceremony process won't show any password or key content.

    Choose 1/1 ONLINE key type [ed25519/ecdsa/rsa] (ed25519):
    Enter 1/1 the ONLINE`s private key path: tests/files/online.key
    Enter 1/1 the ONLINE`s private key password:
    [Optional] Give a name/tag to the key:
    ✅ Key 1/1 Verified

    Step 3: Validate the information/settings
    .........................................

    After confirming all details, the initial payload for bootstrap will be
    complete (without the offline keys).


Step 3: Load Root Keys
......................

It is essential to define the key owners. There is a suggestion in the CLI.

The owners will need to be present to insert their keys and passwords
to load their keys.

.. code::

    ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
    ┃                                      STEP 3: Load Root Keys                                      ┃
    ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛


                                                Root Keys

    The keys must have a password, and the file must be accessible.

    Depending on the organization, each key has an owner, and each owner should insert their password
    personally.

    Note: the ceremony process won't show any password or key content.

    Choose 1/2 root key type [ed25519/ecdsa/rsa] (ed25519):
    Enter 1/2 the root`s private key path: tests/files/JanisJoplin.key
    Enter 1/2 the root`s private key password:
    [Optional] Give a name/tag to the key:
    ✅ Key 1/2 Verified

    Choose 2/2 root key type [ed25519/ecdsa/rsa] (ed25519):
    Enter 2/2 the root`s private key path: tests/files/JimiHendrix.key
    Enter 2/2 the root`s private key password:
    [Optional] Give a name/tag to the key:
    ✅ Key 2/2 Verified

Step 4: Validate Configuration
..............................

.. code::

    ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
    ┃                                  STEP 4: Validate Configuration                                  ┃
    ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

    The information below is the configuration done in the previous steps. Check the number of keys, the
    threshold/quorum, and the key details.


    ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
    ┃ ONLINE KEY SUMMARY                                                                                                ┃
    ┡━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┩
    │                          ╷        ╷          ╷                                                                    │
    │                     path │  type  │ verified │                                id                                  │
    │ ╶────────────────────────┼────────┼──────────┼──────────────────────────────────────────────────────────────────╴ │
    │   tests/files/online.key │ Online │    ✅    │ f7a6872f297634219a80141caa2ec9ae8802098b07b67963272603e36cc19fd8   │
    │                          ╵        ╵          ╵                                                                    │
    └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘

    Is the online key configuration correct? [y/n]: y


    ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
    ┃ ROLE SUMMARY              ┃                                                 KEYS                                                 ┃
    ┡━━━━━━━━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┩
    │                           │                               ╷         ╷          ╷                                                 │
    │ Role: root                │                          path │  type   │ verified │                      id                         │
    │ Number of Keys: 2         │ ╶─────────────────────────────┼─────────┼──────────┼───────────────────────────────────────────────╴ │
    │ Threshold: 1              │   tests/files/JanisJoplin.key │ Offline │    ✅    │ 1cebe343e35f0213f6136758e6c3a8f8e1f9eeb7e47a…   │
    │ Role Expiration: 365 days │   tests/files/JimiHendrix.key │ Offline │    ✅    │ 800dfb5a1982b82b7893e58035e19f414f553fc08cbb…   │
    │                           │                               ╵         ╵          ╵                                                 │
    └───────────────────────────┴──────────────────────────────────────────────────────────────────────────────────────────────────────┘

    Is the root configuration correct? [y/n]: y


    ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
    ┃ ROLE SUMMARY                                ┃                                        KEYS                                        ┃
    ┡━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┩
    │                                             │          ╷          ╷                                                              │
    │ Role: targets                               │    type  │ verified │                             id                               │
    │ Role Expiration: 365 days                   │ ╶────────┼──────────┼────────────────────────────────────────────────────────────╴ │
    │                                             │   Online │    ✅    │ f7a6872f297634219a80141caa2ec9ae8802098b07b67963272603e36…   │
    │                                             │          ╵          ╵                                                              │
    │                                             │                                                                                    │
    │ Base URL: http://www.example.com/downloads/ │                                                                                    │
    │                                             │                                                                                    │
    │ DELEGATIONS                                 │                                                                                    │
    │ targets -> bins                             │                                                                                    │
    │ Number of bins: 16                          │                                                                                    │
    └─────────────────────────────────────────────┴────────────────────────────────────────────────────────────────────────────────────┘

    Is the targets configuration correct? [y/n]: y


    ┏━━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
    ┃ ROLE SUMMARY            ┃                                           KEYS                                           ┃
    ┡━━━━━━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┩
    │                         │          ╷          ╷                                                                    │
    │ Role: snapshot          │    type  │ verified │                                id                                  │
    │ Role Expiration: 1 days │ ╶────────┼──────────┼──────────────────────────────────────────────────────────────────╴ │
    │                         │   Online │    ✅    │ f7a6872f297634219a80141caa2ec9ae8802098b07b67963272603e36cc19fd8   │
    │                         │          ╵          ╵                                                                    │
    └─────────────────────────┴──────────────────────────────────────────────────────────────────────────────────────────┘

    Is the snapshot configuration correct? [y/n]: y


    ┏━━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
    ┃ ROLE SUMMARY            ┃                                           KEYS                                           ┃
    ┡━━━━━━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┩
    │                         │          ╷          ╷                                                                    │
    │ Role: timestamp         │    type  │ verified │                                id                                  │
    │ Role Expiration: 1 days │ ╶────────┼──────────┼──────────────────────────────────────────────────────────────────╴ │
    │                         │   Online │    ✅    │ f7a6872f297634219a80141caa2ec9ae8802098b07b67963272603e36cc19fd8   │
    │                         │          ╵          ╵                                                                    │
    └─────────────────────────┴──────────────────────────────────────────────────────────────────────────────────────────┘

    Is the timestamp configuration correct? [y/n]: y


    ┏━━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
    ┃ ROLE SUMMARY            ┃                                           KEYS                                           ┃
    ┡━━━━━━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┩
    │                         │          ╷          ╷                                                                    │
    │ Role: bins              │    type  │ verified │                                id                                  │
    │ Role Expiration: 1 days │ ╶────────┼──────────┼──────────────────────────────────────────────────────────────────╴ │
    │                         │   Online │    ✅    │ f7a6872f297634219a80141caa2ec9ae8802098b07b67963272603e36cc19fd8   │
    │                         │          ╵          ╵                                                                    │
    └─────────────────────────┴──────────────────────────────────────────────────────────────────────────────────────────┘

    Is the bins configuration correct? [y/n]: y

Finishing
.........

If you choose ``-b/--bootstrap`` it will automatically send the bootstrap to
``repository-service-tuf-api``, no actions necessary.

If you did the ceremony in a disconnected computer:
Using another computer with access to ``repository-service-tuf-api``

  1.  Get the generated ``payload.json`` (or the custom name you chose)
  2.  Install ``repository-service-tuf``
  3.  Run ``rstuf admin ceremony -b -u [-f filename]``


.. rstuf-cli-admin-metadata

Metadata Management (``metadata``)
----------------------------------

.. code::

    ❯ rstuf admin metadata

    Usage: rstuf admin metadata [OPTIONS] COMMAND [ARGS]...

    Token Management.

    ╭─ Options ──────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
    │  --help  -h    Show this message and exit.                                                                             │
    ╰────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯
    ╭─ Commands ─────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
    │  update  Start a new metadata update ceremony.                                                                         │
    ╰────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯

.. rstuf-cli-admin-metadata-update

update
......

The metadata update ceremony allows to:
- extend Root expiration
- change Root signature threshold
- change any signing key

.. code::

    ❯ rstuf admin metadata update --help

    Usage: rstuf admin metadata update [OPTIONS]

    Start a new metadata update ceremony.

    ╭─ Options ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
    │ --current-root-uri      TEXT  URL or local path to the current root.json file.                                                             │
    │ --file              -f  TEXT  Generate specific JSON payload file [default: metadata-update-payload.json]                                  │
    │ --upload            -u        Upload existent payload 'file'. Optional '-f/--file' to use non default file name.                           │
    │ --run-ceremony                When '--upload' is set this flag can be used to run the ceremony and the result will be uploaded.            │
    │ --save              -s        Save a copy of the metadata locally. This option saves the JSON metadata update payload file in the current  │
    │                               directory.                                                                                                   │
    │ --help              -h        Show this message and exit.                                                                                  │
    ╰────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯

.. code::

    ❯ rstuf admin metadata update

    ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
    ┃                                         Metadata Update                                          ┃
    ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

    The metadata update ceremony allows to:

    • extend Root expiration
    • change Root signature threshold
    • change any signing key

    The result of this ceremony will be a new metadata-update-payload.json file.


    NOTICE: This is an alpha feature and will get updated over time!


    File name or URL to the current root metadata: rstuf/cli/tests/files/root.json

    ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
    ┃                                       Current Root Content                                       ┃
    ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

    Before deciding what you want to update it's recommended that you get familiar with the current
    state of the root metadata file.


    ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
    ┃ Root                         ┃                                                                                    KEYS                                                                                     ┃
    ┡━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┩
    │                              │                                                                    ╷              ╷          ╷         ╷                                                                    │
    │                              │                                  Id                                │   Name/Tag   │ Key Type │ Storage │                           Public Value                             │
    │ Number of Keys: 2            │ ╶──────────────────────────────────────────────────────────────────┼──────────────┼──────────┼─────────┼──────────────────────────────────────────────────────────────────╴ │
    │ Threshold: 1                 │   1cebe343e35f0213f6136758e6c3a8f8e1f9eeb7e47a07d5cb336462ed31dcb7 │ Martin's Key │ ed25519  │ Offline │ ad1709b3cb419b99c5cd7427d6411522e5a93aec6767453e91af921a73d22a3c   │
    │ Root Expiration: 2024-Apr-30 │   800dfb5a1982b82b7893e58035e19f414f553fc08cbb1130cfbae302a7b7fee5 │ Steven's Key │ ed25519  │ Offline │ 7098f769f6ab8502b50f3b58686b8a042d5d3bb75d8b3a48a2fcbc15a0223501   │
    │                              │                                                                    ╵              ╵          ╵         ╵                                                                    │
    └──────────────────────────────┴─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘

The metadata ceremony consists of 4 steps:

Step 1: Authorization
"""""""""""""""""""""
.. code::

    ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
    ┃                                      STEP 1: Authorization                                       ┃
    ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

    Before continuing, you must authorize using the current root key(s).

    In order to complete the authorization you will be asked to provide information about one or more
    keys used to sign the current root metadata. To complete the authorization, you must provide
    information about one or more keys used to sign the current root metadata. The number of required
    keys is based on the current "threshold".

    You will need local access to the keys as well as their corresponding passwords.
    You will need to load 1 key(s).
    You will enter information for key 0 of 1

    Choose root key type [ed25519/ecdsa/rsa] (ed25519):
    Enter the root`s private key path: rstuf/cli/tests/files/key_storage/JanisJoplin.key
    Enter the root`s private key password:
    ✅ Key 1/1 Verified

    Authorization is successful

Step 2: Extend Root Expiration
""""""""""""""""""""""""""""""
.. code::

    ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
    ┃                                  STEP 2: Extend Root Expiration                                  ┃
    ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

    Now, you will be given the opportunity to extend root's expiration.

    Note: the root expiration can be extended ONLY during the metadata update ceremony.


    Current root expiration: 2024-Apr-30
    Do you want to extend the root's expiration? [y/n]: y
    Days to extend root's expiration starting from today (365):
    New root expiration: 2024-May-28. Do you agree? [y/n]: y

Note: Root's expiration is extended starting from today and not from the
current root expiration date.

Step 3: Root Keys Changes
"""""""""""""""""""""""""

.. code::

    ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
    ┃                                  STEP 3:  Root Keys Changes                                      ┃
    ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

    You are starting the Root keys changes procedure.

    Note: when asked about specific attributes the default values that are suggested will be the ones
    used in the current root metadata.


    Do you want to change the root metadata? [y/n]: y

    What should be the root role threshold? (1):

                                            Root Keys Removal
                                            -----------------

    You are starting the root keys modification procedure.

    First, you will be asked if you want to remove any of the keys. Then you will be given the
    opportunity to add as many keys as you want.

    In the end, the number of keys that are left must be equal or above the threshold you have given.
    Here are the current root keys:
    ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━┳━━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
    ┃                        Id                        ┃   Name/Tag   ┃ Key Type ┃ Storage ┃ Singing Key ┃                   Public Value                   ┃
    ┡━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━╇━━━━━━━━━━╇━━━━━━━━━╇━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┩
    │ 1cebe343e35f0213f6136758e6c3a8f8e1f9eeb7e47a07d… │ Martin's Key │ ed25519  │ Offline │    True     │ ad1709b3cb419b99c5cd7427d6411522e5a93aec6767453… │
    │ 800dfb5a1982b82b7893e58035e19f414f553fc08cbb113… │ Steven's Key │ ed25519  │ Offline │    False    │ 7098f769f6ab8502b50f3b58686b8a042d5d3bb75d8b3a4… │
    └──────────────────────────────────────────────────┴──────────────┴──────────┴─────────┴─────────────┴──────────────────────────────────────────────────┘


    Do you want to remove a key [y/n]: y
    Name/Tag of the key to remove: Martin's Key
    Key with name/tag Martin's Key removed

    Here are the current root keys:
    ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━┳━━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
    ┃                        Id                        ┃   Name/Tag   ┃ Key Type ┃ Storage ┃ Singing Key ┃                   Public Value                   ┃
    ┡━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━╇━━━━━━━━━━╇━━━━━━━━━╇━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┩
    │ 800dfb5a1982b82b7893e58035e19f414f553fc08cbb113… │ Steven's Key │ ed25519  │ Offline │    False    │ 7098f769f6ab8502b50f3b58686b8a042d5d3bb75d8b3a4… │
    └──────────────────────────────────────────────────┴──────────────┴──────────┴─────────┴─────────────┴──────────────────────────────────────────────────┘


    Do you want to remove a key [y/n]: n

                                            Root Keys Addition
                                            ------------------

    Now, you will be able to add root keys.
    You need to have at least 1 signing keys.

    Here are the current root signing keys:
    ┏━━━━┳━━━━━━━━━━┳━━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━━━━━┳━━━━━━━━━━━━━━┓
    ┃ Id ┃ Name/Tag ┃ Key Type ┃ Storage ┃ Singing Key ┃ Public Value ┃
    ┡━━━━╇━━━━━━━━━━╇━━━━━━━━━━╇━━━━━━━━━╇━━━━━━━━━━━━━╇━━━━━━━━━━━━━━┩
    └────┴──────────┴──────────┴─────────┴─────────────┴──────────────┘

    Do you want to add a new key? [y/n]: y

    Choose root key type [ed25519/ecdsa/rsa] (ed25519):
    Enter the root`s private key path: rstuf/cli/tests/files/key_storage/JanisJoplin.key
    Enter the root`s private key password:
    [Optional] Give a name/tag to the key: Kairo's Key

    Here are the current root keys:
    ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━┳━━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
    ┃                        Id                        ┃   Name/Tag   ┃ Key Type ┃ Storage ┃ Singing Key ┃                   Public Value                   ┃
    ┡━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━╇━━━━━━━━━━╇━━━━━━━━━╇━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┩
    │ 800dfb5a1982b82b7893e58035e19f414f553fc08cbb113… │ Steven's Key │ ed25519  │ Offline │    False    │ 7098f769f6ab8502b50f3b58686b8a042d5d3bb75d8b3a4… │
    └──────────────────────────────────────────────────┴──────────────┴──────────┴─────────┴─────────────┴──────────────────────────────────────────────────┘

    Do you want to add a new key? [y/n]: n

    Here is the current content of root:


    ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
    ┃ Root                         ┃                                                          KEYS                                                          ┃
    ┡━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┩
    │                              │                                  ╷              ╷          ╷         ╷             ╷                                   │
    │                              │                 Id               │   Name/Tag   │ Key Type │ Storage │ Singing Key │          Public Value             │
    │ Number of Keys: 2            │ ╶────────────────────────────────┼──────────────┼──────────┼─────────┼─────────────┼─────────────────────────────────╴ │
    │ Threshold: 1                 │   800dfb5a1982b82b7893e58035e19… │ Steven's Key │ ed25519  │ Offline │    False    │ 7098f769f6ab8502b50f3b58686b8a…   │
    │ Root Expiration: 2024-Jun-12 │   1cebe343e35f0213f6136758e6c3a… │ Kairo's Key  │ ed25519  │ Offline │    True     │ ad1709b3cb419b99c5cd7427d64115…   │
    │                              │                                  ╵              ╵          ╵         ╵             ╵                                   │
    └──────────────────────────────┴────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘


    Do you want to change the root metadata? [y/n]: n
    Skipping further root metadata changes


Step 4: Online Key Change
"""""""""""""""""""""""""

.. code::

    ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
    ┃                                    STEP 4: Online Key Change                                     ┃
    ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

    Now you will be given the opportunity to change the online key.

    The online key is used to sign all roles except root.

    Note: there can be only one online key at a time.

    Here is the information for the current online key:


    ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━┳━━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
    ┃                      Id                      ┃  Name/Tag  ┃ Key Type ┃ Storage ┃                 Public Value                  ┃
    ┡━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━╇━━━━━━━━━━╇━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┩
    │ f7a6872f297634219a80141caa2ec9ae8802098b07b… │ Online key │ ed25519  │ Online  │ 9fe7ddccb75b977a041424a1fdc142e01be4abab918d… │
    └──────────────────────────────────────────────┴────────────┴──────────┴─────────┴───────────────────────────────────────────────┘


    Do you want to change the online key? [y/n]: y

    Choose root key type [ed25519/ecdsa/rsa] (ed25519): rsa
    Enter the root`s private key path: rstuf/cli/tests/files/key_storage/online-rsa.key
    Enter the root`s private key password:
    [Optional] Give a name/tag to the key: New Online Key

    Here is the information for the current online key:


    ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━┳━━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
    ┃                     Id                     ┃    Name/Tag    ┃ Key Type ┃ Storage ┃                Public Value                 ┃
    ┡━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━╇━━━━━━━━━━╇━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┩
    │ b1b4a183b603ad34e898ab7a3b4d138d5fab5bcd7… │ New Online Key │   rsa    │ Online  │         -----BEGIN PUBLIC KEY-----          │
    │                                            │                │          │         │ MIIBojANBgkqhkiG9w0BAQEFAAOCAY8AMIIBigKCAY… │
    │                                            │                │          │         │ sp+ZH8CqbF1f4DeKodBooz5nx5pN+xzPe7T3WPZLAc… │
    │                                            │                │          │         │ wOD4KtpoAOJnjZWwEYk5SO/28RlaZoye/USrnvsSE4… │
    │                                            │                │          │         │ Rf91kYH6qM/fr4e87K81HXGyfZ4Vqshg/Q1wybBB1A… │
    │                                            │                │          │         │ PaTvB4f746vPfBhqxpzJ8/E3spXA2eOIoGOPrHkZhp… │
    │                                            │                │          │         │ KicMXaLyt9yD15bwy/7boupBcpBGIg1tPr1r8nzPdu… │
    │                                            │                │          │         │ 62SyHP8JvwYPEgbYfJHQjaSJUV0ZYAP15TF6S8ZNeZ… │
    │                                            │                │          │         │ eKfiWVtujJHvxW5rN7bKreZ4qMi4/u8wHoqPslO2QC… │
    │                                            │                │          │         │ Vb14QJQvtQNjy8IGu/J04bzhIbtPjQh5pps2llK3Ty… │
    │                                            │                │          │         │          -----END PUBLIC KEY-----           │
    └────────────────────────────────────────────┴────────────────┴──────────┴─────────┴─────────────────────────────────────────────┘


    Do you want to change the online key? [y/n]: n
    Skipping further online key changes

                                                            Payload Generation

    Verifying the new payload...
    The new payload is verified
    File metadata-update-payload.json successfully generated

Finishing
"""""""""

The metadata update ceremony should be used when a user wants to update the
content of their metadata files.
In order to fully complete this besides finishing the ceremony steps you need
to send the resulting payload to the active RSTUF API deployment
(```repository-service-tuf-api``) you already use.

There are a few of ways to you can fully complete the metadata update ceremony:

* Run ceremony and upload it with one command:

    * Run ``rstuf admin metadata update -u --run-ceremony``

* Do it in two steps:

    * Finish the metadata ceremony and generate ``metadata-update-payload.json`` (or the custom name you chose)

    * Run ``rstuf admin metadata update -u [-f filename]``

.. rstuf-cli-admin-token

Token (``token``)
-----------------

Token Management

.. note::
    requires ``--auth``

.. code::

    ❯ rstuf admin token

    Usage: rstuf admin token [OPTIONS] COMMAND [ARGS]...

    Token Management.

    ╭─ Options ──────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
    │  --help  -h    Show this message and exit.                                                                             │
    ╰────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯
    ╭─ Commands ─────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
    │  generate  Generate new token.                                                                                         │
    │  inspect   Show token information details.                                                                             │
    ╰────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯

.. rstuf-cli-admin-token-generate

``generate``
............

Generate tokens to use in integrations.

.. code::

    ❯ rstuf admin token generate -h

    Usage: rstuf admin token generate [OPTIONS]

    Generate a new token.

    ╭─ Options ────────────────────────────────────────────────────────────────────────────────────────╮
    │     --expires  -e  INTEGER  Expires in hours. Default: 24 [default: 24]                          │
    │  *  --scope    -s  TEXT     Scope to grant. Multiple is accepted. Ex: -s write:targets -s        │
    │                             read:settings                                                        │
    │                             [required]                                                           │
    │     --help     -h           Show this message and exit.                                          │
    ╰──────────────────────────────────────────────────────────────────────────────────────────────────╯

Example of usage:

.. code:: shell

    ❯ rstuf admin token generate -s write:targets
    {
        "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJ1c2VyX
        zFfNTNiYTY4MzAwNTk3NGY2NWIxMDQ5NzczMjIiwicGFzc3dvcmQiOiJiJyQyYiQxMiRxT0
        5NRjdRblI3NG0xbjdrZW1MdFJld05MVDN2elNFLndsRHowLzBIWTJFaGxpY05uaFgzdSci
        LCJzY29wZXMiOlsid3JpdGU6dGFyZ2V0cyJdLCJleHAiOjE2NjIyODExMDl9.ugwibyv8H
        -zVgGgRfliKgUgHZrZzeJDeAw9mQJrYLz8"
    }

This token can be used with GitHub Secrets, Jenkins Secrets, CircleCI, shell
script, etc

.. rstuf-cli-admin-token-inspect

``inspect``
...........

Show token detailed information.

.. code:: shell

    ❯ rstuf admin token inspect -h

    Usage: rstuf admin token inspect [OPTIONS] TOKEN

    Show token information details.

    ╭─ Options ──────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
    │  --help  -h    Show this message and exit.                                                                             │
    ╰────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯

    ❯ rstuf admin token inspect eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJ1...PDwwY
    {
    "data": {
        "scopes": [
        "write:targets"
        ],
        "expired": false,
        "expiration": "2022-09-04T08:42:44"
    },
    "message": "Token information"
    }


.. rstuf-cli-admin-import-targets

Import Targets (``import-targets``)
-----------------------------------

This feature imports a large number of targets directly to RSTUF Database.
RSTUF doesn't recommend using this feature for regular flow, but in case you're
onboarding an existent repository that contains a large number of targets.

This feature requires extra dependencies:

.. code:: shell

    pip install repository-service-tuf[psycopg2,sqlachemy]

To use this feature, you need to create CSV files with the content to be imported
by RSTUF CLI.

This content requires the following data:

- `path <https://theupdateframework.github.io/specification/latest/#targetpath>`_: The target path
- `size <https://theupdateframework.github.io/specification/latest/#targets-obj-length>`_: The target size
- `hash-type <https://theupdateframework.github.io/specification/latest/#targets-obj-length>`_: The defined hash as a metafile. Example: blak2b-256
- `hash <https://theupdateframework.github.io/specification/latest/#targets-obj-length>`_: The hash

The CSV must use a semicolon as the separator, following the format
``path;size;hash-type;hash`` without a header.

See the below CSV file example:

.. code::

    relaxed_germainv1.tar.gz;12345;blake2b-256;716f6e863f744b9ac22c97ec7b76ea5f5908bc5b2f67c61510bfc4751384ea7a
    vigilant_keldyshv2.tar.gz;12345;blake2b-256;716f6e863f744b9ac22c97ec7b76ea5f5908bc5b2f67c61510bfc4751384ea7a
    adoring_teslav3.tar.gz;12345;blake2b-256;716f6e863f744b9ac22c97ec7b76ea5f5908bc5b2f67c61510bfc4751384ea7a
    funny_greiderv4.tar.gz;12345;blake2b-256;716f6e863f744b9ac22c97ec7b76ea5f5908bc5b2f67c61510bfc4751384ea7a
    clever_ardinghelliv5.tar.gz;12345;blake2b-256;716f6e863f744b9ac22c97ec7b76ea5f5908bc5b2f67c61510bfc4751384ea7a
    pbeat_galileov6.tar.gz;12345;blake2b-256;716f6e863f744b9ac22c97ec7b76ea5f5908bc5b2f67c61510bfc4751384ea7a
    wonderful_gangulyv7.tar.gz;12345;blake2b-256;716f6e863f744b9ac22c97ec7b76ea5f5908bc5b2f67c61510bfc4751384ea7a
    sweet_ardinghelliv8.tar.gz;12345;blake2b-256;716f6e863f744b9ac22c97ec7b76ea5f5908bc5b2f67c61510bfc4751384ea7a
    brave_mendelv9.tar.gz;12345;blake2b-256;716f6e863f744b9ac22c97ec7b76ea5f5908bc5b2f67c61510bfc4751384ea7a
    nice_ridev10.tar.gz;12345;blake2b-256;716f6e863f744b9ac22c97ec7b76ea5f5908bc5b2f67c61510bfc4751384ea7a


.. code:: shell

    ❯ rstuf admin import-targets -h

     Usage: rstuf admin import-targets [OPTIONS]

     Import targets to RSTUF from exported CSV file.

    ╭─ Options ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
    │ *                          --metadata-url  TEXT  RSTUF Metadata URL i.e.: http://127.0.0.1 . [required]                                                         │
    │ *                          --db-uri        TEXT  RSTUF DB URI. i.e.: postgresql://postgres:secret@127.0.0.1:5433 [required]                                     │
    │ *                          --csv           TEXT  CSV file to import. Multiple --csv parameters are allowed. See rstuf CLI guide for more details. [required]    │
    │    --skip-publish-targets                       Skip publishing targets in TUF Metadata.                                                                        │
    │    --help                  -h                   Show this message and exit.                                                                                     │
    ╰─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯

    ❯ rstuf admin import-targets --db-uri postgresql://postgres:secret@127.0.0.1:5433 --csv targets-1of2.csv --csv targets-2of2.csv --metadata-url http://127.0.0.1:8080/
    Import status: Loading data from ../repository-service-tuf/tests/data/targets-1of2.csv
    Import status: Importing ../repository-service-tuf/tests/data/targets-1of2.csv data
    Import status: ../repository-service-tuf/tests/data/targets-1of2.csv imported
    Import status: Loading data from ../repository-service-tuf/tests/data/targets-2of2.csv
    Import status: Importing ../repository-service-tuf/tests/data/targets-2of2.csv data
    Import status: ../repository-service-tuf/tests/data/targets-2of2.csv imported
    Import status: Commiting all data to the RSTUF database
    Import status: All data imported to RSTUF DB
    Import status: Submitting action publish targets
    Import status: Publish targets task id is dd1cbf2320ad4df6bda9ca62cdc0ef82
    Import status: task STARTED
    Import status: task SUCCESS
    Import status: Finished.


.. rstuf-cli-key

Key Management (``key``)
========================

It executes commands related to cryptographic key management and may be used
for managing keys in the Repository Service for TUF.

.. code:: shell

    ❯ rstuf key

    Usage: rstuf key [OPTIONS] COMMAND [ARGS]...

    Cryptographic Key Commands

    ╭─ Options ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
    │ --help  -h    Show this message and exit.                                                                                        │
    ╰──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯
    ╭─ Commands ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
    │ generate                        Generate cryptographic keys using the `securesystemslib` library                                 │
    ╰──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯


.. rstuf-cli-key-generate

Key Generation (``generate``)
-----------------------------

This command will generate cryptographic keys using the ``securesystemslib`` library.
The user is requested to provide:

1. the key type, from the supported list of encryption algorithms

2. the key's filename, whose path will be the current working directory

3. a password, to encrypt the private key file

After the above procedure, two files, the private and public key
(e.g., ``id_ed25519`` and ``id_ed25519.pub``), will be generated in the current
working directory.

The generated keys may be used in the Repository Service for TUF Ceremony
process, for the online key or the TUF roles' keys (``root``, ``targets``, etc. keys).

.. code::

    ❯ rstuf key generate

    Choose key type [ed25519/ecdsa/rsa] (ed25519): ed25519
    Enter the key's filename: (id_ed25519): id_ed25519
    Enter password to encrypt private key file 'id_ed25519':
    Confirm: