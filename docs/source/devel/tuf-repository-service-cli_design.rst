Design
======

Context level
-------------

The ``tuf-repository-service``, in the context perspective, is a command line tool. It sends
HTTP requests to ``tuf-repository-service-api``.

.. uml:: ../../diagrams/tuf-repository-service-cli-C1.puml


Container level
---------------

The ``tuf-repository-service``, in the container perspective, is a command line tool that
interacts to the ``tuf-repository-service-api``.

``tuf-repository-service`` writes a settings configuration in the file
``$HOME/.trs.ini`` with ``login`` subcommand.

``tuf-repository-service`` writes the ``payload.json`` or the specified file with
option ``-f/--file`` with ``ceremony`` subcommand.

``tuf-repository-service`` writes also upon request all the metadata files in
``metadata`` folder if used ``-s/--save``with ``ceremony`` subcommand.


.. uml:: ../../diagrams/tuf-repository-service-cli-C2.puml
