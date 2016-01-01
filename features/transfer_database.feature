Feature: I can transfer a postgres database from one app instance to another.

  Scenario: I can transfer a db from one existing instance to another existing instance.
    Given heroku toolbelt is installed
    Given herokubed is built and installed
    Given I have logged into heroku
    And I have app 'kubedapp1' with a postgres database
    And I add table 'kubedTable1' to app 'kubedapp1' with a record with value '5364'
    Then app 'kubedapp1' has a table 'kubedTable1' with a record with value '5364'
    And I have app 'kubedapp2' with a postgres database
    When I successfully execute 'ktransferdb kubedapp1 kubedapp2'
    Then app 'kubedapp2' has a table 'kubedTable1' with a record with value '5364'
