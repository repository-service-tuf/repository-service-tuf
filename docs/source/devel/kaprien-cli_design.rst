kaprien-cli design
==================

kaprien-cli context level
-------------------------

The ``kaprien-cli``, in the context perspective, is a command line tool. It sends
HTTP requests to ``kaprien-rest-api``.

.. uml:: ../../diagrams/kaprien-cli-C1.puml


kaprien-cli container level
---------------------------

The ``kaprien-cli``, in the container perspective, is a command line tool that
interacts to the ``kaprien-rest-api``.

``kaprien-cli`` writes a settings configuration in the file
``$HOME/.kaprien.ini`` with ``login`` subcommand.

``kaprien-cli`` writes the ``payload.json`` or the specified file with
option ``-f/--file`` with ``ceremony`` subcommand.

``kaprien-cli`` writes also upon request all the metadata files in
``metadata`` folder if used ``-s/--save``with ``ceremony`` subcommand.


.. uml:: ../../diagrams/kaprien-cli-C2.puml
