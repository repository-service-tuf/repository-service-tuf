
===================
Development process
===================


This document, specifically the `file ROADMAP.rst
<https://github.com/kaprien/repository-service-tuf/blob/main/ROADMAP.rst>`_, defines the
:ref:`Repository Service for TUF Roadmap <devel/release:Roadmap>`.

Each Roadmap Goal must have a `project in the Repository Service for TUF Organization
<https://github.com/orgs/repository-service-tuf/projects>`_.

The :ref:`devel/release:Roadmap` contains the desired features. Each
feature has an issue open in the `kaprien/repository-service-tuf
<https://github.com/kaprien/repository-service-tuf>`_ (Umbrella repository) issues.

Working on the Features:

- Always design/document the feature in the issue first.
- Use as many as possible diagrams (PlantUML or Mermaid in the issues). ❤️
- Open the related issues for the component(s)

The Component specifies the Milestone (release) that will contain the Roadmap
Goal in the `ROADMAP.rst
<https://github.com/kaprien/repository-service-tuf/blob/main/ROADMAP.rst>`_ (:ref:`also
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


Project organization
====================

The Components have the development instructions.

Components Repositories
-----------------------

    - `Repository Service for TUF REST API <https://github.com/kaprien/repository-service-tuf-api>`_ (``repository-service-tuf-api``)
    - `Repository Service for TUF Worker <https://github.com/kaprien/repository-service-tuf-rworker>`_ (``repository-service-tuf-worker``)
    - `Repository Service for TUF Command Line Interface <https://github.com/kaprien/repository-service-tuf-cli>`_ (``repository-service-tuf-cli``)
