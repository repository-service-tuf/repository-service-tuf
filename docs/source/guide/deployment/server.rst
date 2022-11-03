==========
Deployment
==========

Repository Service for TUF (RSTUF) is a combination of micro-services:

 - Repository Service for TUF API (``repository-service-tuf-api``)
 - Repository Service for TUF Worker (``repository-service-tuf-worker``)

Both services require a Broker server, Redis server and a Web server to
publish the signed Repository Metadata.

To manage your RSTUF deploy, you use Repository Service for TUF Command Line
Interface (CLI) ``tuf-repositoru-service-cli`` -- Command: ``rstuf-cli``

.. toctree::
   :maxdepth: 1

   all_in_one
   custom_deployment
