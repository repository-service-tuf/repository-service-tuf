
Goal: Experimental version
==========================

Status: Done

Not for a Production Deploy.
This release is for PoV/PoC of the project.

Features:

- [x] Authentication using Token
- [x] Authorization defined by Scope
- [x] Bootstrap the Repository Service for TUF (Initial TUF Metadata)
- [x] Storage Service: Local file system
- [x] Key Vault Service: Local file system
- [x] Add targets
- [x] Delete targets
- [x] Generate Token
- [x] Retrieves the Repository Service for TUF settings
- [x] Automatically version Bump Snapshot Metadata
- [x] Automatically version Bump Timestamp Metadata
- [x] Automatically version Bump hash-bins Metadata
- [x] Release CI/CD in all components (`Issue #25 <https://github.com/vmware/repository-service-tuf/issues/25>`_)

Components Milestones:

- `repository-service-tuf-api v0.0.1aX <https://github.com/vmware/repository-service-tuf-api/milestone/2>`_
- `repository-service-tuf-worker v0.0.1aX <https://github.com/vmware/repository-service-tuf-worker/milestone/2>`_
- `repository-service-tuf-cli v0.0.1aX <https://github.com/vmware/repository-service-tuf-cli/milestone/2>`_


Goal: Minimum Working Version
=============================

Status: Work In Progress

Not for a Production Deploy.
This release is to evaluate the features and functionality.


- [x] Public online documentation (`Issue #22 <https://github.com/vmware/repository-service-tuf/issues/22>`_)
- [x] Implement HTTPS for the Rest API (`Issue #6 <https://github.com/vmware/repository-service-tuf/issues/6>`_)
- [x] Data load for migrations (`Issue #188 <https://github.com/vmware/repository-service-tuf/issues/188>`_)
- [x] Remove the BIN Keys from Ceremony/Bootstrap Process [Roles simplification] (`Issue #28 <https://github.com/vmware/repository-service-tuf/issues/28>`_)
- [ ] Remove from the bootstrap the online keys [Roles simplification] (`Issue #207 <https://github.com/vmware/repository-service-tuf/issues/207>`_)
- [ ] Simplify the metadata bootstrap process [Roles simplification] (`Issue #208 <https://github.com/vmware/repository-service-tuf/issues/208>`_)
- [ ] Key(s) Rotation (`Issue #23 <https://github.com/vmware/repository-service-tuf/issues/23>`_)
- [ ] Option to Disable the API Authentication/Authorization (`Issue #41 <https://github.com/vmware/repository-service-tuf/issues/41>`_)

`Minimum Working Version (MWV) Board <https://github.com/orgs/vmware/projects/13/views/1>`_.

Components Milestones:

- `repository-service-tuf-api v1.0.0bX <https://github.com/vmware/repository-service-tuf-api/milestone/3>`_
- `repository-service-tuf-worker v1.0.0bX <https://github.com/vmware/repository-service-tuf-worker/milestone/3>`_
- `repository-service-tuf-cli v1.0.0bX <https://github.com/vmware/repository-service-tuf-cli/milestone/3>`_


Goal: Minimum Valuable Product
==============================

Status: TBD

First Production Deploy
This release achive the minimum valuable product for users.

- [ ] Old Metadata retention (`Issue #29 <https://github.com/vmware/repository-service-tuf/issues/29>`_)
- [ ] Deployment Design Document (`Issue #227 <https://github.com/vmware/repository-service-tuf/issues/227>`_)
- [ ] Support to AWS S3 (Storage) and AWS KMS (Key Vault) (`Issue #24 <https://github.com/vmware/repository-service-tuf/issues/24>`_)
- [ ] Token revocation (`Issue #30 <https://github.com/vmware/repository-service-tuf/issues/30>`_)

Components Milestones:

- `repository-service-tuf-api v1.0.X <https://github.com/vmware/repository-service-tuf-api/milestone/4>`_
- `repository-service-tuf-worker v1.0.X <https://github.com/vmware/repository-service-tuf-worker/milestone/4>`_
- `repository-service-tuf-cli v1.0.X <https://github.com/vmware/repository-service-tuf-cli/milestone/4>`_


Goal: End-to-End Signing
========================

Status: TBD

Implement End-to-end signing of packages. Developers or Release Manager can
sign the artifacts. See `PEP 480 <https://peps.python.org/pep-0480/>`_ for more
details.

- repository-service-tuf-api vT.B.D
- repository-service-tuf-worker vT.B.D
- repository-service-tuf-cli vT.B.D
