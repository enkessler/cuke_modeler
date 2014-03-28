Feature: Model output

  All models can be output in text form, suitable for use in feature files or
  anything else that uses Gherkin. See model specific output features for details.


  Scenario: All element models can output themselves in Gherkin
    Given the element models provided by CukeModeler
    Then  all of them can be output as text
    And   this text is specifically formatted
