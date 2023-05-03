##########
Networking
##########

This diagram represents the communication between the
:ref:`guide/general/introduction:RSTUF Components`, including
the :ref:`guide/deployment/planning/deployment:Required Infrastructure Services`.

.. image:: /_static/rstuf_networking.png

* The HTTP requests goes to the RSTUF API.

* RSTUF API communicates with

    - Broker/message queue (Redis or RabbitMQ)
    - Redis

* RSTUF Worker communicates with

    - Broker/message queue (Redis or RabbitMQ)
    - Redis
    - PostgreSQL
