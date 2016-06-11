@gherkin3
Feature: Example elements can be modeled.


  Acceptance criteria

    1. All conceptual pieces of an example block can be modeled:
      - the example's name
      - the example's description
      - the example's parameters
      - the example's rows
      - the example's tags
      - the example's applied tags
      - the example's source line
      - the example's raw element

    2. Example blocks can be outputted in a convenient form


  Background: Test file setup.
    Given the following feature file:
    """
    @a_feature_level_tag
    Feature:

      @outline_tag
      Scenario Outline:
        * a step

      Examples: text describing the significance of the examples

        Some example description.

      Some more.
          Even more.
        |param1| param2 | extra param |
        |x     | y      |      ?      |
        |1     | 2      |      3      |
      @example_tag @another_one
      Examples: some examples with different significance and a tag
        | param1 |
        | a      |
    """
    When the file is read


  Scenario: The raw example element is modeled.
    Then the test example block correctly stores its underlying implementation

  Scenario: The example's source line is modeled.
    Then the test example block "1" is found to have the following properties:
      | source_line | 8 |
    And the test example block "2" is found to have the following properties:
      | source_line | 18 |

  Scenario: The examples' name is modeled.
    Then the test example block "1" is found to have the following properties:
      | name | text describing the significance of the examples |
    And the test example block "2" is found to have the following properties:
      | name | some examples with different significance and a tag |

  Scenario: The examples' description is modeled.
    Then the test example block "1" has the following description:
      """
        Some example description.
  
      Some more.
          Even more.
      """
    And the test example block "2" has no description

  Scenario: The examples' tags are modeled.
    Then the test example block "1" has no tags
    And the test example block "2" is found to have the following tags:
      | @example_tag |
      | @another_one |

  Scenario: The examples' applied tags are modeled.
    Then the test example block "2" is found to have the following applied tags:
      | @a_feature_level_tag |
      | @outline_tag         |

  Scenario: The examples' parameters are modeled.
    Then the test example block "1" parameters are as follows:
      | param1      |
      | param2      |
      | extra param |
    And the test example block "2" parameters are as follows:
      | param1 |

  Scenario: The examples' rows are modeled.
    Then the test example block "1" rows are as follows:
      | x,y,? |
      | 1,2,3 |
    And the test example block "2" rows are as follows:
      | a |

  Scenario: Convenient output of an example block
    Then the example block has convenient output
