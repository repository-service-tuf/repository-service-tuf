"""Importing artifacts to Repository Service for TUF (RSTUF) Databases."""

import ast

from pytest_bdd import given, scenario, then, when
from pytest_bdd.parsers import parse

from repository_service_tuf.cli.admin import import_artifacts

@scenario(
    "../../features/admin/import_artifacts.feature",
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
        "the admin runs rstuf for import-artifacts with {api_server}, {db_uri}, "
        "{csv_files} following the RSTUF import-artifacts documentation "
        "requirements"
    ),
    target_fixture="response",
)
def the_admin_runs_rstuf_for_import_artifacts(
    rstuf_cli, api_server, db_uri, csv_files
):

    # remove quotes; example "['str', 'str']" -> to python list['str', 'str']
    csvs = ast.literal_eval(csv_files)
    api_server = ast.literal_eval(api_server)

    csvs_list =" --csv ".join(csvs.split(', '))
    # breakpoint()

    rc, output = rstuf_cli(
        f"admin import-artifacts --api-server {api_server} "
        f"--db-uri {db_uri} --csv {csvs_list}"
    )
    assert "SUCCESS" in output and "Finished." in output

    return rc, output


# @then(
#     'the admin gets "Import status: task SUCCESS" and '
#     '"Import status: Finished."'
# )
# def the_admin_gets(output):

#     assert "SUCCESS" in output and "Finished." in output