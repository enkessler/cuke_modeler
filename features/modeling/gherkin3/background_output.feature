@gherkin3
Feature: Outputting background elements

  The output of an element model is a representation of the element as it would
  appear in gherkin.


  Scenario: Output of a background that does not have a name
    Given a background element based on the following gherkin:
    """
    Background:
    """
    When it is outputted
    Then the following text is provided:
    """
    Background:
    """

  Scenario: Output of a background that does have a name
    Given a background element based on the following gherkin:
    """
    Background: with a name
    """
    When it is outputted
    Then the following text is provided:
    """
    Background: with a name
    """

  Scenario: Output of a background that has a description, no first line buffer
    Given a background element based on the following gherkin:
    """
    Background:
    Some description.
    Some more description.
    """
    When it is outputted
    Then the following text is provided:
    """
    Background:
      
      Some description.
      Some more description.
    """

  Scenario: Output of a background that has a description, first line is blank
    Given a background element based on the following gherkin:
    """
    Background:

    Some description.
    Some more description.
    """
    When it is outputted
    Then the following text is provided:
    """
    Background:
      
      Some description.
      Some more description.
    """

  Scenario: Output of a background that has a description, first line is only whitespace
    Given a background element based on the following gherkin:
    """
    Background:
       
    Some description.
    Some more description.
    """
    When it is outputted
    Then the following text is provided:
    """
    Background:
      
      Some description.
      Some more description.
    """

  Scenario: Output of a background that has steps
    Given a background element based on the following gherkin:
    """
    Background:
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
    Background:
      * a step
        | value |
      * another step
        \"\"\"
          some string
        \"\"\"
    """

  Scenario: Output of a background that contains all possible parts
    Given a background element based on the following gherkin:
    """
    Background: A background with everything it could have
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
    Background: A background with everything it could have
      
      Including a description
      and then some.

      * a step
        | value |
      * another step
        \"\"\"
          some string
        \"\"\"
    """
