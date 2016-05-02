@gherkin4
Feature: Outputting feature elements

  The output of an element model is a representation of the element as it would
  appear in gherkin.


  Scenario: Output of a feature that does not have a name
    Given a feature element based on the following gherkin:
    """
    Feature:
    """
    When it is outputted
    Then the following text is provided:
    """
    Feature:
    """

  Scenario: Output of a feature that does have a name
    Given a feature element based on the following gherkin:
    """
    Feature: with a name
    """
    When it is outputted
    Then the following text is provided:
    """
    Feature: with a name
    """

  Scenario: Output of a feature that has tags
    Given a feature element based on the following gherkin:
    """
    @tag1@tag2
    @tag3
    Feature:
    """
    When it is outputted
    Then the following text is provided:
    """
    @tag1 @tag2 @tag3
    Feature:
    """

  Scenario: Output of a feature that has a description, no first line buffer
    Given a feature element based on the following gherkin:
    """
    Feature:
    Some description.
    Some more description.
    """
    When it is outputted
    Then the following text is provided:
    """
    Feature:
      
      Some description.
      Some more description.
    """

  Scenario: Output of a feature that has a description, first line is blank
    Given a feature element based on the following gherkin:
    """
    Feature:

    Some description.
    Some more description.
    """
    When it is outputted
    Then the following text is provided:
    """
    Feature:
      
      Some description.
      Some more description.
    """

  Scenario: Output of a feature that has a description, first line is only whitespace
    Given a feature element based on the following gherkin:
    """
    Feature:
       
    Some description.
    Some more description.
    """
    When it is outputted
    Then the following text is provided:
    """
    Feature:
      
      Some description.
      Some more description.
    """

  Scenario: Output of a feature that has a background
    Given a feature element based on the following gherkin:
    """
    Feature:

    Background:
    * a step
    * another step
    """
    When it is outputted
    Then the following text is provided:
    """
    Feature:

      Background:
        * a step
        * another step
    """

  Scenario: Output of a feature that has a scenario
    Given a feature element based on the following gherkin:
    """
    Feature:

    Scenario:
    * a step
    * another step
    """
    When it is outputted
    Then the following text is provided:
    """
    Feature:

      Scenario:
        * a step
        * another step
    """

  Scenario: Output of a feature that has an outline
    Given a feature element based on the following gherkin:
    """
    Feature:

    Scenario Outline:
    * a step
    * another step
    Examples:
    |param|
    """
    When it is outputted
    Then the following text is provided:
    """
    Feature:

      Scenario Outline:
        * a step
        * another step

      Examples:
        | param |
    """

  Scenario: Output of a feature that contains all possible parts
    Given a feature element based on the following gherkin:
    """
    @tag1@tag2
    @tag3
    Feature: A feature with everything it could have
    Including a description
    and then some.
    Background:
    Background
    description
    * a step
    |value1|
    * another step
    @scenario_tag
    Scenario:
    Scenario
    description
    * a step
    * another step
    \"\"\"
      some text
    \"\"\"
    @outline_tag
    Scenario Outline:
    Outline
    description
    * a step
    |value2|
    * another step
    \"\"\"
      some text
    \"\"\"
    @example_tag
    Examples:
    Example
    description
    |param|
    """
    When it is outputted
    Then the following text is provided:
    """
    @tag1 @tag2 @tag3
    Feature: A feature with everything it could have
      
      Including a description
      and then some.

      Background:
        
        Background
        description

        * a step
          | value1 |
        * another step

      @scenario_tag
      Scenario:
        
        Scenario
        description

        * a step
        * another step
          \"\"\"
            some text
          \"\"\"

      @outline_tag
      Scenario Outline:
        
        Outline
        description

        * a step
          | value2 |
        * another step
          \"\"\"
            some text
          \"\"\"

      @example_tag
      Examples:
        
        Example
        description

        | param |
    """
