Feature: Test comparison

  Gherkin elements that contain steps (i.e. backgrounds, scenarios, and outlines) can be compared with one another
  in order to determine equality. Elements are considered equal if the base text of their steps match. That is, the
  keyword used for the step and any table or doc string that may be associated with that step are ignored for the
  purposes of comparison.


  Scenario: Comparing tests
    Given a model for the following background:
      """
      Background:
        * step 1
        * step 2
      """
    And a model for the following scenario:
      """
      Scenario:
        * step 1
        * step 2
      """
    And a model for the following outline:
      """
      Scenario Outline:
        * step 1
        * step 2
      Examples:
        | param |
        | value |
      """
    When the models are compared
    Then all of them are equivalent
    But none of the models are equivalent with a model for the following scenario:
      """
      Scenario:
        * step 1
        * step 3
      """
