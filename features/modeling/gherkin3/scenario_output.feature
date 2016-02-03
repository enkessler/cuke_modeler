@gherkin3
Feature: Outputting scenario elements

  The output of an element model is a representation of the element as it would
  appear in gherkin.


  Scenario: Output of a scenario that does not have a name
    Given a scenario element based on the following gherkin:
    """
    Scenario:
    """
    When it is outputted
    Then the following text is provided:
    """
    Scenario:
    """

  Scenario: Output of a scenario that does have a name
    Given a scenario element based on the following gherkin:
    """
    Scenario: with a name
    """
    When it is outputted
    Then the following text is provided:
    """
    Scenario: with a name
    """

  Scenario: Output of a scenario that has tags
    Given a scenario element based on the following gherkin:
    """
    @tag1@tag2
    @tag3
    Scenario:
    """
    When it is outputted
    Then the following text is provided:
    """
    @tag1 @tag2 @tag3
    Scenario:
    """

  Scenario: Output of a scenario that has a description, no first line buffer
    Given a scenario element based on the following gherkin:
    """
    Scenario:
    Some description.
    Some more description.
    """
    When it is outputted
    Then the following text is provided:
    """
    Scenario:
      
      Some description.
      Some more description.
    """

  Scenario: Output of a scenario that has a description, first line is blank
    Given a scenario element based on the following gherkin:
    """
    Scenario:

    Some description.
    Some more description.
    """
    When it is outputted
    Then the following text is provided:
    """
    Scenario:
      
      Some description.
      Some more description.
    """

  Scenario: Output of a scenario that has a description, first line is only whitespace
    Given a scenario element based on the following gherkin:
    """
    Scenario:
       
    Some description.
    Some more description.
    """
    When it is outputted
    Then the following text is provided:
    """
    Scenario:
      
      Some description.
      Some more description.
    """

  Scenario: Output of a scenario that has steps
    Given a scenario element based on the following gherkin:
    """
    Scenario:
    * a step
    |value|
    * another step
    \"\"\"
      some string
    \"\"\"
    """
    When it is outputted
    Then the following text is provided:
    """
    Scenario:
      * a step
        | value |
      * another step
        \"\"\"
          some string
        \"\"\"
    """

  Scenario: Output of a scenario that contains all possible parts
    Given a scenario element based on the following gherkin:
    """
    @tag1@tag2
    @tag3
    Scenario: A scenario with everything it could have
    Including a description
    and then some.

    * a step
    |value|
    * another step
    \"\"\"
      some string
    \"\"\"
    """
    When it is outputted
    Then the following text is provided:
    """
    @tag1 @tag2 @tag3
    Scenario: A scenario with everything it could have
      
      Including a description
      and then some.

      * a step
        | value |
      * another step
        \"\"\"
          some string
        \"\"\"
    """
