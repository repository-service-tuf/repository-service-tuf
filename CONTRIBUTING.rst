==========================================
Contributing to Repository Service for TUF
==========================================

We welcome contributions from the community and first want to thank you for
taking the time to contribute!

Please familiarize yourself with the `Code of Conduct`_ before contributing.

Getting help and involved
=========================

.. slack-meetings-mail

Slack channel
-------------

`#repository-service-for-tuf <https://openssf.slack.com/archives/C052QF5CZFH>`_
channel on `OpenSSF Slack <https://openssf.slack.com/>`_.


Meetings
--------

* `RSTUF Community Meetings at OpenSSF Calendar <https://calendar.google.com/calendar/u/0?cid=czYzdm9lZmhwNWk5cGZsdGI1cTY3bmdwZXNAZ3JvdXAuY2FsZW5kYXIuZ29vZ2xlLmNvbQ>`_

  - `Community Meetings <https://docs.google.com/document/d/13a_AtFpPK9WO4PlAN6ciD-G1jiBU3gEDtRD1OUinUFY>`_

  - Sprint Planning Meetings (Every 2 weeks, see the `public calendar <https://calendar.google.com/calendar/u/0?cid=Y19hYWFjYjc2M2NkNTliNWJhOWUyYmY4N2U1MTJhM2Q4ZjEyYjkxNmFmYzdhOWM4YjQxMmZmNjcwZWYzNmFiOTdlQGdyb3VwLmNhbGVuZGFyLmdvb2dsZS5jb20>`_)


RSTUF mailing list
------------------

Join the mail list https://lists.openssf.org/g/RSTUF

email: RSTUF@lists.openssf.org

.. dco

Developer Certificate of Origin (DCO)
=====================================

Before you start working with Repository Service for TUF, please read our
`Developer Certificate of Origin <https://cla.vmware.com/dco>`_.
All contributions to this repository must be signed as described on that page.

To acknowledge the Developer Certificate of Origin (DCO), sign your commits
by appending a ``Signed-off-by:
Your Name <example@domain.com>`` to each git commit message (see `git commit
--signoff <https://git-scm.com/docs/git-commit#Documentation/git-commit.txt---signoff>`_).
Your signature certifies that you wrote the patch or have the right to pass it
on as an open-source patch.

Getting started
===============

We welcome many different types of contributions and not all of them need a
Pull Request. Contributions may include:

* New features and proposals
* Documentation
* Bug fixes
* Issue Triage
* Answering questions and giving feedback
* Helping to onboard new contributors
* Other related activities


The Repository Service for TUF (RSTUF) has multiple components to which you can
contribute: CLI, API, and Worker.


Getting the source code
-----------------------

Fork the repository
^^^^^^^^^^^^^^^^^^^

Choose the component you want to contribute to and follow the instructions
below to get the source code.

.. collapse:: Repository Service for TUF CLI (CLI)

    `Fork <https://docs.github.com/en/get-started/quickstart/fork-a-repo>`_ the
    repository on `GitHub <https://github.com/repository-service-tuf/repository-service-tuf-cli>`_ and
    `clone <https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository>`_
    it to your local machine:

    .. code-block:: console

        git clone git@github.com:YOUR-USERNAME/repository-service-tuf-cli.git
        cd repository-service-tuf-cli

.. collapse:: Repository Service for TUF API (API)

    `Fork <https://docs.github.com/en/get-started/quickstart/fork-a-repo>`_ the
    repository on `GitHub <https://github.com/repository-service-tuf/repository-service-tuf-api>`_ and
    `clone <https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository>`_
    it to your local machine:

    .. code-block:: console

        git clone git@github.com:YOUR-USERNAME/repository-service-tuf-api.git
        cd repository-service-tuf-api


.. collapse:: Repository Service for TUF Worker (Worker)

    `Fork <https://docs.github.com/en/get-started/quickstart/fork-a-repo>`_ the
    repository on `GitHub <https://github.com/repository-service-tuf/repository-service-tuf-cli>`_ and
    `clone <https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository>`_
    it to your local machine:

    .. code-block:: console

        git clone git@github.com:YOUR-USERNAME/repository-service-tuf-worker.git
        cd repository-service-tuf-worker      

|

Add a git remote
^^^^^^^^^^^^^^^^

Add a `remote
<https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/configuring-a-remote-for-a-fork>`_ and
regularly `sync <https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/syncing-a-fork>`_ to make sure
you stay up-to-date with our repository:

Choose the component to get the instructions

.. collapse:: Repository Service for TUF CLI (CLI)

    .. code-block:: console

        git remote add upstream https://github.com/repository-service-tuf/repository-service-tuf-cli
        git checkout main
        git fetch upstream
        git merge upstream/main

.. collapse:: Repository Service for TUF API (API)

    .. code-block:: console

        git remote add upstream https://github.com/repository-service-tuf/repository-service-tuf-api
        git checkout main
        git fetch upstream
        git merge upstream/main

.. collapse:: Repository Service for TUF Worker (Worker)

    .. code-block:: console

        git remote add upstream https://github.com/repository-service-tuf/repository-service-tuf-worker
        git checkout main
        git fetch upstream
        git merge upstream/main

|

Preparing the environment
-------------------------

Create your development environment

Verify that you have Make installed
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

We use Make to run, build, update docs, tests, formatting, etc.
Verify that you have Make installed in your environment.

.. code-block:: console

    make --version

If you do not have ``Make`` installed,
consult your operating system documentation on how to install ``make``.


Docker
^^^^^^

Why Docker?

Docker simplifies development environment set up.

RSTUF uses Docker and `Docker Compose <https://docs.docker.com/compose/>`_
to automate setting up a "batteries included" development environment. The
:file:`Dockerfile` and :file:`docker-compose.yml` files include all the
required steps for installing and configuring all the required external
services of the development environment.


Installing Docker
~~~~~~~~~~~~~~~~~

* Install `Docker Engine <https://docs.docker.com/engine/installation/>`_

The best experience for building RSTUF on Windows 10 is to use the
`Windows Subsystem for Linux`_ (WSL) in combination with both
`Docker for Windows`_ and `Docker for Linux`_. Follow the instructions
for both platforms.

.. _Docker for Mac: https://docs.docker.com/engine/installation/mac/
.. _Docker for Windows: https://docs.docker.com/engine/installation/windows/
.. _Docker for Linux: https://docs.docker.com/engine/installation/linux/
.. _Windows Subsystem for Linux: https://docs.microsoft.com/windows/wsl/


Verifying Docker installation
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Check that Docker is installed: ``docker -v``


Install Docker Compose
~~~~~~~~~~~~~~~~~~~~~~

Install Docker Compose using the Docker-provided
`installation instructions <https://docs.docker.com/compose/install/>`_.

.. note::
   Docker Compose will be installed by `Docker for Mac`_ and
   `Docker for Windows`_ automatically.


Verifying Docker Compose installation
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Check that Docker Compose is installed: ``docker compose version``


Python and Pipenv
^^^^^^^^^^^^^^^^^

Make sure you have Python installed, we recommend the latest version of Python 3.x.

https://www.python.org/downloads/

Install Pipenv
~~~~~~~~~~~~~~

Pipenv is a tool that automatically creates and manages a virtual environment
and it is used by the RSTUF project to manage dependencies.

After installing Python, install the pipenv tool:

.. code:: shell

    $ pip install pipenv


Create a virtual environment for this project:

.. code:: shell

    $ pipenv shell


Install the requirements from the Pipfile.

The flag -d will install the development requirements:

.. code:: shell

    $ pipenv install -d

Development
------------

.. note::
   RSTUF development can be done using Makefile scripts which
   execute all developer actions.
   
   The Makefile contains common commands to run the development environment.
   You can run ``make help`` to see all the available commands.

Here are some of the most common commands:

Running the development environment
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To run the development environment, use the following command:

.. code:: shell

    $ make run-dev

This will start the development environment with all the required services.
All changes done in the code will be reflected in the development environment.

- RSTUF API will be available at: http://localhost
- The TUF Metadata will be available at: http://localhost:8080

The logs will be available in the terminal where you started the development
environment.

You can stop the development environment with ``CTRL + C`` or stop it in 
another terminal with:

.. code:: shell

    $ make stop

To clean up the development environment, use the following command:

.. code:: shell

    $ make clean


Running checks with pre-commit
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The pre-commit tool is installed as part of the development requirements.

To automatically run checks before you commit your changes you should run:

.. code:: shell

    $ make precommit

This will install the git hook scripts for the first time, and run the
pre-commit tool.
Now ``pre-commit`` will run automatically on ``git commit``.

Running tests
^^^^^^^^^^^^^
To run the tests, use the following command:

To run the Functional Tests:        
1. Make sure you have a development environment running (``make run-dev``).    
2. Use one of the following command:

.. code:: shell

    $ make functional-tests


The following parameters can be passed to the command:          

- ``CLI_VERSION``: to use a specific version of the CLI.        
- ``SLOW``: to run the performance tests                  

.. code:: shell
    $ make functional-tests CLI_VERSION=v0.17.1b1 SLOW=yes

How to add new dependency
^^^^^^^^^^^^^^^^^^^^^^^^^

Install the new package as a dependency.

If you are adding a new package that is only needed for development, use the
``-d`` flag to install it as a development dependency.

.. code:: shell

    $ pipenv install -d <package>

If you are adding a new package that is needed for the application to run,
use the following command without the ``-d`` flag to install it as a runtime dependency.

.. code:: shell

    $ pipenv install <package>


Build local documentation
^^^^^^^^^^^^^^^^^^^^^^^^^

.. code:: shell

    $ make docs


Reformat the code (linters)
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code:: shell

    $ make reformat


Submitting changes
==================

1. Create a new branch

.. code:: shell

    $ git checkout -b <new_change_name>

2. Perform the changes and commit them

.. code:: shell

    $ git add <files_you_changed>
    $ git commit -m "commit messaage"

3. Push your changes to your fork

.. code:: shell

    $ git push origin <your_new_branch>

3. Run local linters, tests, etc
4. Create a local commit with a `good title and description
   <https://blogs.vmware.com/opensource/2021/04/14/improve-your-git-commits-in-two-easy-steps/>`_

.. code:: shell

    $ git commit -a -s

4. Open a Pull Request

   Go to the `GitHub repository <https://github.com/repository-service-tuf/repository-service-tuf>`_ and create a new Pull Request from your branch.

Check the specific repository CONTRIBUTING documentation for more specific
details:

* `Umbrella Repository Service for TUF <https://github.com/repository-service-tuf/repository-service-tuf/blob/main/CONTRIBUTING.rst>`_
* `Repository Service for TUF API <https://github.com/repository-service-tuf/repository-service-tuf-api/blob/main/CONTRIBUTING.rst>`_
* `Repository Service for TUF Worker <https://github.com/repository-service-tuf/repository-service-tuf-worker/blob/main/CONTRIBUTING.rst>`_
* `Repository Service for TUF Command Line Interface (CLI) <https://github.com/repository-service-tuf/repository-service-tuf-cli/blob/main/CONTRIBUTING.rst>`_

.. rstuf-contributing-links

.. _Code of Conduct: CODE_OF_CONDUCT.rst