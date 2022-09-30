Worker design
=============

Context level
-------------

The ``tuf-repository-service-worker``, in the context perspective, is a Consumer and
Publisher from the Broker that receives tasks to perform in the
`TUF Metadata Repository`. The `Metadata Repository` is stored using a
*Repository Storage Service* that reads/writes this data. For signing
this Metadata, the ``tuf-repository-service-worker`` uses the *Key Vault Repository
Service* to access the online keys.

.. uml:: ../../diagrams/tuf-repository-service-worker-C1.puml


Container level
---------------

The ``tuf-repository-service-worker``, in the container perspective, is a Metadata
Repository worker that performs actions to the TUF Metadata.

It will consume tasks from the Broker server and execute the task actions in
the Metadata Repository using the ``Storage Service`` to handle the TUF
Metadata. For signing the Metadata, it will use the ``Key Vault Service`` to
manage the keys. After executing any action, ``tuf-repository-service-api`` publishes to
the Broker.

The ``tuf-repository-service-worker`` implements the services ``Storage Service`` and the
``Key Vault Service`` to support different technologies for storage and key
vault storage.

Current supported Storage Services types:
    - LocalStorage (File System)
    - S3Storage (AWS S3 Object Storage -- to be implemented)

Current supported Key Vault Service types:
    - LocalKeyVault (File System)
    - KMS (AWS KMS -- to be implemented)

The ``tuf-repository-service-worker`` stores configuration settings. These are the
**Worker Settings**.

The ``tuf-repository-service-worker``also uses the **Repository Settings**, from
``TRS_REDIS_SERVER``.

**Worker Settings**: are related to the operational configurations to run the
``tuf-repository-service-worker`` such as worker id, Broker, type of Storage, Key
Vault services and their sub-configurations, etc.

**Repository Settings** are given by ``tuf-repository-service-api`` and
are stored in ``TRS_REDIS_SERVER`` to run routine tasks such as bumping
snapshot and timestamp metadata, etc.


.. uml:: ../../diagrams/tuf-repository-service-worker-C2.puml
