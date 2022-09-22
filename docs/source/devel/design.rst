
The Kaprien has two main services (``kaprien-rest-api``,
``kaprien-repo-worker``) and one tool (``kaprien-cli``)

.. uml:: ../../diagrams/2_2_kaprien.puml

By design, it helps scalability and reliability for complex and
distributed deployment. As the example below


.. uml:: ../../diagrams/2_3_kaprien.puml


Components/Tools
================

.. note::

    For more detailed component/tool development information, please check its
    :ref:`specific documention <devel/development:Components Repositories>`.

.. toctree::
    :maxdepth: 2

    kaprien-cli_design
    kaprien-rest-api_design
    kaprien-repo-worker_design