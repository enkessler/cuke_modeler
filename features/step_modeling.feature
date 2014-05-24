@acceptance
Feature: Step modeling

  Step models represent a step in a Cucumber test or background.


  Background: Test file setup.
    Given the following feature file:
      """
      Feature:

        Background:
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
    When the file is modeled


  Scenario: The step's name is modeled.
    Then the first steps's text is "some setup step"
    And the second steps's text is "some big setup step:"
    And the third steps's text is "this *parameterized* step takes a table:"
    And the fourth steps's text is "a step with a *parameter*"


  @redundant
  Scenario Outline: Step models pass all other specifications
  Exact specifications detailing the API for step models.
    Given that there are "<additional specifications>" detailing models
    When the those specifications are run
    Then all of those specifications are met
  Examples:
    | additional specifications      |
    | background_unit_spec.rb        |
    | background_integration_spec.rb |
