Feature: Delete a custom delegation
    User has deployed RSTUF,

    Scenario Outline: User opts to delete an existing custom delegation
        Given repository-service-tuf (RSTUF) is installed
        And ceremony is completed
        When the User opts to delete an existing delegation
        And chooses to delete the custom delegation named "<delegation_name>"
        Then RSTUF prompts:
            | Prompt                                                                 |
            | "Are you sure you want to delete the delegation <delegation_name> (y/n)?" |
        When the User enters "y"
        Then the CLI confirms the delegation "<delegation_name>" was successfully deleted

        Examples:
            | delegation_name |
            | old-project     |
            | deprecated-bin  |
