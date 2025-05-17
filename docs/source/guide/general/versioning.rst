#######################
Documentation Versioning
#######################

RSTUF Documentation Versioning
==============================

The Repository Service for TUF (RSTUF) documentation is versioned to ensure users can access the correct documentation for the specific version of RSTUF they are using.

How Versioning Works
-------------------

RSTUF documentation follows the same versioning scheme as the software components: ``X.Y.Z`` where:

- ``X`` is the major version (incompatible changes)
- ``Y`` is the minor version (new features)
- ``Z`` is the micro version (bugfixes)

Each released version of the documentation corresponds to a specific release of the RSTUF components.

Accessing Versioned Documentation
--------------------------------

You can access specific versions of the documentation in several ways:

1. **Latest Documentation**: The default documentation at https://repository-service-tuf.readthedocs.io/en/latest/ always shows the most recent release.

2. **Specific Version**: To access documentation for a specific version, use the version selector dropdown in the bottom-left corner of the ReadTheDocs interface, or use URLs in the format: https://repository-service-tuf.readthedocs.io/en/vX.Y.Z/

3. **Development Version**: The documentation for the current development version (not yet released) is available at https://repository-service-tuf.readthedocs.io/en/develop/

Version History
--------------

Below is a list of major documentation versions and the significant changes they contain:

.. list-table:: Documentation Version History
   :header-rows: 1
   :widths: 15 15 70

   * - Version
     - Release Date
     - Major Changes
   * - 1.0.0
     - YYYY-MM-DD
     - Initial stable release
   * - 0.9.0
     - YYYY-MM-DD
     - Beta release with complete feature set
   * - 0.8.0
     - YYYY-MM-DD
     - Alpha release with core functionality

Component-Specific Documentation
-------------------------------

Each RSTUF component (API, Worker, CLI) maintains its own versioned documentation as well. The umbrella documentation aggregates these component-specific docs into a comprehensive guide.

When a component is updated, its documentation is updated accordingly, and these changes are reflected in the next release of the umbrella documentation.

Documentation Feedback
--------------------

If you find any issues with the documentation or have suggestions for improvement, please:

1. Open an issue in the `RSTUF repository <https://github.com/repository-service-tuf/repository-service-tuf/issues>`_
2. Specify which version of the documentation you're referring to
3. Provide details about the issue or suggestion

Your feedback helps us improve the documentation for all users.