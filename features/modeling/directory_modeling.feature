Feature: Directory modeling


  Directory models are the top level element of a model tree. They expose several attributes of the directory that they
  represent, as well as containing models for any feature files or subdirectories that are present in the directory
  that they represent.


  Background: An existing test suite
    Given the directory "test_directory"
    And the file "test_directory/test_file_1.feature"
    And the file "test_directory/test_file_2.feature"
    And the file "test_directory/random.file"
    And the directory "test_directory/nested_directory"


  Scenario: Modeling a directory's path
    Given a directory is modeled
      """
        @model = CukeModeler::Directory.new('<path_to>/test_directory')
      """
    When the directory's path is requested
      """
        @model.path
      """
    Then the model returns "path_to/test_directory"

  Scenario: Modeling a directory's name
    Given a directory is modeled
      """
        @model = CukeModeler::Directory.new('<path_to>/test_directory')
      """
    When the directory's name is requested
      """
        @model.name
      """
    Then the model returns "test_directory"

  Scenario: Modeling a directory's feature files

  Note: Files that are not .feature files are not modeled

    Given a directory is modeled
      """
        @model = CukeModeler::Directory.new('<path_to>/test_directory')
      """
    When the directory's feature files are requested
      """
        @model.feature_files
      """
    Then the model returns models for the following feature files:
      | test_file_1.feature |
      | test_file_2.feature |

  Scenario: Modeling a directory's directories
    Given a directory is modeled
      """
        @model = CukeModeler::Directory.new('<path_to>/test_directory')
      """
    When the directory's directories are requested
      """
        @model.directories
      """
    Then the model returns models for the following directories:
      | nested_directory |
