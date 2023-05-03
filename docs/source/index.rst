========================================
Repository Service for TUF Documentation
========================================

.. note::

    Repository Service for TUF is a work in progress. As of May 2023 RSTUF is
    considered **alpha** - use with caution. Check out our `ROADMAP`_ to better
    understand where we are heading next.

.. include:: ../../README.rst
  :end-before: .. readme-design

.. raw:: html

  <div style="position: relative; padding-bottom: 56.25%; height: 0; margin-bottom: 2em; overflow: hidden; max-width: 100%; height: auto;">
      <iframe src="https://www.youtube.com/embed/mZX16o3E384" frameborder="0" allowfullscreen style="position: absolute; top: 0; left: 0; width: 100%; height: 100%;"></iframe>
  </div>

To fully achieve the client's security, the client side must implement TUF,
which has low complexity due to powerful TUF client libraries.

Use cases
---------

Some RSTUF use cases examples include but are not limited to:

* An organization has a live "Software Updater". This "Software Updater" uses
  TUF to download, install and update software artifacts.
* An organization distributes documents. The reader uses TUF to fetch
  documents submitted by a trusted source.
* An organization owns a private container image registry and uses TUF in the
  CI/CD to deploy computing trusted images at the edge .
* An organization with many Operational Technology (OT) devices in different
  plants uses TUF clients to fetch firmware, software, and projects from a
  distributed artifact repository.
* Web portal, which use TUF to lists all artifacts from a content repository
  and render as a Web UI, the user to download using the web browser.


What is TUF?
============

  *The Update Framework is a software framework designed to protect mechanisms
  that automatically identify and download updates to software. TUF uses a series
  of roles and keys to provide a means to retain security, even when some keys or
  servers are compromised.* [#]_ TUF_

Design/Solution
===============

.. include:: ../../README.rst
  :start-after: .. readme-design
  :end-before: .. readme-other-solutions-comparison

Background and motivation
=========================

`TUF`_ provides a flexible framework and specification that developers can
adopt and an excellent Python Library (`python-tuf`_) that provides two APIs
for low-level Metadata management and client implementation.

Implementing `TUF`_ requires sufficient knowledge of `TUF`_ to design how to
integrate the framework into your repository and hours of engineering work to
implement.

RSTUF was born as a consequence of working on implementing `PEP 458
<https://peps.python.org/pep-0458/>`_ in the `Warehouse`_ project,
*which powers the* [#]_ `Python Package Index (PyPI) <https://pypi.org>`_.

Due to our experience with the complexity and fragility of deep integration
into an intricate platform, we began designing how to implement a flexible,
reusable TUF platform to integrate into different flows and infrastructures.

Repository Service for TUF aims to be an easy-to-use tool for Developers,
DevOps, and DevOpsSec teams working on the delivery process.


.. _TUF: https://theupdateframework.io
.. _python-tuf: https://pypi.org/project/tuf/


Documentation List
==================

.. toctree::
   :maxdepth: 1

   guide/index
   devel/index


.. _TUF: https://theupdateframework.io
.. _python-tuf: https://pypi.org/project/tuf/
.. _ROADMAP: devel/roadmap.html
.. _Redis: https://redis.io
.. _Warehouse: https://github.com/pypi/warehouse/#warehouse

.. [#] `Wikipedia <https://en.wikipedia.org/wiki/The_Update_Framework>`_
.. [#] Warehouse_
