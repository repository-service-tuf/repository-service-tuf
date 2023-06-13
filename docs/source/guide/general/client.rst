##########
TUF Client
##########

RSTUF makes it easy to host and manage TUF metadata for your content
repository.

In order to effectively protect your clients, they must download or update
artifacts from your content repository along with metadata served by RSTUF,
and interpret them in a TUF-compliant way.

RSTUF itself does not provide client-side tools, but there are several TUF
libraries that you can use.

TUF client implementation
=========================

Depending on whether you already have an existing client application the
following options exist.

New client
----------

If you don't have a client implementation, you should consider using
python-tuf's `ngclient <https://theupdateframework.readthedocs.io/en/latest/api/tuf.ngclient.html>`_.
It can download and validate metadata and artifacts in a fully specification-compliant way.
Moreover, RSTUF is built with python-tuf and guaranteed to be compatible with *ngclient*. See
`client example application <https://github.com/theupdateframework/python-tuf/tree/develop/examples/client>`_
to get started.


Existing client
---------------

If you do have a client to download and update artifacts, you can integrate
metadata download and validation functionality using a TUF library available in your
application language.

.. list-table:: TUF libraries
    :header-rows: 1
    :widths: 15 75

    * - Language
      - Project
    * - Python
      - `python-tuf <https://theupdateframework.readthedocs.io/en/latest/index.html>`_
    * - JavaScript
      - `tuf-js <https://github.com/theupdateframework/tuf-js>`_
    * - Go
      - `go-tuf <https://pkg.go.dev/github.com/theupdateframework/go-tuf/client>`_
    * - Rust
      - `rust-tuf <https://github.com/theupdateframework/rust-tuf>`_

.. note:: Not all TUF libraries support all features of the TUF specification.
   If the TUF library you need is not compatible with RSTUF or does not exist
   yet, you should file a bug on the relevant repository, or
   `reach out to the TUF community <https://theupdateframework.io/contact/>`_.

Bootstrap trust
===============

To bootstrap initial trust relationship with the metadata repository, a
client application needs to be initialized with root metadata. This can be
provided out-of-band, as part of the client application, or via
Trust-on-first-use (TOFU). TOFU is demonstrated in the python-tuf
`client example application <https://github.com/theupdateframework/python-tuf/tree/develop/examples/client>`_.

Once initial trust is established any subsequent trust changes can be adopted by
the client in-band, including root key rotation.