@gherkin
Feature: Outputting feature file elements

  The output of an element model is a representation of the element as it would
  appear in gherkin.


  Scenario: Output of a feature file
    Given a feature file element based on "some_feature_file.feature"
    When it is outputted
    Then the following text is provided:
    """
    path_to/some_feature_file.feature
    """
