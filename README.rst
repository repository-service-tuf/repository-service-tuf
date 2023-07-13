Repository Service for TUF (RSTUF)
==================================

.. image:: ./docs/source/_static/logo/PNG/rstuf_horizontal-color.png

.. readme-logo

|OpenSSF Best Practices|

.. |OpenSSF Best Practices| image:: https://bestpractices.coreinfrastructure.org/projects/6587/badge
  :target: https://bestpractices.coreinfrastructure.org/projects/6587

.. readme-intro

Repository Service for TUF (RSTUF) is a collection of components that provide
services for securing content downloads from tampering between the repository
and the client (for example, by an on-path attacker).

RSTUF security properties are achieved by implementing
`The Update Framework <https://theupdateframework.io/>`_ (TUF) as a service.

**Repository Service for TUF is platform, artifact, language, and process-flow
agnostic.**

.. readme-design

RSTUF simplifies the adoption of TUF by removing the need to design a
repository integration -- RSTUF encapsulates that design.

Repository Service for TUF (RSTUF) is designed to be integrated with existing
content delivery solutions -- at the edge or in public/private clouds --
alongside current artifact production systems, such as build systems,
including; Jenkins, GitHub Actions, GitLab, CircleCI, etc. RSTUF protects
downloading, installing, and updating content from arbitrary content
repositories, such as a web server, JFrog Artifactory, GitHub packages, etc.

Thanks to the REST API, integrating RSTUF into your existing content delivery
solutions is straightforward. Furthermore, RSTUF is designed for scalability
and can support active repositories with multiple repository workers.

At present, RSTUF implements a streamlined variant of the Python Package Index
(PyPI)'s `PEP 458 – Secure PyPI downloads with signed repository metadata
<https://peps.python.org/pep-0458/>`_. In the future, RSTUF will grow to provide
additional protections through supporting the end-to-end signing of packages,
comparable to PyPI's `PEP 480 – Surviving a Compromise of PyPI: End-to-end
signing of packages <https://peps.python.org/pep-0480/>`_.


.. readme-other-solutions-comparison

How does Repository Service for TUF compare to other solutions?

`Rugged <https://rugged.works>`_: Repository Service for TUF is a collection
of services to deploy a scalable and distributed TUF Repository. RSTUF
provides an easy interface to integrate (the REST API) and a tool for
managing the Metadata Repository (CLI).

`PyPI/PEP 458 <https://peps.python.org/pep-0458/>`_: Repository Service for
TUF is a generalization of the design in PEP 458 that can be integrated into
a variety of content repository architectures.

.. rstuf-image-high-level

.. image:: docs/source/_static/1_1_rstuf.png
    :align: center

Using
=====

Please, check the `Repository Service for TUF Guide
<https://repository-service-tuf.readthedocs.io/en/latest/guide/>`_
for the instructions about deployment, using and more details.

Contributing
============

This git repository contains high-level documentation guides and component
integrations.

Check our `CONTRIBUTING.rst <CONTRIBUTING.rst>`_ for more details on how to
contribute.

Please, check the `Repository Service for TUF Development Guide
<https://repository-service-tuf.readthedocs.io/en/latest/devel/>`_.

Questions, feedback, and suggestions are welcomed on the
`#repository-service-for-tuf <https://cloud-native.slack.com/archives/C047L55314N>`_
channel on `CNCF Slack <https://slack.cncf.io/>`_.

.. _ROADMAP: ROADMAP.rst
