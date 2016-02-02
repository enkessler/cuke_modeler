@gherkin
Feature: Outputting directory elements

  The output of an element model is a representation of the element as it would
  appear in gherkin.


  Scenario: Output of a directory
    Given a directory element based on "some_directory"
    When it is outputted
    Then the following text is provided:
    """
    path_to/some_directory
    """
