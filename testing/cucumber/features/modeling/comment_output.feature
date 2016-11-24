Feature: Comment output

  A comment model's string output is a Gherkin representation of itself. As such, output from a comment model can be used as
  input for the same kind of model.


  Scenario: Outputting a comment model
    Given the following gherkin:
      """
      # a comment
      """
    And a comment model based on that gherkin
      """
        @model = CukeModeler::Comment.new(<source_text>)
      """
    When the model is output as a string
      """
        @model.to_s
      """
    Then the following text is provided:
      """
      # a comment
      """
    And the output can be used to make an equivalent model
      """
        CukeModeler::Comment.new(@model.to_s)
      """
