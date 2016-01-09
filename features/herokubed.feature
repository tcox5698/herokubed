Feature: I can transfer a postgres database from one app instance to another.

  Background:
    Given heroku toolbelt is installed
    Given I have logged into heroku

  Scenario: I can transfer, backup and locally load my heroku instances
    #transfer
    And I have app 'kubedapp1' with a postgres database
    And I add table 'kubedTable1' to app 'kubedapp1' with a record with value '5364'
    Then app 'kubedapp1' has a table 'kubedTable1' with a record with value '5364'
    And I have app 'kubedapp2' with a postgres database
    When I successfully execute ktransferdb from app 'kubedapp1' to app 'kubedapp2'
    Then app 'kubedapp2' has a table 'kubedTable1' with a record with value '5364'
    #backup
    Given I have a dump file for app 'kubedapp1' in the .dbwork directory last modified at '201505211053.23'
    When I successfully execute kbackupdb for app 'kubedapp1'
    Then I have a new dump file in the .dbwork directory for app 'kubedapp1'
    When I load the .dbwork dump file for app 'kubedapp1' into local db 'test_db'
    Then local db 'test_db' has a table 'kubedTable1' with a record with value '5364'
    And there is a dump file for app 'kubedapp1' in the .dbwork directory postfixed with '20150521_105323'
    #load
    When I successfully execute kloaddumplocally from app 'kubedapp1' to local database 'kubedapp99_local'
    Then local db 'kubedapp99_local' has a table 'kubedTable1' with a record with value '5364'