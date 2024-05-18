Feature: Importing artifacts to Repository Service for TUF (RSTUF) Database
    User has deployed RSTUF,
    User has all requirements listed in the RSTUF import-artifacts documentation

    Scenario Outline: Importing artifacts using RSTUF CLI
        Given the repository-service-tuf (rstuf) is installed
        When the admin runs rstuf for import-artifacts with <api_server>, <db_uri>, <csv_files> following the RSTUF import-artifacts documentation requirements
        Then the admin gets "Import status: task SUCCESS" and "Import status: Finished."

        Examples:
        | api_server                 | db_uri                                           | csv_files               |
        | "http://127.0.0.1:8080/"   | "postgresql://postgres:secret@127.0.0.1:5433"    | "file1.csv, file2.csv"  |
