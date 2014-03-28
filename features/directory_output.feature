Feature: Outputting directory elements

  The output of an element model is a textual representation of the element as it
  would appear in Gherkin. As such, output from a model can be used as input for
  the same kind of model.


  Scenario: Output of a directory
    Given a directory element based on "some_directory"
    When it is outputted
    Then the following text is provided:
      """
      path_to/some_directory
      """
    And the output produces an equivalent element model when consumed
