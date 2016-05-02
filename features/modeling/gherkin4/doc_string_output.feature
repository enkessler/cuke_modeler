@gherkin4
Feature: Outputting doc string elements

  The output of an element model is a representation of the element as it would
  appear in gherkin.


  Scenario: Output of an empty doc string
    Given a doc string element based on the following gherkin:
    """
    \"\"\"
    \"\"\"
    """
    When it is outputted
    Then the following text is provided:
    """
    \"\"\"
    \"\"\"
    """

  Scenario: Output of a doc string without a content type
    Given a doc string element based on the following gherkin:
    """
    \"\"\"
    Some text
      
      some more text
    
    \"\"\"
    """
    When it is outputted
    Then the following text is provided:
    """
    \"\"\"
    Some text
      
      some more text
    
    \"\"\"
    """

  Scenario: Output of a doc string with a content type
    Given a doc string element based on the following gherkin:
    """
    \"\"\" the type
    Some text
      
      some more text
    
    \"\"\"
    """
    When it is outputted
    Then the following text is provided:
    """
    \"\"\" the type
    Some text
      
      some more text
    
    \"\"\"
    """

  Scenario: Output of a doc string with a triple quotes in its contents

  Since triple quotes mark the beginning and end of a doc string, any triple
  quotes inside of the doc string (which would have had to have been escaped
  to get inside in the first place) will be escaped when outputted so as to
  retain the quality of being able to use the output directly as gherkin.

    Given a doc string element based on the string """" the type\n* a step\n  \"\"\"\n  that also has a doc string\n  \"\"\"\n""""
    When it is outputted
    Then the text provided is """" the type\n* a step\n  \"\"\"\n  that also has a doc string\n  \"\"\"\n""""
