Feature: Doc string elements can be modeled.


  Acceptance criteria

    1. All conceptual pieces of a doc string can be modeled:
      - the doc string's content type
      - the doc string's contents
      - the doc string's raw element

    2. Doc string can be outputted in a convenient form


  Background: Test file setup.
    Given the following feature file:
    """
    Feature:

      Scenario:
        * some wordy step:
        \"\"\" content type
      some text
          
            some more text
        
        \"\"\"
        * some wordy step:
        \"\"\"
        \"\"\"
    """
    When the file is read


  Scenario: The raw doc string element is modeled.
    Then the doc string correctly stores its underlying implementation

  Scenario: The doc string's content type is modeled.
    Then the step "1" doc string content type is "content type"
    And the step "2" doc string has no content type

  Scenario: The doc string's contents are modeled.
    Then the step "1" doc string has the following contents:
      """
      some text
        
          some more text
      
      """
    And the step "2" doc string contents are empty

  Scenario: Convenient output of an a doc string
    Then the doc string has convenient output
