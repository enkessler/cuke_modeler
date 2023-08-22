Feature: Directory output

  A directory model's string output is simply the file path of the directory that it models and its
  most relevant attribute for inspection is the path of the directory that it models.


  Background:
    Given a directory model based on "some_directory"


  Scenario: Stringify a directory model
    When the model is output as a string
      """
      @model.to_s
      """
    Then the following text is provided:
      """
      <path_to>/some_directory
      """
    And the output can be used to make an equivalent model
      """
      CukeModeler::Directory.new(@model.to_s)
      """

  Scenario: Inspect a directory model
    When the model is inspected
      """
      @model.inspect
      """
    Then the following text is provided:
      """
      #<CukeModeler::Directory:<object_id> @path: "<path_to>/some_directory">
      """
