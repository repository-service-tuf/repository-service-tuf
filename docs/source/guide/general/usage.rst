###########
Using RSTUF
###########


Assuming a successful Repository Service for TUF (RSTUF)
:ref:`guide/deployment/index:Deployment` and
:ref:`guide/deployment/setup:Service Setup` is complete, these are
the usage:


Adding/Removing artifacts to TUF Metadata
#########################################

RSTUF allows organizations to easily integrate the robust TUF metadata along
the existing content repositories using the RSTUF API.

Adding or removing artifacts to the content repository to protect the user must
be added to TUF metadata, enabling the :ref:`guide/general/client:TUF Client`
to fetch the new artifact using the trusted metadata.

.. uml::

    @startuml
        agent release
        folder content_repository as "Content Repository" {
            artifact vxyz as "downloads/release/project/artifact-vX.Y.Z"
        }
        folder metadat as "TUF Metadata" #DodgerBlue {
            rectangle vxyz_metadata as "release/project/artifact-vX.Y.Z"
        }
        release --> vxyz
        release --> vxyz_metadata
    @enduml

Releasing the artifact in the content repository does not require changes to the
existing process.

To manage artifacts in the TUF metadata, use HTTP requests to the RSTUF API.
The main actions are adding or removing artifacts to the metadata.

A successful RSTUF deployment will have an RSTUF HTTP(S) API service

``http://<IP ADDRESS>/api/v1/``

Adding artifacts
==========================

Send requests to ``http://<IP ADDRESS>/api/v1/artifacts`` with method ``POST``
with a JSON payload.

.. note::
    See the complete
    `API documentation <https://repository-service-tuf.github.io/repository-service-tuf-api/>`_

* This payload supports one or multiple artifacts (targets)

* The `add targets payload schema <https://repository-service-tuf.github.io/repository-service-tuf-api/#/v1/post_api_v1_artifacts__post>`_

Add artifacts payload
-------------------

.. code-block:: json
    :linenos:

    {
        "targets": [
            {
            "info": {
                "length": "<LENGTH>",
                "hashes": {
                "<HASH-NAME>": "<HASH>"
                },
            },
            "path": "<PATH>"
            }
        ]
    }

.. list-table:: Required parameters
    :header-rows: 1
    :widths: 25 50 25

    * - Parameters
      - Details
      - Example
    * - ``LENGTH``
      - `An integer length in bytes of the artifact <https://theupdateframework.github.io/specification/latest/#targets-obj-length>`_
      - ``48365``
    * - ``HASH-NAME``
      - `A hash algorithm names <https://theupdateframework.github.io/specification/latest/#targets-obj-length>`_
      - ``sha256``
    * - ``HASH``
      - The hash output, such as ``shasum -a 256 <artifact>``
      - ``95cef21e0d8707e4b46c85cd130a37c5c03f747f140b7d9e2bd817b7fcc13511``
    * - ``PATH``
      - The full artifact path, excluding the Base URL. If clients will
        look for artifacts in
        ``http://example.com/download/release/projectA/file1.tar.gz`` the
        path should exclude the Base URL ``http://example.com/download/``
      - ``release/projectA/file1.tar.gz``


Removing artifacts
============================

Send requests to ``http://<IP ADDRESS>/api/v1/artifacts/delete`` with method ``POST``
with a JSON payload.

.. note::
    See the complete
    `API documentation <https://repository-service-tuf.github.io/repository-service-tuf-api/>`_

* This payload supports one or multiple artifacts

* The `remove artifacts payload schema <https://repository-service-tuf.github.io/repository-service-tuf-api/#/v1/post_delete_api_v1_artifacts_delete_post>`_

Remove artifacts payload
----------------------

.. code-block:: json
    :linenos:

    {
        "targets": ["<PATH>"]
    }

.. list-table:: Required parameters
    :header-rows: 1
    :widths: 20 50 20

    * - Parameters
      - Details
      - Example
    * - ``PATH``
      - The full artifact path, excluding the Base URL. If clients will
        look for artifacts in
        ``http://example.com/download/release/projectA/file1.tar.gz`` the
        path should exclude the Base URL ``http://example.com/download/``
      - ``release/projectA/file1.tar.gz``

Advanced Usage
##############

Managing adding/removing artifacts tasks -- call-backs
==================================================================

Adding/removing artifacts to Repository Service for TUF (RSTUF) is an
asynchronous process.

Submitting a request for adding/removing will return an HTTP status code 202,
meaning the task is submitted. As part of the body, there is the ``task id``.

Response body adding/removing targets, ``task id``:

.. code-block:: json

    {
        "data": {
            "task_id": "<TASK ID>",
        },
    }

This body has more details such as targets, last_update, etc. See the
`endpoint response documentation <https://repository-service-tuf.github.io/repository-service-tuf-api/>`_

To retrieve the task status, send requests to
``http://<IP ADDRESS>/api/v1/task?task_id=<TASK ID>`` with method
``GET``.

The response will have a body with all task details

.. code-block:: json

    {
        "data": {
            "task_id": "<TASK ID>",
            "state": "<STATE>",
            "result": {
            "status": "Task finished.",
            "details": {
                "key": "value"
            }
            }
        },
        "message": "Task state."
    }

See the `endpoint task documentation <https://repository-service-tuf.github.io/repository-service-tuf-api/#/v1/get_api_v1_task__get>`_
for more details.

Adding artifacts for back-signing
=========================================

Repository Service for TUF (RSTUF) allows adding artifacts without publishing
immediately to the TUF Metadata.

As example, an organization adds and removes artifacts while batch publishing daily.


This feature requires adding the ``publish_targets`` parameter to
:ref:`guide/general/usage:Add artifacts payload` or
:ref:`guide/general/usage:Remove artifacts payload`.

Examples:

Adding artifacts without publishing

.. code-block:: json
    :linenos:
    :emphasize-lines: 13

    {
        "targets": [
            {
            "info": {
                "length": "<LENGTH>",
                "hashes": {
                "<HASH-NAME>": "<HASH>"
                },
            },
            "path": "<PATH>"
            }
        ],
        "publish_targets": false
    }

Removing artifacts without publishing

.. code-block:: json
    :linenos:
    :emphasize-lines: 3

    {
        "targets": ["<PATH>"],
        "publish_targets": false
    }

To publish all artifacts added/removed without publishing, send a request to
``http://<IP ADDRESS>/api/v1/targets/publish`` with method ``POST``.

.. note::
    See the complete
    `API documentation <https://repository-service-tuf.github.io/repository-service-tuf-api/>`_


Recovering a compromised key
============================

The Repository Service for TUF (RSTUF) can help to replace the compromised keys.

If an offline (Root) key is compromised (a threshold of keys
belonging to the metadata to the Root metadata) is required a
:ref:`guide/general/usage:Metadata Update`.

If the online key is compromised, it requires a
:ref:`guide/general/usage:Metadata Update` to replace the online
key.

Metadata Update
---------------

The Metadata Update ceremony is a guided process allowing you to:

- add or remove key(s)
- change the Root role key threshold
- change the Root expiration

Before starting the Metadata Update Ceremony authorization is required with
at least one private root key to be fully loaded.

The changes a user is allowed to make are not limited to the Root role, but
also include the keys used by all other roles as well.

When the ceremony is complete, the CLI can send the new information
directly to an RSTUF API instance or save it locally into a JSON file.

The Metadata Update ceremony could be used for multiple use cases as for
example:

- recover from a compromised key
- remove a key for a person leaving the organization
- add a new key to be used by a new employee
- improve the security of a repository by increasing the Root role threshold


Importing existing targets
==========================

When adopting Repository Service for TUF (RSTUF), with a
large number of targets (artifacts/packages/files/etc.), using
the "import targets" feature is recommended.

Existing targets can be sent using the REST API, however it
will be slower than using the "import targets" feature.

The "import targets" feature can be used to add targets directly to the RSTUF
database skipping the standard processing of the API.
Normally, when adding a target through the API there will be an overhead of
multiple additional operations which for a large number of targets can prove
to be significant.

Below are sample benchmarks of the "import targets" feature:

* Running in a Macbook Pro (2019) 2,4 GHz 8-Core Intel Core i9/32GB 2667 MHz DDR4:

    - Adding 500,000 targets: ~40 minutes
       + Loaded 1 of 1 file with 500,000 targets
    - Adding 1,000,000 targets: ~55 minutes
       + Loaded 1 of 2 file with 500,000 targets
       + Loaded 2 of 2 file with 500,000 targets


.. warning::

    Use the API flow integration to the release process (CI/CD or Distribution
    Platform).

    Do not use "import targets" as a replacement for the standard procedure to
    add targets throughout the RSTUF API or CLI tool after RSTUF is deployed.
    This feature should only be used before going live with RSTUF.


RSTUF-CLI contains the :ref:`guide/repository-service-tuf-cli/index:Import Targets  (``import-targets\`\`)` feature.

CLI usage
---------

.. include:: ../repository-service-tuf-cli/index.rst
    :start-after: rstuf-cli-admin-import-targets
    :end-before: rstuf-cli-key


.. note::

    When providing users with download or update capabilities, it is necessary to add
    signed metadata checkpoints to the functionality tools.
