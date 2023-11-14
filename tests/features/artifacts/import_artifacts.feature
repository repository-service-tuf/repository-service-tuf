Feature: Importing artifacts to Repository Service for TUF (RSTUF) Database
    User has deployed RSTUF,
    User has all requirements listed in the RSTUF import-artifacts documentation

    Scenario: Importing artifacts using RSTUF CLI
        Given the repository-service-tuf (rstuf) is installed
        When the admin runs rstuf for import-artifacts with <db_uri>, <csv>, <csv> and <metadata_url> following the RSTUF import-artifacts documentation requirements
        Then the admin gets "Import status: task SUCCESS" and "Import status: Finished."

        Examples:
            | db_uri                                             | csv           | csv           | metadata_url                 |
            | ["postgresql://postgres:secret@127.0.0.1:5433"]    | ["file1.csv"] | ["file2.csv"] | ["http://127.0.0.1:8080/"]   |
