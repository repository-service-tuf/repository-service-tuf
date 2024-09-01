
Goal: Experimental version
==========================

Status: Done

Not for a Production Deploy.
This release is for PoV/PoC of the project.

Features:

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
- [x] Release CI/CD in all components (`Issue #25 <https://github.com/repository-service-tuf/repository-service-tuf/issues/25>`_)

Components Milestones:

- `repository-service-tuf-api v0.0.1aX <https://github.com/repository-service-tuf/repository-service-tuf-api/milestone/2>`_
- `repository-service-tuf-worker v0.0.1aX <https://github.com/repository-service-tuf/repository-service-tuf-worker/milestone/2>`_
- `repository-service-tuf-cli v0.0.1aX <https://github.com/repository-service-tuf/repository-service-tuf-cli/milestone/2>`_


Goal: Minimum Working Version
=============================

Status: Done

Not for a Production Deploy.
This release is to evaluate the features and functionality.


- [x] Public online documentation (`Issue #22 <https://github.com/repository-service-tuf/repository-service-tuf/issues/22>`_)
- [x] Implement HTTPS for the Rest API (`Issue #6 <https://github.com/repository-service-tuf/repository-service-tuf/issues/6>`_)
- [x] Data load for migrations (`Issue #188 <https://github.com/repository-service-tuf/repository-service-tuf/issues/188>`_)
- [x] Remove the BIN Keys from Ceremony/Bootstrap Process [Roles simplification] (`Issue #28 <https://github.com/repository-service-tuf/repository-service-tuf/issues/28>`_)
- [x] Remove from the bootstrap the online keys [Roles simplification] (`Issue #207 <https://github.com/repository-service-tuf/repository-service-tuf/issues/207>`_)
- [x] Simplify the metadata bootstrap process [Roles simplification] (`Issue #208 <https://github.com/repository-service-tuf/repository-service-tuf/issues/208>`_)
- [x] Option to Disable the API Authentication/Authorization (`Issue #41 <https://github.com/repository-service-tuf/repository-service-tuf/issues/41>`_)
- [x] Key(s) Rotation (`Issue #23 <https://github.com/repository-service-tuf/repository-service-tuf/issues/23>`_)

`Minimum Working Version (MWV) Board <https://github.com/orgs/repository-service-tuf/projects/2>`_.

Components Milestones:

- `repository-service-tuf-api v0.4.0b1 <https://github.com/repository-service-tuf/repository-service-tuf-api/milestone/3>`_
- `repository-service-tuf-worker v0.5.0b1 <https://github.com/repository-service-tuf/repository-service-tuf-worker/milestone/3>`_
- `repository-service-tuf-cli v0.4.0b1 <https://github.com/repository-service-tuf/repository-service-tuf-cli/milestone/3>`_


Goal: Minimum Valuable Project
==============================

Status: September 2024

First Production Deploy
This release achieves the minimum valuable project for users.

- [x] Deployment Design Document (`Issue #227 <https://github.com/repository-service-tuf/repository-service-tuf/issues/227>`_)
- [x] Support to AWS S3 (Storage) (`Issue # <https://github.com/repository-service-tuf/repository-service-tuf/issues/24>`)
- [x] Distributed asynchronous threshold signing (`Issue #327 <https://github.com/repository-service-tuf/repository-service-tuf/issues/327>`_)
- [x] Support to multiple Key Vaults for online Key during Ceremony/Metadata Update
      - [x] AWS KMS (`Issue #24 <https://github.com/repository-service-tuf/repository-service-tuf/issues/24>`_)
      - [x] Support of HashiCorp Vault (`Issue #509 <https://github.com/repository-service-tuf/repository-service-tuf/issues/509>`_)
- [ ] Support for Root Signing (Ceremony, Metadata Update and Sign)
      - [ ] HSM (Yubikey) (`Issue #351[cli] <https://github.com/repository-service-tuf/repository-service-tuf-cli/issues/351>`_)
      - [x] SigStore (`Issue #657[cli] <https://github.com/repository-service-tuf/repository-service-tuf-cli/issues/657>`_)
- [ ] Improve new admin CLI UI & UX. (`Issue #532[cli] <https://github.com/repository-service-tuf/repository-service-tuf-cli/issues/532>`_)
- [ ] Create/Remove custom delegate Target Roles (`Issue #354 <https://github.com/repository-service-tuf/repository-service-tuf/issues/354>`_)
- [ ] Security Audit on RSTUF Project  (`Issue #246 <https://github.com/repository-service-tuf/repository-service-tuf/issues/546>`_)

Components Milestones:

- `repository-service-tuf-api v1.0.0rc1 <https://github.com/repository-service-tuf/repository-service-tuf-api/milestone/4>`_
- `repository-service-tuf-worker v1.0.0rc1 <https://github.com/repository-service-tuf/repository-service-tuf-worker/milestone/4>`_
- `repository-service-tuf-cli v1.0.0rc1 <https://github.com/repository-service-tuf/repository-service-tuf-cli/milestone/4>`_


Goal: End-to-End Signing
========================

Status: TBD

Implement End-to-end signing of packages. Developers or Release Manager can
sign the artifacts. See `PEP 480 <https://peps.python.org/pep-0480/>`_ for more
details.

- repository-service-tuf-api vT.B.D
- repository-service-tuf-worker vT.B.D
- repository-service-tuf-cli vT.B.D
