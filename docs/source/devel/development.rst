
===================
Development process
===================


This document, specifically the `file ROADMAP.rst
<https://github.com/repository-service-tuf/repository-service-tuf/blob/main/ROADMAP.rst>`_, defines the
:ref:`Repository Service for TUF Roadmap <devel/release:Roadmap>`.

Each Roadmap Goal must have a `project in the Repository Service for TUF Organization
<https://github.com/orgs/repository-service-tuf/projects>`_.

The :ref:`devel/release:Roadmap` contains the desired Repository Service for
TUF (RSTUF) features. Each feature has an issue open in the
`repository-service-tuf/repository-service-tuf <https://github.com/repository-service-tuf/repository-service-tuf>`_
(Umbrella repository) issues.

The Component specifies the Milestone (release) that will contain the Roadmap
Goal in the `ROADMAP.rst
<https://github.com/repository-service-tuf/repository-service-tuf/blob/main/ROADMAP.rst>`_ (:ref:`also
visible below <devel/release:Roadmap>`).

It allows the Component Maintainers to combine Repository Service for TUF Features and internal
Component projects during a release.

Working on the Component Issues:
  - If the issue is related or has an impact on the Roadmap Goal, select the
    Project Goal it to the Milestone.

.. image:: /_static/development_process.png


Proposing new features
======================

In RSTUF we have two types of Features.

Component-only feature
----------------------

The component-only features are related and internal to a component (i.e.,
Repository Service for TUF API or Repository Service for TUF Worker). These
features don’t impact the entire RSTUF platform, such as performance,
breaking/improving API contracts, user usage/deployment, etc.

We recommend for this type of feature to open a new issue in the :ref:`specific
component <devel/development:Components Repositories>`.

RSTUF Feature
-------------

The RSTUF feature is a large-scope feature that impacts the entire RSTUF
platform and requires a more structured proposal to apply/implement
cross-components or even user usage change.

We recommend for these changes the following:

* Always design/document the feature in a `new issue
  <https://github.com/repository-service-tuf/repository-service-tuf/issues/new?assignees=&labels=feature&template=feature.yml&title=Feature%3A+>`_.

  - Use as many diagrams as possible (PlantUML or Mermaid in the issues). ❤️

* After discussing and receiving enough feedback, propose a :ref:`BDD Feature file
  <devel/development:Functional Tests using Behavior Development Driven (BDD)>`
  (ask for a feature branch).
* Once the BDD Feature file is approved and merged to a feature branch, open
  the related issues for the component(s)

Testings
========

RSTUF uses two test types approach for different levels of tests as RSTUF has
multiple components.

Unit tests
----------

We do unit tests (UT)  in each component. The intention is to test the
low-level components, such as individual methods and functions of the classes.

We use the `pytest <https://docs.pytest.org/>`_ as a standard framework. Also,
to avoid mixed boundaries between RSTUF code and libraries or systems, we use
the mocking technique in the UT. For mocking, we use ``monkeypatch`` from
pytest and `pretend <https://github.com/alex/pretend>`_ to implement the
stubbing technic.

More details will be in each :ref:`specific
component <devel/development:Components Repositories>`.

Functional Tests using Behavior Development Driven (BDD)
--------------------------------------------------------

BDD Feature file
................

For RSTUF Features level, we write the `Gherkin
<https://cucumber.io/docs/gherkin/reference/>`_ feature file in the
`test features
<https://github.com/repository-service-tuf/repository-service-tuf/tree/main/tests/features>`_.

The goal is to describe the Scenarios and Behavior for our feature clearly.
We try to have clear requirements for implementing, maintaining, and changing
the existing features.
We also use it as the starting point for :ref:`proposing RSTUF new Features
<devel/development:RSTUF Feature>`. From that, we can design, start planning
issues, etc.

A new BDD Feature file for an unexisting RSTUF Feature is always merged into a
feature branch. After discussing the new feature request, the feature branch is
created upon request by the maintainers.

Tooling
.......

We use `pytest <https://docs.pytest.org/>`_ and
`pytest-bdd <https://pytest-bdd.readthedocs.io/en/stable/>`_ as the framework.

All BDD tests are in the `Umbrella repository, inside
tests/functional <http://github.com/repository-service-tuf/repository-service-tuf>`_ .

The BDD tests have the workflow also in the `Umbrella repository
<http://github.com/repository-service-tuf/repository-service-tuf>`_ , as a reusable
GitHub Workflow, and it is triggered by other workflows/components i.e.,
before releasing.


Project organization
====================

The project uses the microservices approach.
Each RSTUF components have its own development instructions.

Components Repositories
-----------------------

    - `Repository Service for TUF REST API <https://github.com/repository-service-tuf/repository-service-tuf-api>`_ (``repository-service-tuf-api``)
    - `Repository Service for TUF Worker <https://github.com/repository-service-tuf/repository-service-tuf-rworker>`_ (``repository-service-tuf-worker``)
    - `Repository Service for TUF Command Line Interface <https://github.com/repository-service-tuf/repository-service-tuf-cli>`_ (``repository-service-tuf-cli``)


