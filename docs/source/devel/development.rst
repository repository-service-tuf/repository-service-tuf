
===================
Development process
===================

This document, specifically the `file ROADMAP.rst
<https://github.com/kaprien/tuf-repository-service/blob/main/ROADMAP.rst>`_, defines the
:ref:`TUF Repository Service Roadmap <devel/release:Roadmap>`.

Each Roadmap Goal must have a `project in the TUF Repository Service Organization
<https://github.com/orgs/tuf-repository-service/projects>`_.

The :ref:`devel/release:Roadmap` contains the desired features. Each
feature has an issue open in the `kaprien/tuf-repository-service
<https://github.com/kaprien/tuf-repository-service>`_ (Umbrella repository) issues.

Working on the Features:

- Always design/document the feature in the issue first.
- Use as many as possible diagrams (PlantUML or Mermaid in the issues). ❤️
- Open the related issues for the component(s)

The Component specifies the Milestone (release) that will contain the Roadmap
Goal in the `ROADMAP.rst
<https://github.com/kaprien/tuf-repository-service/blob/main/ROADMAP.rst>`_ (:ref:`also
visible below <devel/release:Roadmap>`).

It allows the Component Maintainers to combine TUF Repository Service Features and internal
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

        package "tuf-repository-service" {
            json ROADMAP.rst {
                "Goal 01": {
                    "features": ["Feature A", "Feature B"],
                    "milestones": {
                        "tuf-repository-service-api": "v1.2.0",
                        "tuf-repository-service-worker": "v1.1.0",
                        "tuf-repository-service-cli": "v1.4.0"
                    }
                },
                "Goal 02": {
                    "features": ["Feature C", "Feature D"],
                    "milestones": {
                        "tuf-repository-service-api": "v1.3.0",
                        "tuf-repository-service-worker": "v1.1.0",
                        "tuf-repository-service-cli": "v2.0.0"
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

        package "tuf-repository-service-api" {
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
        package "tuf-repository-service-worker" {
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

    - `TUF Repository Service REST API <https://github.com/kaprien/tuf-repository-service-api>`_ (``tuf-repository-service-api``)
    - `TUF Repository Service Worker <https://github.com/kaprien/tuf-repository-service-rworker>`_ (``tuf-repository-service-worker``)
    - `TUF Repository Service Command Line Interface <https://github.com/kaprien/tuf-repository-service-cli>`_ (``tuf-repository-service-cli``)
