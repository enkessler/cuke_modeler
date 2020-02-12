Feature: Step comparison

  Step comparison using `==` is done based on 'significant' properties. Keywords, being completely interchangeable, do not affect step equality.


  Scenario: Comparison of steps
    Given a model for the following step:
      """
      Given a step
      """
    And a model for the following step:
      """
      When a step
      """
    And a model for the following step:
      """
      Then a step
      """
    When the models are compared
    Then all of them are equivalent
    But none of the models are equivalent with a model for the following step:
      """
      And a step
        | plus this table |
      """
