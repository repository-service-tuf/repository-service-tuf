Feature: Bootstrap TUF Repository Service (TRS)
    As a admin,
    Admin have done the offline Ceremony to generate the payload.json,
    Admin want to bootstrap the TRS uploading the file

    Scenario: Bootstrap using TRS Command Line Interface (CLI)
        Given the tuf-repository-service (trs-cli) is installed
        And the admin login to TRS using trs-cli
        And the admin is logged in
        When the admin run trs-cli for ceremony bootstrap
        Then the admin gets "Bootstrap status: SUCCESS" and "Bootstrap finished." or "Already has metadata"

    Scenario: Bootstrap using TRS Command Line Interface (CLI) with invalid payload
        Given the tuf-repository-service (trs-cli) is installed
        And the admin login to TRS using trs-cli
        And the admin is logged in
        When the admin run trs-cli for ceremony bootstrap with invalid payload JSON
        Then the admin gets "Error 422"