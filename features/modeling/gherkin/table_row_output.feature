@gherkin
Feature: Outputting table row elements

  The output of an element model is a representation of the element as it would
  appear in gherkin.


  Scenario: Output of a table row that has one cell
    Given a table row element based on the following gherkin:
    """
    |value|
    """
    When it is outputted
    Then the following text is provided:
    """
    | value |
    """

  Scenario: Output of a table row that has multiple cells
    Given a table row element based on the following gherkin:
    """
    |value|another_value|
    """
    When it is outputted
    Then the following text is provided:
    """
    | value | another_value |
    """
