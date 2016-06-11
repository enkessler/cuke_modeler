@gherkin
Feature: Outputting outline elements

  The output of an element model is a representation of the element as it would
  appear in gherkin.


  Scenario: Output of an outline that does not have a name
    Given an outline element based on the following gherkin:
    """
    Scenario Outline:
    """
    When it is outputted
    Then the following text is provided:
    """
    Scenario Outline:
    """

  Scenario: Output of an outline that does have a name
    Given an outline element based on the following gherkin:
    """
    Scenario Outline: with a name
    """
    When it is outputted
    Then the following text is provided:
    """
    Scenario Outline: with a name
    """

  Scenario: Output of an outline that does have tags
    Given an outline element based on the following gherkin:
    """
    @tag1@tag2
    @tag3
    Scenario Outline:
    """
    When it is outputted
    Then the following text is provided:
    """
    @tag1 @tag2 @tag3
    Scenario Outline:
    """

  Scenario: Output of an outline that has a description, no first line buffer
    Given an outline element based on the following gherkin:
    """
    Scenario Outline:
    Some description.
    Some more description.
    """
    When it is outputted
    Then the following text is provided:
    """
    Scenario Outline:

    Some description.
    Some more description.
    """

  Scenario: Output of an outline that has a description, first line is blank
    Given an outline element based on the following gherkin:
    """
    Scenario Outline:

    Some description.
    Some more description.
    """
    When it is outputted
    Then the following text is provided:
    """
    Scenario Outline:

    Some description.
    Some more description.
    """

  Scenario: Output of an outline that has a description, first line is only whitespace
    Given an outline element based on the following gherkin:
    """
    Scenario Outline:

    Some description.
    Some more description.
    """
    When it is outputted
    Then the following text is provided:
    """
    Scenario Outline:

    Some description.
    Some more description.
    """

  Scenario: Output of an outline that has steps
    Given an outline element based on the following gherkin:
    """
    Scenario Outline:
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
    Scenario Outline:
      * a step
        | value |
      * another step
        \"\"\"
          some string
        \"\"\"
    """

  Scenario: Output of an outline that has examples
    Given an outline element based on the following gherkin:
    """
    Scenario Outline:
    * a <value> step
    Examples:
    | value |
    | x     |
    @example_tag
    Examples:
    | value |
    | y     |
    """
    When it is outputted
    Then the following text is provided:
    """
    Scenario Outline:
      * a <value> step

    Examples:
      | value |
      | x     |

    @example_tag
    Examples:
      | value |
      | y     |
    """

  Scenario: Output of an outline that contains all possible parts
    Given an outline element based on the following gherkin:
    """
    @tag1@tag2
    @tag3
    Scenario Outline: An outline with everything it could have
    Some description.
    Some more description.
    * a step
    |value|
    * a <value> step
    \"\"\"
      some string
    \"\"\"
    Examples:
    Some description.
    Some more description.
    | value |
    | x     |
    @example_tag
    Examples:
    | value |
    | y     |
    """
    When it is outputted
    Then the following text is provided:
    """
    @tag1 @tag2 @tag3
    Scenario Outline: An outline with everything it could have

    Some description.
    Some more description.

      * a step
        | value |
      * a <value> step
        \"\"\"
          some string
        \"\"\"

    Examples:

    Some description.
    Some more description.

      | value |
      | x     |

    @example_tag
    Examples:
      | value |
      | y     |
    """
