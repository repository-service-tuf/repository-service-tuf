"""Importing artifacts to Repository Service for TUF (RSTUF) Databases."""

import ast

from pytest_bdd import given, scenario, then, when
from pytest_bdd.parsers import parse


@scenario(
    "../../features/artifacts/import_artifacts.feature",
    "Importing artifacts using RSTUF CLI",
)
def test_importing_artifacts_using_rstuf_cli():
    """Importing artifacts using RSTUF CLI"""


@given("the repository-service-tuf (rstuf) is installed")
def the_tufrepositoryservice_rstufcli_is_installed(rstuf_cli):
    rc, output = rstuf_cli("-h")
    assert rc == 0, output


@when(
    parse(
        "the admin runs rstuf for import-artifacts with {db_uri}, {csv1}, "
        "{csv2} and {metadata_url} "
        "following the RSTUF import-artifacts documentation requirements"
    ),
    target_fixture="response",
)
def the_admin_runs_rstuf_for_import_artifacts(
    rstuf_cli, db_uri, csv1, csv2, metadata_url
):
    # remove quotes; example "['str', 'str']" -> to python list['str', 'str']
    csv1 = ast.literal_eval(csv1)
    csv2 = ast.literal_eval(csv2)
    metadata_url = ast.literal_eval(metadata_url)

    rc, output = rstuf_cli(
        f"admin import-artifacts --db-uri {db_uri} --csv {csv1} "
        f"--csv {csv2} --metadata-url {metadata_url}"
    )

    return rc, output


@then(
    'the admin gets "Import status: task SUCCESS" and '
    '"Import status: Finished."'
)
def the_admin_gets(bootstrap):
    _, output = bootstrap

    assert "SUCCESS" in output and "Finished." in output
