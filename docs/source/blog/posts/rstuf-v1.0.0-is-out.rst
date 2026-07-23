####################
RSTUF v1.0.0 Release
####################

Author: Kairo de Araujo

Last update: 2025-08-29

We are excited to announce the **first stable release of the Repository Service
for TUF (RSTUF) – v1.0.0**. This milestone marks the culmination of years of
development, community feedback, and security assessments, making RSTUF ready
for production use in modern software supply chains.

Key Features
============

This release brings a comprehensive set of features for secure, scalable, and
flexible repository management with:

**Root Metadata Signing**  
RSTUF now supports multiple signing backends for Root metadata, enabling strong
cryptographic assurance and flexibility in deployment:

- PEM files
- YubiKey hardware tokens
- Sigstore

**Online Keys for Automation**  
RSTUF supports automatic signing with online keys stored in:

- AWS/GCP/Azure KMS
- HashiCorp Vault
- Container Secrets

**Targets Metadata**  
You can now create and manage Targets metadata with powerful options:

- **Hash-Bin delegation**: optimized for high-traffic repositories or a large
  number of artifacts, using online keys.
- **Custom Delegations**: ideal for managing multiple sub-projects or splitting
  ownership of specific artifacts. This makes it possible to delegate signing
  responsibilities across teams, environments, or release stages.  
  For example, one team may control *staging* releases, another manages *QA*,
  and a third oversees *production*. Signers can use PEM keys, YubiKey,
  Sigstore, online keys, or even a mix of them to fit their needs.

**Storage Options**  
TUF metadata can be stored either in **container volumes** or **Amazon S3
buckets**, giving you deployment flexibility.

**CLI Tooling**  
A user-friendly CLI is included for managing repositories and using RSTUF
directly from the command line.

**API-First Design**  
With its API, RSTUF is simple to integrate into your **software development
lifecycle (SDLC)** and other automation workflows.

This enables seamless integration into CI/CD pipelines and automated release
processes.

Deployment
==========

To deploy RSTUF, we strongly recommend using our official Helm Charts:  
📦 `Deployment with Helm <https://repository-service-tuf.readthedocs.io/en/stable/guide/deployment/guide/helm.html>`_

For full deployment and usage documentation, visit:  
📖 `RSTUF Documentation <https://repository-service-tuf.readthedocs.io/en/stable/guide/index.html>`_

Future Work
===========

We believe RSTUF v1.0.0 is a strong foundation, but this is just the beginning.  
We are looking forward to hearing from the community about **what features
matter most next**.

Currently, our main focus is extending support for **hash-bin delegations
within Custom Delegations**. This will make it easier to combine scalable
hash-bin structures with fine-grained delegation ownership — a powerful setup
for large-scale artifact repositories with distributed trust models.

Community
=========

RSTUF is a community-driven project, and we’d love for you to get involved:

- Join the discussion on **OpenSSF Slack** in the `#repository-service-tuf` channel
- Participate in our **community meetings**
- Contribute via code, docs, or feedback

👥 `How to get involved <https://repository-service-tuf.readthedocs.io/en/stable/index.html#how-to-get-involved>`_

Thank You
=========

We want to thank all contributors, testers, and community members who helped
bring RSTUF to this first stable release. Your feedback, code, and collaboration
are what made v1.0.0 possible.

This is just the beginning—join us as we continue to make software distribution
more secure, reliable, and transparent with RSTUF.
