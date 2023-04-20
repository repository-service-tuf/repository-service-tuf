
===================
Development process
===================


This document, specifically the `file ROADMAP.rst
<https://github.com/repository-service-tuf/repository-service-tuf/blob/main/ROADMAP.rst>`_, defines the
:ref:`Repository Service for TUF Roadmap <devel/release:Roadmap>`.

Each Roadmap Goal must have a `project in the Repository Service for TUF Organization
<https://github.com/orgs/vmware/projects>`_.

The :ref:`devel/release:Roadmap` contains the desired Repository Service for
TUF (RSTUF) features. Each feature has an issue open in the
`vmware/repository-service-tuf <https://github.com/repository-service-tuf/repository-service-tuf>`_
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

.. uml::

    @startuml
    allowmixing
    package "Organization" {

        object "Projects" as projects #Lime{
                Goal 01
                Goal 02
        }

        package "repository-service-tuf" {
            json ROADMAP.rst {
                "Goal 01": {
                    "features": ["Feature A", "Feature B"],
                    "milestones": {
                        "repository-service-tuf-api": "v1.2.0",
                        "repository-service-tuf-worker": "v1.1.0",
                        "repository-service-tuf-cli": "v1.4.0"
                    }
                },
                "Goal 02": {
                    "features": ["Feature C", "Feature D"],
                    "milestones": {
                        "repository-service-tuf-api": "v1.3.0",
                        "repository-service-tuf-worker": "v1.1.0",
                        "repository-service-tuf-cli": "v2.0.0"
                    }
                }
            }

            object Issues #RoyalBlue {
                Feature A
                Feature B
                Feature C
                Feature D
            }

        }

        package "repository-service-tuf-api" {
            json "Issues" as api_issues {
                "issue#12": {
                    "milestone": "v1.1.3",
                    "projects": "Goal 01"
                },
                "issue#14": {
                    "milestone": "v1.2.2",
                    "projects": null
                },
                "issue#46": {
                    "milestone": "v1.2.0",
                    "projects": "Goal 02"
                },
                "issue#30": {
                    "milestone": "v1.2.0",
                    "projects": "Goal 01"
                }
            }
            object "Milestones" as api_milestones {
                v1.1.3
                v1.2.0
                v1.2.1
            }

            api_issues -> api_milestones
        }
        package "repository-service-tuf-worker" {
            json "Issues" as repo_issues {
                "issue#31": {
                    "milestone": "v1.1.0",
                    "projects": ["Goal 01", "Goal 02"]
                },
                "issue#32": {
                    "milestone": "v1.1.0",
                    "projects": ["Goal 01", "Goal 02"]
                },
                "issue#55": {
                    "milestone": "v1.2.0",
                    "projects": null
                },
                "issue#42": {
                    "milestone": "v1.2.0",
                    "projects": null
                }
            }
            object "Milestones" as repo_milestones {
                v1.1.0
                v1.0.9
                v1.2.0
            }
            repo_issues -> repo_milestones
        }
        ROADMAP.rst --> Issues
        projects --> ROADMAP.rst
        Issues --D-> api_issues
        Issues --D-> repo_issues
        api_milestones --[#grey,dotted]-> ROADMAP.rst
        repo_milestones --[#grey,dotted]-> ROADMAP.rst
    }

    @enduml

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


