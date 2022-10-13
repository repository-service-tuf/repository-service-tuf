Feature: Bootstrap Repository Service for TUF (RSTUF)
    As a admin,
    Admin have done the offline Ceremony to generate the payload.json,
    Admin want to bootstrap the RSTUF uploading the file

    Scenario: Bootstrap using RSTUF Command Line Interface (CLI)
        Given the repository-service-tuf (rstuf) is installed
        And the admin login to RSTUF using rstuf
        And the admin is logged in
        When the admin run rstuf for ceremony bootstrap
        Then the admin gets "Bootstrap status: SUCCESS" and "Bootstrap finished." or "Already has metadata"

    Scenario: Bootstrap using RSTUF Command Line Interface (CLI) with invalid payload
        Given the repository-service-tuf (rstuf) is installed
        And the admin login to RSTUF using rstuf
        And the admin is logged in
        When the admin run rstuf for ceremony bootstrap with invalid payload JSON
        Then the admin gets "Error 422"