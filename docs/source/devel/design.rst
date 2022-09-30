
The TUF Repository Service has two main services (``trs-rest-api``,
``trs-repo-worker``) and one tool (``trs-cli``)

.. uml:: ../../diagrams/2_2_trs.puml

By design, it helps scalability and reliability for complex and
distributed deployment. As the example below


.. uml:: ../../diagrams/2_3_trs.puml


Components/Tools
================

.. note::

    For more detailed component/tool development information, please check its
    :ref:`specific documention <devel/development:Components Repositories>`.

.. toctree::
    :maxdepth: 2

    tuf-repository-service-cli_design
    tuf-repository-service-api_design
    tuf-repository-service-worker_design