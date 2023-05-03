##########
TUF client
##########

Repository Service for TUF (RSTUF) implements the repository side, which
controls the trusted TUF metadata adding/removing artifacts (target files).

The TUF client will validate the trusted TUF metadata and fetch the artifact
(target file) from the content repository.

A TUF client protects the user's actions.

.. uml::

    @startuml
        actor User as User
        User -> Client: Download artifact vX.Y.Z
        group TUF
            collections TUF as "TUF Metadata"
            Client -> TUF: Request metadata
            TUF --> Client: Metadata
            Client -> Client: Validates Signatures 🔑
            database Artifact as "Content Repository"
            Client -> Artifact: Fetch artifact vX.Y.Z
            Artifact --> Client: Fetch artifact vX.Y.Z
        end
        Client -> User: Artifact vX.Y.Z
    @enduml


Implementing TUF client
=======================


TUF project has specific language libraries to implement the TUF client.

.. list-table:: TUF libraries
    :header-rows: 1
    :widths: 15 25 50

    * - Language
      - Project
      - Example
    * - Python
      - `Python-TUF <https://theupdateframework.readthedocs.io/en/latest/index.html>`_
      - `Python example <https://github.com/theupdateframework/python-tuf/tree/develop/examples/client>`_,
        `Python code example <https://github.com/theupdateframework/python-tuf/blob/develop/examples/client/client>`_
    * - JavaScript
      - `tuf-js <https://github.com/theupdateframework/tuf-js>`_
      - `JavaScript example <https://github.com/theupdateframework/tuf-js/tree/develop/examples/client>`_,
        `JavaScript code example <https://github.com/theupdateframework/tuf-js/blob/develop/examples/client/client>`_
    * - Go
      - `go-tuf <https://pkg.go.dev/github.com/theupdateframework/go-tuf/client>`_
      -
    * - Rust
      - `rust-tuf <https://github.com/theupdateframework/rust-tuf>`_
      -
