Feature: Model structure

  Element models form a nested structure that is based on the portion of a test
  suite that they represent. See specific modeling features for details.


  Scenario: Element models are nested
    Given the element models provided by CukeModeler
    Then  all of them can be contained inside of another model
    And   all of them can contain other models
