Feature: Directory output

  A directory model's string output is simply the file path of the directory that it models. As such, output from a directory model can be used as
  input for the same kind of model.


  Scenario: Outputting a directory model
    Given a directory model based on "some_directory"
    When it is outputted
    Then the following text is provided:
      """
      <path_to>/some_directory
      """
    And the output can be used to make an equivalent model
      """
        CukeModeler::Directory.new(@model.to_s)
      """
