
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

    ❯ rstuf -h

    Usage: rstuf [OPTIONS] COMMAND [ARGS]...

    Repository Service for TUF Command Line Interface (CLI).

    ╭─ Options ────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
    │ --config        -c  TEXT  Repository Service for TUF config file. [default: /Users/kairo/.rstuf.yml]                 │
    │ --version                 Show the version and exit.                                                                 │
    │ --autocomplete            Enable tab autocompletion and exit.                                                        │
    │ --help          -h        Show this message and exit.                                                                │
    ╰──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯
    ╭─ Commands ───────────────────────────────────────────────────────────────────────────────────────────────────────────╮
    │ admin                             Administrative  Commands                                                           │
    │ admin-legacy                      Administrative (Legacy) Commands                                                   │
    │ artifact                          Artifact Management Commands                                                       │
    │ key                               Cryptographic Key Commands                                                         │
    │ task                              Task Management Commands                                                           │
    ╰──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯


RSTUF CLI configuration file
============================


``rstuf`` will try to read the settings configuration from a configuration file. See:
``--config/-c``, default path to the configuration file is: ``$HOME/.rstuf.yml``.

In this file, the following optional settings can be configured:

* ``SERVER`` - The Repository Service for TUF API URL.

* ``REPOSITORIES`` - TUF repositories used by ``rstuf artifact`` commands.

  .. note::

   You can generate or update this setting automatically by using ``rstuf artifact repository`` commands.

  This setting is a list of repositories with the following fields:
  ``name``, ``trusted_root`` (base64), ``metadata_url``, ``artifacts_url``
  (bool), and ``hash_prefix``.

  Example:

  .. code:: yaml

    REPOSITORIES:
        myrepo:
            artifact_base_url: http://127.0.0.1:8081
            hash_prefix: false
            metadata_url: http://127.0.0.1:8080
            trusted_root: aHR0cDovLzEyNy4wLjAuMTo4MDgwLzEucm9vdC5qc29u


* ``DEFAULT_REPOSITORY`` - The default repository to be used by ``rstuf artifact`` commands.

  .. note::

       You can generate or update this setting automatically by using ``rstuf artifact repository`` commands.

.. rstuf-cli-admin

Administration (``admin``)
==========================


.. note::

    Find the legacy administrative commands in the ``admin-legacy`` command.
    The guide is available in :doc:`admin_legacy`.

It executes administrative commands to the Repository Service for TUF.

.. code:: shell

    ❯ rstuf admin

    Usage: rstuf admin [OPTIONS] COMMAND [ARGS]...

    Administrative Commands

    ╭─ Options ─────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
    │ --help  -h    Show this message and exit.                                                                             │
    ╰───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯
    ╭─ Commands ────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
    │ ceremony                 Bootstrap Ceremony to create initial root metadata and RSTUF config.                         │
    │ import-artifacts         Import artifacts to RSTUF from exported CSV file.                                            │
    │ metadata                 Metadata management.                                                                         │
    ╰───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯


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

    ❯ rstuf admin ceremony -h

    Usage: rstuf admin ceremony [OPTIONS]

    Bootstrap Ceremony to create initial root metadata and RSTUF config.

    ╭─ Options ────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
    │ --save  -s  FILENAME  Write json result to FILENAME (default: 'ceremony-payload.json')                               │
    │ --help  -h            Show this message and exit.                                                                    │
    ╰──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯

There are four steps in the ceremony.

.. note::

    We recommend running the ``rstuf admin ceremony`` to simulate and check
    the details of the instructions. It is more detailed.


.. rstuf-cli-admin-metadata

Metadata Management (``metadata``)
----------------------------------

.. code::

    ❯ rstuf admin metadata

    Usage: rstuf admin metadata [OPTIONS] COMMAND [ARGS]...

    Metadata management.

    ╭─ Options ────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
    │ --help  -h    Show this message and exit.                                                                            │
    ╰──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯
    ╭─ Commands ───────────────────────────────────────────────────────────────────────────────────────────────────────────╮
    │ sign               Add one signature to root metadata.                                                               │
    │ update             Update root metadata and bump version.                                                            │
    ╰──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯


.. rstuf-cli-admin-metadata-sign

sign (``sign``)
...............

.. warning:: Do not share the private key.

.. code:: shell


    ❯ rstuf admin metadata sign -h

    Usage: rstuf admin metadata sign [OPTIONS] ROOT_IN [PREV_ROOT_IN]

    Add one signature to root metadata.

    ╭─ Options ────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
    │ --save  -s  FILENAME  Write json result to FILENAME (default: 'sign-payload.json')                                   │
    │ --help  -h            Show this message and exit.                                                                    │
    ╰──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯



.. rstuf-cli-admin-import-artifacts

Import Artifacts (``import-artifacts``)
---------------------------------------

This feature imports a large number of artifacts directly to RSTUF Database.
RSTUF doesn't recommend using this feature for regular flow, but in case you're
onboarding an existent repository that contains a large number of artifacts.

This feature requires extra dependencies:

.. code:: shell

    pip install repository-service-tuf[psycopg2,sqlachemy]

To use this feature, you need to create CSV files with the content to be imported
by RSTUF CLI.

This content requires the following data:

- `path <https://theupdateframework.github.io/specification/latest/#targetpath>`_: The artifact path
- `size <https://theupdateframework.github.io/specification/latest/#targets-obj-length>`_: The artifact size
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

    ❯ rstuf admin import-artifacts -h

     Usage: rstuf admin import-artifacts [OPTIONS]

     Import artifacts to RSTUF from exported CSV file.

╭─ Options ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
│    --api-server                  TEXT  RSTUF API URL i.e.: http://127.0.0.1 .                                                                       │
│ *  --db-uri                      TEXT  RSTUF DB URI. i.e.: postgresql://postgres:secret@127.0.0.1:5433 [required]                                   │
│ *  --csv                         TEXT  CSV file to import. Multiple --csv parameters are allowed. See rstuf CLI guide for more details. [required]  │
│    --skip-publish-artifacts            Skip publishing artifacts in TUF Metadata.                                                                   │
│    --help                    -h        Show this message and exit.                                                                                  │
╰─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯

    ❯ rstuf admin import-artifacts --db-uri postgresql://postgres:secret@127.0.0.1:5433 --csv artifacts-1of2.csv --csv artifacts-2of2.csv --api-server http://127.0.0.1:80/
    Import status: Loading data from ../repository-service-tuf/tests/data/artifacts-1of2.csv
    Import status: Importing ../repository-service-tuf/tests/data/artifacts-1of2.csv data
    Import status: ../repository-service-tuf/tests/data/artifacts-1of2.csv imported
    Import status: Loading data from ../repository-service-tuf/tests/data/artifacts-2of2.csv
    Import status: Importing ../repository-service-tuf/tests/data/artifacts-2of2.csv data
    Import status: ../repository-service-tuf/tests/data/artifacts-2of2.csv imported
    Import status: Commiting all data to the RSTUF database
    Import status: All data imported to RSTUF DB
    Import status: Submitting action publish artifacts
    Import status: Publish artifacts task id is dd1cbf2320ad4df6bda9ca62cdc0ef82
    Import status: task STARTED
    Import status: task SUCCESS
    Import status: Finished.


.. rstuf-cli-artifact

Artifact Management (``artifact``)
==================================

Manages artifacts using the RSTUF REST API.

.. code::

    ❯ rstuf artifact

    Usage: rstuf artifact [OPTIONS] COMMAND [ARGS]...

    Artifact Management Commands

    ╭─ Options ─────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
    │ --help  -h    Show this message and exit.                                                                             │
    ╰───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯
    ╭─ Commands ────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
    │ add                       Add artifacts to the TUF metadata.                                                          │
    │ delete                    Delete artifacts to the TUF metadata.                                                       │
    │ download                  Downloads artifacts to the TUF metadata.                                                    │
    │ repository                Repository management.                                                                      │
    ╰───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯


.. rstuf-cli-artifact-add

Artifact Addition (``add``)
---------------------------

This command adds the provided artifact to the TUF Metadata using the RSTUF REST API.

.. code::

    ❯ rstuf artifact add --help

    Usage: rstuf artifact add [OPTIONS] FILEPATH

    Add artifacts to the TUF metadata.

    ╭─ Options ────────────────────────────────────────────────────────────────────────────────────────------╮
    │ --path        -p  TEXT  A custom path (`TARGETPATH`) for the file, defined in the metadata. [required] |
    | --api-server      TEXT  URL to an RSTUF API.                                                           │
    │ --help        -h        Show this message and exit.                                                    │
    ╰──────────────────────────────────────────────────────────────────────────────────────────────────------╯

.. rstuf-cli-artifact-download

Artifact Download (``download``)
--------------------------------

This command allows downloading an artifact from a provided repository using the RSTUF REST API.

.. code::

    > rstuf artifact download --help

    Usage: rstuf artifact download [OPTIONS] ARTIFACT_NAME

    Downloads an artifact using TUF metadata from a given artifacts URL.
    Note: all options for this command can be configured.
    Read 'rstuf artifact repository' documentation for more information.

    ╭─ Options ────────────────────────────────────────────────────────────────────────────────────────╮
    │ --root              -r  TEXT  A metadata URL to the initial trusted root or a local file.        │
    │ --metadata-url      -m  TEXT  TUF Metadata repository URL.                                       │
    │ --artifacts-url     -a  TEXT  An artifacts base URL to fetch from.                               │
    │ --hash-prefix       -p        A flag to prefix an artifact with a hash.                          │
    │ --directory-prefix  -P  TEXT  A prefix for the download dir.                                     │
    │ --help              -h        Show this message and exit.                                        │
    ╰──────────────────────────────────────────────────────────────────────────────────────────────────╯

.. rstuf-cli-artifact-repository

Artifact Repository (``repository``)
------------------------------------

This command provides artifact repository management for the RSTUF repository config.

.. code::

    ❯ rstuf artifact repository --help

    Usage: rstuf artifact repository [OPTIONS] COMMAND [ARGS]...

    Repository management.

    ╭─ Options ────────────────────────────────────────────────────────────────╮
    │ --help  -h    Show this message and exit.                                │
    ╰──────────────────────────────────────────────────────────────────────────╯
    ╭─ Commands ───────────────────────────────────────────────────────────────╮
    │ add                              Add a new repository.                   │
    │ delete                           Delete a repository.                    │
    │ set                              Switch current repository.              │
    │ show                             List configured repositories.           │
    │ update                           Update repository.                      │
    ╰──────────────────────────────────────────────────────────────────────────╯

.. code::

    ❯ rstuf artifact repository add --help

    Usage: rstuf artifact repository add [OPTIONS]

    Add a new repository.

    ╭─ Options ──────────────────────────────────────────────────────────────────────────────────────────────────╮
    │ *  --name           -n  TEXT  The repository name. [required]                                              │
    │ *  --root           -r  TEXT  The metadata URL to the initial trusted root or a local file. [required]     │
    │ *  --metadata-url   -m  TEXT  TUF Metadata repository URL. [required]                                      │
    │ *  --artifacts-url  -a  TEXT  The artifacts base URL to fetch from. [required]                             │
    │    --hash-prefix    -p        Whether to add a hash prefix to artifact names.                              │
    │    --help           -h        Show this message and exit.                                                  │
    ╰────────────────────────────────────────────────────────────────────────────────────────────────────────────╯

.. code::

    ❯ rstuf artifact repository delete --help

    Usage: rstuf artifact repository delete [OPTIONS] REPOSITORY

    Delete a repository.

.. code::

    ❯ rstuf artifact repository set --help

    Usage: rstuf artifact repository set [OPTIONS] REPOSITORY

    Switch current repository.


.. code::

    ❯ rstuf artifact repository show --help

    Usage: rstuf artifact repository show [OPTIONS] [REPOSITORY]

    List configured repositories.

.. code::

    ❯ rstuf artifact repository update --help

    Usage: rstuf artifact repository update [OPTIONS] REPOSITORY

    Update repository.

    ╭─ Options ─────────────────────────────────────────────────────────────────────────────────╮
    │ --root           -r  TEXT  The metadata URL to the initial trusted root or a local file.  │
    │ --metadata-url   -m  TEXT  TUF Metadata repository URL.                                   │
    │ --artifacts-url  -a  TEXT  The artifacts base URL to fetch from.                          │
    │ --hash-prefix    -p        Whether to add a hash prefix to artifact names.                │
    │ --help           -h        Show this message and exit.                                    │
    ╰───────────────────────────────────────────────────────────────────────────────────────────╯


.. rstuf-cli-task

Task Management (``task``)
==================================

Manages tasks using the RSTUF REST API.

.. code::

    ❯ rstuf task

    Usage: rstuf task [OPTIONS] COMMAND [ARGS]...

    Task Management Commands

    ╭─ Options ────────────────────────────────────────────────────────────────────────────────────────╮
    │ --help          -h    Show this message and exit.                                                │
    ╰──────────────────────────────────────────────────────────────────────────────────────────────────╯

    ╭─ Commands ───────────────────────────────────────────────────────────────────────────────────────╮
    │ info          Retrieve task state.                                                               │
    ╰──────────────────────────────────────────────────────────────────────────────────────────────────╯

.. rstuf-cli-task-info

Task Information (``info``)
---------------------------

This command retrieves the task state of the given task ID using the RSTUF REST API.

.. code::

    ❯ rstuf task info --help

    Usage: rstuf task info [OPTIONS] TASK_ID

    Retrieve task state.

    ╭─ Options ────────────────────────────────────────────────────────────────────────────────────────╮
    │ --api-server      TEXT  RSTUF API URL, i.e., http://127.0.0.1                                    │
    │ --help          -h    Show this message and exit.                                                │
    ╰──────────────────────────────────────────────────────────────────────────────────────────────────╯
