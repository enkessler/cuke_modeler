@gherkin
Feature: Outline elements can be modeled.


  Acceptance criteria

    1. All conceptual pieces of an outline can be modeled:
      - the outline's name
      - the outline's description
      - the outline's steps
      - the outline's tags
      - the outline's applied tags
      - the outline's example blocks
      - the outline's source line
      - the outline's raw element

    2. Outlines can be outputted in a convenient form


  Background: Test file setup.
    Given the following feature file:
    """
    @a_feature_level_tag
    Feature:

      @outline_tag
      Scenario Outline: The scenario outline's name.
            
        Some outline description.
    
      Some more.
          Even more.

        Given a <setup> step
        When an action step
        Then a <verification> step

      Examples: example 1
        | setup | verification |
        | x     | y            |
      Examples: example 2
        | setup | verification |
        | a     | b            |
    """
    And parameter delimiters of "*" and "*"
    When the file is read


  Scenario: The raw outline element is modeled.
    Then the test correctly stores its underlying implementation

  Scenario: The outline source line is modeled.
    Then the test is found to have the following properties:
      | source_line | 5 |

  Scenario: The outline name is modeled.
    Then the test is found to have the following properties:
      | name | The scenario outline's name. |

  Scenario: The outline description is modeled.
    Then the test has the following description:
      """
          
      Some outline description.

      Some more.
        Even more.
      """

  Scenario: The outline steps are modeled.
    Then the test steps are as follows:
      | a <setup> step        |
      | an action step        |
      | a <verification> step |

  Scenario: The outline tags are modeled.
    Then the test is found to have the following tags:
      | @outline_tag |

  Scenario: The outline applied tags are modeled.
    Then the test is found to have the following applied tags:
      | @a_feature_level_tag |

  Scenario: The outline example blocks are modeled.
    And the test example blocks are as follows:
      | example 1 |
      | example 2 |

  Scenario: Convenient output of an an outline
    Then the outline has convenient output
