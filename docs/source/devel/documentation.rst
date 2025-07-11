
=============
Documentation
=============


Structure
=========

Repository Service for TUF 's main/umbrella Repository maintains the Guide and the Development
Guide.

The documentation in structure is:

.. code:: shell

    docs
    ├── diagrams
    ├── source
        ├── _static
        ├── devel
        │   ├── <component>_design.rst
        ├── guide
        │   ├── index.rst
        │   ├── installation
        │   ├── <component-guide>
        └── index.rst

To gives the component's developer the responsibility and the flexibility to
build their documentation. The component needs to follow a structure.

The Repository Service for TUF main/umbrella uses high-level documentation from the components to
build the Guide and the Development Guide.

The components documentation also follows a required structure:

.. code:: shell

    <component-repository>/docs
    ├── diagrams [
    │   ├── <component-name>-C1.puml '[C1 Design level]'
    │   ├── <component-name>-C2.puml '[C2 Design level]'
    │   └── <component-name>-C3.puml '[C3 Design level]'
    │   └── <component-name>-specifics-feature.puml
    └── source
        ├── guide '[All `User Guide` information in this folder]'
        │   └── index.rst
        │   └── ...
        │   └── details.rst
        ├── devel
        │   ├── design.rst '[Only C1-C2 level (high-level) details/information]'
        │   ├── ...
        │   └── index.rst
        └── index.rst


- All diagrams needs to be in ``docs/diagrams`` and must to use ``<component-name>``
  in the name
- The umbrella repository will merge the ``source/guide`` into the main guide.
- The umbrella repository will use the ``source/devel/design`` in the main
  Development Guide, so add to this document only the high-level information
  for Developers.

Each component will build your own documentation with more low level and
specific information as well.


Building Documentation
======================

The umbrella repository has the component as git sub-module and builds the
documentation using the Makefile (``make docs``)

For each component, the ``make docs`` should also be available.


Versioning Documentation
=======================

The RSTUF documentation follows the same versioning scheme as the software components (X.Y.Z). When a new version of RSTUF is released, a corresponding version of the documentation is created.

To create a new documentation version:

1. Ensure all documentation changes for the release are merged to the main branch
2. Tag the repository with the new version (e.g., v1.2.3)
3. The CI/CD pipeline will build the documentation and create a new version on ReadTheDocs
4. Update the version history in the :ref:`guide/general/versioning:Documentation Versioning` guide

This ensures users can access documentation specific to their RSTUF version.

In the
`umbrella repository <https://github.com/repository-service-tuf/repository-service-tuf>`_
> `Releases <https://github.com/repository-service-tuf/repository-service-tuf/releases>`_
> `Draft new release <https://github.com/repository-service-tuf/repository-service-tuf/releases/new>`_

Choose a new release tag based on the :ref:`devel/release:versioning`
documentation.

After Click on ``Generate release notes`` and keep the relevant updates.