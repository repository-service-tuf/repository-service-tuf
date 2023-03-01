==========================
Importing existing targets
==========================

If you're adopting Repository Service for TUF (RSTUF), and you already have a
large number of targets (artifacts/packages/files/etc.), we recommend you use
the "import targets" feature.

If you decide, you can send all of the existing targets using the REST API, but it
will be slower than using the "import targets" feature.

The "import targets" feature can be used to add targets directly to the RSTUF
database skipping the standard processing of the API.
Normally, when you add a target through the API there will be an overhead of
multiple additional operations which for a large number of targets can prove
to be significant.

Here are some benchmarks of the "import targets" feature:

* Running in a Macbook Pro (2019) 2,4 GHz 8-Core Intel Core i9/32GB 2667 MHz DDR4:

    - Adding 500,000 targets: ~40 minutes
       + Loaded 1 of 1 file with 500,000 targets
    - Adding 1,000,000 targets: ~55 minutes
       + Loaded 1 of 2 file with 500,000 targets
       + Loaded 2 of 2 file with 500,000 targets


.. warning::

    Use the API flow integration to your release process (CI/CD or Distribution
    Platform).

    Do not use "import targets" as a replacement for the standard procedure to
    add targets throughout the RSTUF API or CLI tool after RSTUF is deployed.
    This feature should only be used before going live with RSTUF.


RSTUF-CLI contains the :ref:`guide/repository-service-tuf-cli/index:Import Targets  (``import-targets\`\`)` feature.

CLI usage
=========

.. include:: ../repository-service-tuf-cli/index.rst
    :start-after: rstuf-cli-admin-import-targets
