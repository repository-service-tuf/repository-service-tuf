
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

Components Milestones:

- kaprien-rest-api: https://github.com/kaprien/kaprien-rest-api/milestone/2
- kaprien-repo-worker:
- kaprien-cli:


Goal: Minimum working version
=============================

Status: Planning

Not for a Productione Deploy.
This realease is to evaluate the features and functionality.

- [ ] Token revocation (`Issue #30 <https://github.com/kaprien/kaprien/issues/30>`_)
- [ ] Key(s) Rotation (`Issue #15 <https://github.com/kaprien/kaprien/issues/15>`_)
- [x] Implement HTTPS for the Rest API (`Issue #6 <https://github.com/kaprien/kaprien/issues/6>`_)
- [ ] Add TLS/SSL for Broker and Result Backend communication (`Issue #6 <https://github.com/kaprien/kaprien/issues/6>`_)
