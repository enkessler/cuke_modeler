Feature: Tag elements can be modeled.


  Acceptance criteria

    1. All conceptual pieces of a tag can be modeled:
      - the tag's name
      - the tags's source line
      - the tags's raw element

    2. Features can be outputted in a convenient form


  Background: Test file setup.
    Given the following feature file:
    """
    @feature_tag
    Feature:

      @outline_tag
      Scenario Outline:
        * a step

      @example_tag
      Examples:
        | a param |
    """
    When the file is read


  Scenario: The raw tag element is modeled.
    Then the feature tag correctly stores its underlying implementation
    And the test tag correctly stores its underlying implementation
    And the example tag correctly stores its underlying implementation

  Scenario: The tag's source line is modeled.
    Then the feature tag source line "1"
    And the test tag source line "4"
    And the example tag source line "8"

  Scenario: The tag name is modeled.
    Then the feature tag name is "@feature_tag"
    And the test tag name is "@outline_tag"
    And the example tag name is "@example_tag"

  Scenario: Convenient output of a tag
    Then the tag has convenient output

  @redundant
  Scenario Outline: Tag models pass all other specifications
  Exact specifications detailing the API for tag models.
    Given that there are "<additional specifications>" detailing models
    When the corresponding specifications are run
    Then all of those specifications are met
  Examples:
    | additional specifications |
    | tag_unit_spec.rb          |
    | tag_integration_spec.rb   |
