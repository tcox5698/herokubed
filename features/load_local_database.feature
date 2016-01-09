Feature: I can load a postgres dump file to a local postgres database

  Background:
    Given heroku toolbelt is installed
    Given I have logged into heroku

  Scenario: I can load a postgres dump file to a local postgres database
    Given I have a postgres dump file from app 'kubedapp99' with a table 'test_table' with a record with value '789'
    When I successfully execute kloaddumplocally from app 'kubedapp99' to local database 'kubedapp99_local'
    Then local db 'kubedapp99_local' has a table 'test_table' with a record with value '789'