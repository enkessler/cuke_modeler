Feature: Outputting tag elements

  The output of an element model is a representation of the element as it would
  appear in gherkin.


  Scenario: Output of a tag that has a name
    Given a tag element based on the following gherkin:
    """
    @some_tag
    """
    When it is outputted
    Then the following text is provided:
    """
    @some_tag
    """
