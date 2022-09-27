
Goal: Experimental version
==========================

Status: Work in Progress

Not for a Production Deploy.
This release is for PoV/PoC of the project.

Features:

- [x] Authentication using Token
- [x] Authorization defined by Scope
- [x] Bootstrap the Kaprien Service (Initial TUF Metadata)
- [x] Storage Service: Local file system
- [x] Key Vault Service: Local file system
- [x] Add targets
- [x] Delete targets
- [x] Generate Token
- [x] Retrieves the Kaprien Server settings
- [x] Automatically version Bump Snapshot Metadata
- [x] Automatically version Bump Timestamp Metadata
- [x] Automatically version Bump hash-bins Metadata
- [ ] Release CI/CD in all components (`Issue #25 <https://github.com/kaprien/kaprien/issues/25>`_)
- [ ] Old Metadata retention (`Issue #29 <https://github.com/kaprien/kaprien/issues/29>`_)

Components Milestones:

- kaprien-rest-api (v0.0.1aX): https://github.com/kaprien/kaprien-rest-api/milestone/2
- kaprien-repo-worker (v0.0.1aX): https://github.com/kaprien/kaprien-repo-worker/milestone/2
- kaprien-cli (v0.0.1aX): https://github.com/kaprien/kaprien-cli/milestone/2


Goal: Minimum Working Version
=============================

Status: Planning

Not for a Production Deploy.
This realease is to evaluate the features and functionality.

- [ ] Token revocation (`Issue #30 <https://github.com/kaprien/kaprien/issues/30>`_)
- [ ] Remove the Targets Key from Ceremony (`Issue #28 <https://github.com/kaprien/kaprien/issues/28>`_)
- [ ] Key(s) Rotation (`Issue #23 <https://github.com/kaprien/kaprien/issues/23>`_)
- [x] Implement HTTPS for the Rest API (`Issue #6 <https://github.com/kaprien/kaprien/issues/6>`_)
- [ ] Add TLS/SSL for Broker and Result Backend communication (`Issue #6 <https://github.com/kaprien/kaprien/issues/6>`_)
- [ ] Public online documentation (`Issue #22 <https://github.com/kaprien/kaprien/issues/22>`_)

Components Milestones:

- kaprien-rest-api (v0.0.1bX): https://github.com/kaprien/kaprien-rest-api/milestone/3
- kaprien-repo-worker (v0.0.1bX): https://github.com/kaprien/kaprien-repo-worker/milestone/3
- kaprien-cli (v0.0.1bX): https://github.com/kaprien/kaprien-cli/milestone/3


Goal: Minimum Valuable Product
==============================

Status: TBD

First Production Deploy
This release achive the minimum valuable product for users.

- [ ] Support to AWS S3 (Storage) and AWS KMS (Key Vault)

Components Milestones:

- kaprien-rest-api (v0.1.X): https://github.com/kaprien/kaprien-rest-api/milestone/4
- kaprien-repo-worker (v0.1.X): https://github.com/kaprien/kaprien-repo-worker/milestone/4
- kaprien-cli (v0.1.X): https://github.com/kaprien/kaprien-cli/milestone/4
