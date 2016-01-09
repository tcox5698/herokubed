Feature: I can backup an heroku postgres database to a local directory

  Background:
    Given heroku toolbelt is installed
    Given I have logged into heroku

  Scenario:
    Given I have a dump file for app 'kubedapp1' in the .dbwork directory last modified at '201505211053.23'
    Given I have app 'kubedapp1' with a postgres database
    And I add table 'kubedTable1' to app 'kubedapp1' with a record with value '5364'
    Then app 'kubedapp1' has a table 'kubedTable1' with a record with value '5364'
    When I successfully execute kbackupdb for app 'kubedapp1'
    Then I have a new dump file in the .dbwork directory for app 'kubedapp1'
    When I load the .dbwork dump file for app 'kubedapp1' into local db 'test_db'
    Then local db 'test_db' has a table 'kubedTable1' with a record with value '5364'
    And there is a dump file for app 'kubedapp1' in the .dbwork directory postfixed with '20150521_105323'