Feature: Step elements can be modeled.


  Acceptance criteria

    1. All conceptual pieces of a step can be modeled:
      - the step's keyword
      - the text of the step
      - the step's arguments, if any
      - the step's associated block, if any
      - the step's source line
      - the step's raw element

    2. Steps can be outputted in a convenient form


  Background: Test file setup.
    Given the following feature file:
    """
    Feature:

      Scenario:
        Given some setup step
        And some big setup step:
        \"\"\" content_type
      some text
            some more text
        \"\"\"
        When this *parameterized* step takes a table:
          | data      | a header |
          | more data | a value  |
        Then a step with a *parameter*
    """
    And parameter delimiters of "*" and "*"
    When the file is read


  Scenario: The raw step element is modeled.
    Then the test step correctly stores its underlying implementation

  Scenario: The step's source line is modeled.
    Then the test step "1" source line is "4"
    And  the test step "2" source line is "5"
    And  the test step "3" source line is "10"
    And  the test step "4" source line is "13"

  Scenario: The step's keyword is modeled.
    Then the test step "1" keyword is "Given"
    And the test step "2" keyword is "And"
    And the test step "3" keyword is "When"
    And the test step "4" keyword is "Then"

  Scenario: The text of the step is modeled.
    Then test step "1" text is "some setup step"
    And test step "2" text is "some big setup step:"
    And test step "3" text is "this *parameterized* step takes a table:"
    And test step "4" text is "a step with a *parameter*"

  Scenario: The step's arguments are modeled.
    Then test step "1" has no arguments
    And test step "2" has no arguments
    And test step "3" arguments are:
      | parameterized |
    And test step "4" arguments are:
      | parameter |

  Scenario: The steps's block is modeled.
    Then step "1" has no block
    Then step "2" has a "doc string"
    And step "3" has a "table"
    And step "4" has no block

  Scenario: Convenient output of a step
    Then the step has convenient output

  @redundant
  Scenario Outline: Step models pass all other specifications
  Exact specifications detailing the API for step models.
    Given that there are "<additional specifications>" detailing models
    When the corresponding specifications are run
    Then all of those specifications are met
  Examples:
    | additional specifications |
    | step_unit_spec.rb         |
    | step_integration_spec.rb  |
