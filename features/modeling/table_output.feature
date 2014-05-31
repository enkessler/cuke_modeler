Feature: Outputting table elements

  The output of an element model is a representation of the element as it would
  appear in gherkin.


  Scenario: Output of a table that has one row
    Given a table element based on the following gherkin:
    """
    |value|
    """
    When it is outputted
    Then the following text is provided:
    """
    | value |
    """

  Scenario: Output of a table that has multiple rows
    Given a table element based on the following gherkin:
    """
    |value1|
    |value2|
    """
    When it is outputted
    Then the following text is provided:
    """
    | value1 |
    | value2 |
    """

  Scenario: Whitespace buffers are based on the longest value in a column
    Given a table element based on the following gherkin:
    """
    |value|x|
    |y|another_value|
    """
    When it is outputted
    Then the following text is provided:
    """
    | value | x             |
    | y     | another_value |
    """
