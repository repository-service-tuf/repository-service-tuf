kaprien-repo-worker design
===========================

kaprien-repo-worker context level
---------------------------------

The ``kaprien-repo-worker``, in the context perspective, is a Consumer and
Publisher from the Broker that receives tasks to perform in the
`TUF Metadata Repository`. The `Metadata Repository` is stored using a
*Repository Storage Service* that reads/writes this data. For signing
this Metadata, the ``kaprien-repo-worker`` uses the *Key Vault Repository
Service* to access the online keys.

.. uml:: ../../diagrams/kaprien-repo-worker-C1.puml


kaprien-repo-worker container level
-----------------------------------

The ``kaprien-repo-worker``, in the container perspective, is a Metadata
Repository worker that performs actions to the TUF Metadata.

It will consume tasks from the Broker server and execute the task actions in
the Metadata Repository using the ``Storage Service`` to handle the TUF
Metadata. For signing the Metadata, it will use the ``Key Vault Service`` to
manage the keys. After executing any action, ``kaprien-rest-api`` publishes to
the Broker.

The ``kaprien-repo-worker`` implements the services ``Storage Service`` and the
``Key Vault Service`` to support different technologies for storage and key
vault storage.

Current supported Storage Services types:
    - LocalStorage (File System)
    - S3Storage (AWS S3 Object Storage -- to be implemented)

Current supported Key Vault Service types:
    - LocalKeyVault (File System)
    - KMS (AWS KMS -- to be implemented)

The ``kaprien-repo-worker`` stores configuration settings. These are the
**Worker Settings**.

The ``kaprien-repo-worker``also uses the **Repository Settings**, from
``KAPRIEN_REDIS_SERVER``.

**Worker Settings**: are related to the operational configurations to run the
``kaprien-repo-worker`` such as worker id, Broker, type of Storage, Key
Vault services and their sub-configurations, etc.

**Repository Settings** are given by ``kaprien-rest-api`` and
are stored in ``KAPRIEN_REDIS_SERVER`` to run routine tasks such as bumping
snapshot and timestamp metadata, etc.


.. uml:: ../../diagrams/kaprien-repo-worker-C2.puml
