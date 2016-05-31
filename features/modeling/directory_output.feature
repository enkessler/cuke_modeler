Feature: Directory output

  A directory model's string output is simply the file path of the directory that it models.


  Scenario: Output of a directory
    Given a directory model based on "some_directory"
    When it is outputted
    Then the following text is provided:
      """
      <path_to>/some_directory
      """
