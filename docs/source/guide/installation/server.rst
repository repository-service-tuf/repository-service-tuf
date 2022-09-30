===================================
TUF Repository Service Installation
===================================

TUF Repository Service (TRS) is a combination of micro-services:

 - TUF Repository Service API (``tuf-repository-service-api``)
 - TUF Repository Service Worker (``tuf-repository-service-worker``)

Both services require a Broker server, Redis server and a Web server to
publish the signed Repository Metadata.

To manage your TRS deploy, you use TUF Repository Service Command Line
Interface (CLI) ``tuf-repositoru-service-cli`` -- Command: ``trs-cli``

.. toctree::
   :maxdepth: 1

   all_in_one
   custom_installation
