@acceptance
Feature: Tag modeling

  Tag models represent a tag attached to a filterable gherkin element (e.g. a
  feature or outline example table).


  Background: Test file setup.
    Given the following feature file:
      """
      @feature_tag
      Feature:

        @scenario_tag
        Scenario:
          * a step

        @outline_tag
        Scenario Outline:
          * a step

        @example_tag
        Examples:
          | a param |
      """
    When the file is modeled


  Scenario: The tag's name is modeled.
    Then the feature tag name is "@feature_tag"
