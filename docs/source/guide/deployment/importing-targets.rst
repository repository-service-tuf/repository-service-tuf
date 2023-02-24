==========================
Importing existent targets
==========================

If you're adopting Repository Service for TUF (RSTUF), and you already have a
large number of targets (artifacts/packages/files/etc.), we recommend you use
the "import targets" feature.

If you decide, you can send all the existent targets using the Rest API, but it
will be slower than the " import targets"  feature.

The "import targets"  feature will add to the RSTUF database targets skipping
the API add targets, which creates tasks. Then it processes this data to the
RSTUF database updating the TUF Metadata.

Some information about importing performance:

* Running in a Macbook Pro (2019) 2,4 GHz 8-Core Intel Core i9/32GB 2667 MHz DDR4:

    - Adding 500,000 targets: ~40 minutes
       + Loaded 1 of 1 file with 500,000 targets
    - Adding 1,000,000 targets: ~55 minutes
       + Loaded 1 of 2 file with 500,000 targets
       + Loaded 2 of 2 file with 500,000 targets


.. warning::

    Use the API flow integration to your release process (CI/CD or Distribution
    Platform).

    Do not use the "import targets" as an integration process. We recommend
    using this feature only before going live with RSTUF.


RSTUF-CLI contains the :ref:`guide/repository-service-tuf-cli/index:Import Targets  (``import-targets\`\`)` feature.

CLI usage
=========

.. include:: ../repository-service-tuf-cli/index.rst
    :start-after: rstuf-cli-admin-import-targets
