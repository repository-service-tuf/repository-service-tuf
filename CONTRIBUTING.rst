==========================================
Contributing to Repository Service for TUF
==========================================

We welcome contributions from the community and first want to thank you for
taking the time to contribute!

Please familiarize yourself with the `Code of Conduct`_
before contributing.

DCO
===

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
contribute.

Check the specific repository CONTRIBUTING documentation for more specific
details:

* `Umbrella Repository Service for TUF <https://github.com/kaprien/repository-service-tuf/blob/main/CONTRIBUTING.rst>`_
* `Repository Service for TUF API <https://github.com/kaprien/repository-service-tuf-api/blob/main/CONTRIBUTING.rst>`_
* `Repository Service for TUF Worker <https://github.com/kaprien/repository-service-tuf-worker/blob/main/CONTRIBUTING.rst>`_
* `Repository Service for TUF Command Line Interface (CLI) <https://github.com/kaprien/repository-service-tuf-cli/blob/main/CONTRIBUTING.rst>`_

.. rstuf-contributing-links

.. _Code of Conduct: CODE_OF_CONDUCT.rst

Getting the source code
=======================

`Fork <https://docs.github.com/en/get-started/quickstart/fork-a-repo>`_ the
repository on `GitHub <https://github.com/kaprien/repository-service-tuf>`_ and
`clone <https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository>`_
it to your local machine:

.. code-block:: console

    git clone git@github.com:YOUR-USERNAME/repository-service-tuf.git

Add a `remote
<https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/configuring-a-remote-for-a-fork>`_ and
regularly `sync <https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/syncing-a-fork>`_ to make sure
you stay up-to-date with our repository:

.. code-block:: console

    git remote add upstream https://github.com/kaprien/repository-service-tuf
    git checkout main
    git fetch upstream
    git merge upstream/main


Preparing the environment
=========================

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

Submitting changes
==================

1. Create a new branch

.. code:: shell

    $ git checkout -b <new_change_name>

2. Perform the changes
3. Run local linters, tests, etc
4. Create a local commit with a `good title and description
   <https://blogs.vmware.com/opensource/2021/04/14/improve-your-git-commits-in-two-easy-steps/>`_

.. code:: shell

    $ git commit -a -s

1. Push to Git

.. code:: shell

    $ git push

How to add new requirements
===========================

Install the requirements package.

The flag -d will install the development requirements.

.. code:: shell

    $ pipenv install -d <package>
    $ pipenv install <package>


Update all project requirements
-------------------------------

.. code:: shell

    $ make requirements

Build local documentation
=========================

.. code:: shell

    $ make docs

Run linters
===========

.. code:: shell

    $ make lint

Run local functional tests
==========================

You must to have the Repository Service for TUF running local

.. code:: shell

    $ make functional-tests
