Feature: Create succinct hash-bin delegations under custom delegations
    User has deployed RSTUF,
    Admin wants to create succinct hash-bin delegations under custom delegations 

    Scenario Outline: Admin opts for succinct hash‑bin delegations under custom delegation while performing ceremony
        Given repository-service-tuf (RSTUF) is installed
        When the Admin starts the ceremony
        And selects to create a custom delegation named "<delegation_name>"
        Then RSTUF prompts:
            | Prompt                                                                 |
            | "Do you want further hash‑bin delegations under this <delegation_name> delegation (y/n)?" |
        When the Admin enters "y"
        Then RSTUF prompts:
            | Prompt                                                                 |
            | "Number of bins (2/4/8/16/32/64/128/256/512/1024/2048/4096):"          |
        When the Admin enters "<bins>"
        And the Admin enters the remaining required details for the custom delegation
        Then the CLI displays the generated delegation metadata, including hash‑bin structure

        Examples:
            | delegation_name | bins |
            | downloads       | 16   |
            | releases        | 1024 |

    Scenario Outline: Admin opts for succinct hash‑bin delegations under custom delegation after performing ceremony
        Given repository-service-tuf (RSTUF) is installed
        And ceremony is completed
        When the Admin opts to add new delegation
        And selects to create a custom delegation named "<delegation_name>"
        Then RSTUF prompts:
            | Prompt                                                                 |
            | "Do you want further hash‑bin delegations under this <delegation_name> delegation (y/n)?" |
        When the Admin enters "y"
        Then RSTUF prompts:
            | Prompt                                                                 |
            | "Number of bins (2/4/8/16/32/64/128/256/512/1024/2048/4096):"          |
        When the Admin enters "<bins>"
        And the Admin enters the remaining required details for the custom delegation
        Then the CLI displays the generated delegation metadata, including hash‑bin structure

        Examples:
            | delegation_name | bins |
            | project-a       | 256  |