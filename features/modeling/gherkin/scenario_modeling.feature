@gherkin
Feature: Scenario elements can be modeled.


  Acceptance criteria

    1. All conceptual pieces of a scenario can be modeled:
      - the scenario's name
      - the scenario's description
      - the scenario's steps
      - the scenario's tags
      - the scenario's applied tags
      - the scenario's source line
      - the scenario's raw element

    2. Scenarios can be outputted in a convenient form


  Background: Test file setup.
    Given the following feature file:
    """
    @a_feature_level_tag
    Feature:

      @a_tag
      @another_tag
      Scenario:The first scenario's name.
            
        Some scenario description.
    
      Some more.
          Even more.

        Given a setup step
        When an action step
        Then a verification step
    """
    And parameter delimiters of "*" and "*"
    When the file is read


  Scenario: The raw scenario element is modeled.
    Then the test correctly stores its underlying implementation

  Scenario: The scenario source line is modeled.
    Then the test is found to have the following properties:
      | source_line | 6 |

  Scenario: The scenario name is modeled.
    Then the test is found to have the following properties:
      | name | The first scenario's name. |

  Scenario: The scenario description is modeled.
    Then the test has the following description:
      """
          
      Some scenario description.

      Some more.
        Even more.
      """

  Scenario: The scenario steps are modeled.
    Then the test steps are as follows:
      | a setup step        |
      | an action step      |
      | a verification step |

  Scenario: The scenario tags are modeled.
    Then the test is found to have the following tags:
      | @a_tag       |
      | @another_tag |

  Scenario: The scenario applied tags are modeled.
    Then the test is found to have the following applied tags:
      | @a_feature_level_tag |

  Scenario: Convenient output of a scenario
   Then the scenario has convenient output
