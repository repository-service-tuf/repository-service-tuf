# Repository Service TUF - Test Analysis Report

## 1. Overview
The `repository-service-tuf` repository is designed with a modular architecture that relies on git submodules for its core components:
- `repository-service-tuf-api`
- `repository-service-tuf-cli`
- `repository-service-tuf-worker`

The root directory contains overarching end-to-end (E2E) and integration tests, while each submodule has its own dedicated `tests/` directory with unit tests. Testing is primarily managed using `pytest`, with root-level functional tests written in a BDD format using `pytest-bdd`/`pytest-gherkin`.

## 2. Total Test Counts
By analyzing test files (e.g., searching for `def test_` across the python test modules), the total number of tests in the repository and its submodules is **463**.

The breakdown per component is as follows:
- **Root (Functional/E2E Tests)**: 7 tests
- **API (`repository-service-tuf-api`)**: 86 tests
- **CLI (`repository-service-tuf-cli`)**: 160 tests
- **Worker (`repository-service-tuf-worker`)**: 210 tests

## 3. Coverage & Missing Tests Analysis

By comparing the source modules to their respective `tests/` folder structure, we can identify which modules have explicit test files and which ones are currently missing them.

### A. API Component (`repository-service-tuf-api`)
**Current Test Coverage**:
- Covered: `bootstrap.py`, `common_models.py`, `config.py`, `delegations.py`, `metadata.py`, `tasks.py`
- Test files map neatly 1:1 with source files (e.g., `test_bootstrap.py`, `test_delegations.py`).

**Missing Explicit Test Files**:
- `artifacts.py` (No corresponding `test_artifacts.py`, though some logic might be implicitly tested in `test_targets.py`).
- `__version__.py`

### B. CLI Component (`repository-service-tuf-cli`)
**Current Test Coverage**:
- Covered: `admin/ceremony.py`, `admin/helpers.py`, `admin/import_artifacts.py`, `admin/metadata/` operations, `admin/send/` operations, `artifact/` operations, and helpers.
- The CLI has an extensive unit test suite located in `tests/unit/`.

**Missing Explicit Test Files**:
- The most notable gap is in the **`admin/delegations`** module. The source files `cli/admin/delegations/delete.py` and `cli/admin/delegations/new.py` do not have corresponding test files in the `tests/unit/cli/admin/` folder.

### C. Worker Component (`repository-service-tuf-worker`)
**Current Test Coverage**:
- Covered: `interfaces.py`, `repository.py`, `signer.py`, `models/targets/crud.py`, `services/storage/awss3.py`, and `services/storage/local.py`.

**Missing Explicit Test Files**:
- `models/targets/models.py`
- `models/targets/schemas.py`
*(Note: These files primarily contain Pydantic schemas and database data models. While they don't have dedicated test files, their validation logic is likely inherently tested via `test_crud.py` and `test_repository.py`).*

## 4. Test Infrastructure
- **Makefile**: A `Makefile` in the root repository manages the test execution. Commands like `make functional-tests` trigger the BDD integration tests.
- **Linting & Formatting**: The codebase enforces strict code styles using `flake8`, `isort`, and `black` prior to running tests.
- **Docker**: Functional tests rely heavily on `docker compose` to spin up the API and Worker containers, testing the actual integrations between the components.
