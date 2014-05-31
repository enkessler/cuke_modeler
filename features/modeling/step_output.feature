Feature: Outputting step elements

  The output of an element model is a representation of the element as it would
  appear in gherkin.


  Scenario: Output of a step without a block
    Given a step element based on the following gherkin:
    """
    * a step
    """
    When it is outputted
    Then the following text is provided:
    """
    * a step
    """

  Scenario: Output of a step with a doc string
    Given a step element based on the following gherkin:
    """
    * a step
    \"\"\"
    Some text

      some more text
    \"\"\"
    """
    When it is outputted
    Then the following text is provided:
    """
    * a step
      \"\"\"
      Some text
      
        some more text
      \"\"\"
    """

  Scenario: Output of a step with a table
    Given a step element based on the following gherkin:
    """
    * a step
    |value1|
    |value2|
    """
    When it is outputted
    Then the following text is provided:
    """
    * a step
      | value1 |
      | value2 |
    """
