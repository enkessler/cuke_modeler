@gherkin3
Feature: Background elements can be modeled.


  Acceptance criteria

    1. All conceptual pieces of a background can be modeled:
      - the background's name
      - the background's description
      - the background's steps
      - the background's source line
      - the background's raw element

    2. Backgrounds can be outputted in a convenient form

  
  Background: Test file setup.
    Given the following feature file:
    """
    Feature:

      Background: Some general test setup stuff.
            
        Some background description.
    
      Some more.
          Even more.

        Given a setup step
        And another setup step
        When an action step
    """
    When the file is read


  Scenario: The raw background element is modeled.
    Then the background correctly stores its underlying implementation

  Scenario: The background source line is modeled.
    Then the background is found to have the following properties:
      | source_line | 3 |

  Scenario: The background name is modeled.
    Then the background is found to have the following properties:
      | name | Some general test setup stuff. |

  Scenario: The background description is modeled.
    Then the background has the following description:
      """
        Some background description.

      Some more.
          Even more.
      """

  Scenario: The background steps are modeled.
    Then the background's steps are as follows:
      | a setup step       |
      | another setup step |
      | an action step     |

  Scenario: Convenient output of a background
    Then the background has convenient output
