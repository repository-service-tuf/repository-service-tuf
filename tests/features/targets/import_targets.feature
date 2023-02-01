Feature: Import targets directly to RSTUF SQL Database
    As an admin,
    Admin has deployed and bootstrapped RSTUF
    Admin has an existent large number of targets (i.e.: 1,000,000 targets)
    Admin wants to load targets in chunks to process them faster

    Background:
        Given admin has the RSTUF CLI in a host with access to RSTUF SQL Database
        And admin has logged in with RSTUF CLI
        And admin has the credentials to access RSTUF SQL Database
        And admin has exported the targets info to CSV files (respecting CSV limits) with the format 'path;size;hash_type;hash;custom;'

    Scenario: Admin imports a large number of targets to RSTUF
        Given admin has multiple CSV files with targets 'tests/data/targets-1of2.csv' and 'tests/data/targets-2of2.csv'
        When admin runs 'rstuf -c rstuf.ini admin import-targets -csv tests/data/targets-1of2.csv -csv tests/data/targets-2of2.csv -metadata-url http://127.0.0.1:8080 -db-uri postgresql://postgres:secret@127.0.0.1:543'
        And the admin expects to get confirmation 'CSV data was imported successfully'.
        And the admin expects to get the task id in the message 'Publishing new targets from task with id:'
        And the admin will get the current status of the task
        Then the admin expects the result 'All targets published.'

    Scenario: Admin imports a large number of targets to RSTUF without publishing to TUF metadata
        Given admin has multiple CSV files with targets 'tests/data/targets-1of2.csv' and 'tests/data/targets-2of2.csv'
        When admin runs 'rstuf -c rstuf.ini admin import-targets --skip-publish-targets -csv tests/data/targets-1of2.csv -csv tests/data/targets-2of2.csv -metadata-url http://127.0.0.1:8080 -db-uri postgresql://postgres:secret@127.0.0.1:543'
        Then the admin expects to get confirmation 'CSV data was imported successfully, and publishing of targets was skipped.'.
