=================
Development Guide
=================

The Kaprien has two main components (``kaprien-rest-api``,
``kaprien-repo-worker``) and one tool (``kaprien-cli``)

.. uml:: ../../diagrams/2_2_kaprien.puml

By design, it helps scalability and reliability for complex and distributed
deployment. As the example below

.. uml:: ../../diagrams/2_3_kaprien.puml


Services high-level design
==========================

.. note::

    For more specific service information, please check its own documention.

.. toctree::
    :maxdepth: 4

    kaprien-cli_design
    kaprien-rest-api_design
    kaprien-repo-worker_design