
Goal: Experimental version
==========================

Status: Work in Progress

Not for a Production Deploy.
This release is for PoV/PoC of the project.

Features:

- [x] Authentication using Token
- [x] Authorization defined by Scope
- [x] Bootstrap the TUF Repository Service (Initial TUF Metadata)
- [x] Storage Service: Local file system
- [x] Key Vault Service: Local file system
- [x] Add targets
- [x] Delete targets
- [x] Generate Token
- [x] Retrieves the TUF Repository Service settings
- [x] Automatically version Bump Snapshot Metadata
- [x] Automatically version Bump Timestamp Metadata
- [x] Automatically version Bump hash-bins Metadata
- [ ] Release CI/CD in all components (`Issue #25 <https://github.com/kaprien/tuf-repository-worker/issues/25>`_)
- [ ] Old Metadata retention (`Issue #29 <https://github.com/kaprien/tuf-repository-worker/issues/29>`_)

Components Milestones:

- `tuf-repository-service-api v0.0.1aX <https://github.com/kaprien/tuf-repository-service-api/milestone/2>`_
- `tuf-repository-service-worker v0.0.1aX <https://github.com/kaprien/tuf-repository-service-worker/milestone/2>`_
- `tuf-repository-service-cli v0.0.1aX <https://github.com/kaprien/tuf-repository-service-cli/milestone/2>`_


Goal: Minimum Working Version
=============================

Status: Planning

Not for a Production Deploy.
This realease is to evaluate the features and functionality.

- [ ] Token revocation (`Issue #30 <https://github.com/kaprien/tuf-repository-worker/issues/30>`_)
- [ ] Remove the Targets Key from Ceremony (`Issue #28 <https://github.com/kaprien/tuf-repository-worker/issues/28>`_)
- [ ] Key(s) Rotation (`Issue #23 <https://github.com/kaprien/tuf-repository-worker/issues/23>`_)
- [x] Implement HTTPS for the Rest API (`Issue #6 <https://github.com/kaprien/tuf-repository-worker/issues/6>`_)
- [ ] Add TLS/SSL for Broker and Result Backend communication (`Issue #6 <https://github.com/kaprien/tuf-repository-worker/issues/6>`_)
- [ ] Public online documentation (`Issue #22 <https://github.com/kaprien/tuf-repository-worker/issues/22>`_)

Components Milestones:

- `tuf-repository-service-api v0.0.1bX <https://github.com/kaprien/tuf-repository-service-api/milestone/3>`_
- `tuf-repository-service-worker v0.0.1bX <https://github.com/kaprien/tuf-repository-service-worker/milestone/3>`_
- `tuf-repository-service-cli v0.0.1bX <https://github.com/kaprien/tuf-repository-service-cli/milestone/3>`_


Goal: Minimum Valuable Product
==============================

Status: TBD

First Production Deploy
This release achive the minimum valuable product for users.

- [ ] Support to AWS S3 (Storage) and AWS KMS (Key Vault)

Components Milestones:

- `tuf-repository-service-api v0.1.X <https://github.com/kaprien/tuf-repository-service-api/milestone/4>`_
- `tuf-repository-service-worker v0.1.X <https://github.com/kaprien/tuf-repository-service-worker/milestone/4>`_
- `tuf-repository-service-cli v0.1.X <https://github.com/kaprien/tuf-repository-service-cli/milestone/4>`_
