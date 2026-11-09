# Security Self-Assessment - Repository Service for TUF (RSTUF)

## 1. Project Overview
Repository Service for TUF (RSTUF) is a set of services and tools designed to simplify the deployment and management of The Update Framework (TUF) for any software repository. It provides a secure, automated metadata management system that follows TUF principles to protect against various repository-based attacks.

## 2. Scope of Assessment
The following components are included in this assessment:
*   **RSTUF API**: The entry point for management and client interaction (FastAPI).
*   **RSTUF Worker**: Processes metadata updates and signing tasks (Celery).
*   **Metadata Storage**: Database and file storage for TUF roles and signed metadata.
*   **Deployment**: Official Docker images and Helm charts for orchestration.

## 3. Architecture Summary
RSTUF utilizes a task-based architecture to separate metadata management logic from critical signing operations:
*   **API (FastAPI)**: Handles authenticated requests to modify repository state.
*   **Worker (Celery/RabbitMQ)**: Asynchronously updates TUF metadata and interacts with signing services (e.g., Sigstore/GCP KMS/Vault).
*   **Storage**: Maintains the state of TUF roles, delegations, and the signed metadata files.
*   **Client Flow**: Clients fetch signed metadata from the repository, which is periodically refreshed and resigned by the RSTUF Worker.

## 4. Threat Model
| Threat | Risk | Mitigation |
| :--- | :--- | :--- |
| **Metadata Tampering** | High: Malicious updates to package metadata. | TUF roles (Root, Targets, Snapshots, Bins) ensure integrity via digital signatures. |
| **Unauthorized Key Usage** | Critical: Compromise of repository keys. | Role-based delegation and threshold signing; separation of keys via KMS integrations. |
| **Compromised Signing Keys** | Critical: Ability to sign malicious metadata. | Key rotation policies and support for secure hardware/cloud-based signing modules. |
| **Replay Attacks** | Medium: Serving valid but outdated metadata. | Expiry timestamps in TUF metadata ensure that clients detect and reject stale data. |
| **Supply Chain Attacks** | High: Compromise of RSTUF CI/CD or images. | Automated scanning (SAST/SCA), binary authorization, and signed container images. |

## 5. Security Controls
*   **Signed Metadata**: All metadata updates are signed by relevant TUF roles following the specification.
*   **Role-Based Delegation**: Minimizes the impact of a single key compromise by distributing trust across multiple roles.
*   **Expiry / Rotation**: Metadata has short-lived validity periods; keys can be rotated via the Root role.
*   **Secure Transport**: All interactions transition through authenticated API endpoints; deployment templates assume HTTPS/TLS termination.
*   **CI/CD Protections**: Mandatory code reviews, GitHub Actions security scanning, and DCO compliance.

## 6. Development Practices
*   **Code Review**: All changes require peer review and approval before merging into the main branch.
*   **CI Pipelines**: Automated tests (Unit, BDD) and security linters run on every Pull Request.
*   **Testing Practices**: Comprehensive test coverage including integration tests for signing integrations and database consistency.

## 7. Incident Response
*   **Vulnerability Reporting**: Security vulnerabilities should be reported via the process outlined in [SECURITY.md](../SECURITY.md).
*   **Patch Process**: Security patches are prioritized and released following the coordinated disclosure process.

## 8. Dependencies / Supply Chain
*   **Python Dependencies**: Regularly audited and updated to remediate known vulnerabilities.
*   **Container Images**: Based on hardened, minimal base images (Distroless/Wolfi intent) to reduce attack surface.
*   **External Integrations**: Supports industry-standard KMS and secret management solutions to avoid local key storage.
