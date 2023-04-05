
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

    ╭─ Options ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
    │ --config   -c  TEXT  Repository Service for TUF config file                                                                      │
    │ --version            Show the version and exit.                                                                                  │
    │ --help     -h        Show this message and exit.                                                                                 │
    ╰──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯
    ╭─ Commands ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
    │ admin                      Administrative Commands                                                                               │
    │ key                        Cryptographic Key Commands                                                                            │
    ╰──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯

Administration (``admin``)
==========================

.. rstuf-cli-admin

It executes administrative commands to the Repository Service for TUF.

.. code:: shell

    ❯ rstuf admin

    Usage: rstuf admin [OPTIONS] COMMAND [ARGS]...

    Administrative Commands

    ╭─ Options ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
    │ --help  -h    Show this message and exit.                                                                                        │
    ╰──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯
    ╭─ Commands ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
    │ ceremony                        Start a new Metadata Ceremony.                                                                   │
    │ import-targets                  Import targets to RSTUF from exported CSV file.                                                  │
    │ login                           Login to Repository Service for TUF (API).                                                       │
    │ token                           Token Management.                                                                                │
    ╰──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯


Login to Server (``login``)
---------------------------

.. rstuf-cli-admin-login

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
    Username (admin): admin
    Password:
    Expire (in hours): 2
    Token stored in /Users/kairoaraujo/.repository_service_tuf.ini

    Login successful.


Ceremony (``ceremony``)
-----------------------

.. rstuf-cli-admin-ceremony

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
    ✅ Key 1/2 Verified

    Choose 2/2 root key type [ed25519/ecdsa/rsa] (ed25519):
    Enter 2/2 the root`s private key path: tests/files/JimiHendrix.key
    Enter 2/2 the root`s private key password:
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

Token (``token``)
-----------------

.. rstuf-cli-admin-token

Token Management

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

``generate``
............

.. rstuf-cli-admin-token-generate

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

``inspect``
...........

.. rstuf-cli-admin-token-inspect

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


Import Targets (``import-targets``)
-----------------------------------

.. rstuf-cli-admin-import-targets

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


Key Management (``key``)
========================

.. rstuf-cli-key

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

Key Generation (``generate``)
-----------------------------

.. rstuf-cli-key-generate

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