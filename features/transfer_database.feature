Feature: I can transfer a postgres database from one app instance to another.

  Scenario: I can transfer a db from one existing instance to another existing instance.
    Given I have logged into heroku
    And I have app 'kubedapp1' with a postgres database
    And I add table 'kubedTable1' to app 'kubedapp1'
#    And I have app 'kubedapp1' with a postgres database
#    When I execute 'k transferdb kubedapp1 kubedapp1'
#    Then app 'kubedapp1' has a table 'kubedTable1'
