.. ansible-dc documentation master file, created by
   sphinx-quickstart on Wed May 26 10:41:35 2022.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

=====================
Kaprien Documentation
=====================

.. note::
   The Kaprien is a tool still under development and is not ready for
   production.

What is Kaprien?
================
Kaprien is an implementation of The Update Framework (`TUF`_) as a service.
Kaprien's design intends to be deployed and used along build systems (i.e.,
Jenkins, Github Actions, GitLab, CircleCI, etc.) and protect your artifact
repository (web server with files, JFrog Artifactory, Github Packages, etc.).

Kaprien uses `TUF`_ to help to maintain the security of software provisioning
systems, providing protection even against attackers that compromise the
Repository or signing keys.

.. uml:: ../diagrams/1_1_kaprien.puml

The goals are:

   - Easy tool/platform to be used deployed and used by
     Developers/DevOps/DevOpsSec
   - Easy to integrate with CI/CD infrastructure
   - Easy to manage the metadata


See more details about in :ref:`guide/overview/overview:Introduction`

Roadmap
=======

v0.0.1
------

- [✔️] Authentication using Token
- [✔️] Authorization defined by Scope
- [✔️] Bootstrap the Kaprien Service (Initial TUF Metadata)
- [✔️] Storage Service: Local file system
- [✔️] Key Vault Service: Local file system
- [✔️] Add targets
- [ ] Delete targets (`Issue #14 <https://github.com/kaprien/kaprien/issues/14>`_)
- [✔️] Generate Token
- [✔️] Retrieves the Kaprien Server settings
- [✔️] Automatically version Bump Snapshot Metadata
- [✔️] Automatically version Bump Timestamp Metadata
- [✔️] Automatically version Bump hash-bins Metadata
- [ ] `Snapshot` Key(s) Rotation (`Issue #15 <https://github.com/kaprien/kaprien/issues/15>`_)
- [ ] `Timestamp` Key(s) Rotation (`Issue #15 <https://github.com/kaprien/kaprien/issues/15>`_)
- [ ] `BINS` Key(s) Rotation (`Issue #15 <https://github.com/kaprien/kaprien/issues/15>`_)
- [ ] Online Key(s) Rotation [`Root`, `Targets`, `BIN`] (`Issue #15 <https://github.com/kaprien/kaprien/issues/15>`_)
- [ ] Implement HTTPS for the Rest API (`Issue #6 <https://github.com/kaprien/kaprien/issues/6>`_)
- [ ] Add TLS/SSL for Broker and Result Backend communication (`Issue #6 <https://github.com/kaprien/kaprien/issues/6>`_)
- [ ] Add TLS/SSL for Broker communication (`Issue #6 <https://github.com/kaprien/kaprien/issues/6>`_)

Documentation List
==================

.. toctree::
   :maxdepth: 1

   guide/index
   devel/index


.. _TUF: https://theupdateframework.io
.. _python-tuf: https://pypi.org/project/tuf/
