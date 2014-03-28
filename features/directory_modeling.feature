@acceptance
Feature: Directory modeling

  Directories are the top level element of the model tree, containing feature files
  and other subdirectories.


  Background: Test directory setup
    Given a directory "test_directory"
    And the file "test_directory/test_file_1.feature"
    And the file "test_directory/test_file_2.feature"
    And the file "test_directory/random.file"
    And a directory "test_directory/nested_directory"
    When the directory "test_directory" is modeled
    And the directory "test_directory/nested_directory" is modeled


  Scenario: The directory's full path is modeled.
    Then the "path" of directory "test_directory" is "path_to/test_directory"
    Then the "path" of directory "test_directory/nested_directory" is "path_to/test_directory/nested_directory"

  Scenario: The directory's name is modeled.
    Then the "name" of directory "test_directory" is "test_directory"
    Then the "name" of directory "test_directory/nested_directory" is "nested_directory"

  Scenario: The directory's feature files are modeled.
    Then directory "test_directory" contains the following feature files:
      | test_file_1.feature |
      | test_file_2.feature |
    And directory "test_directory/nested_directory" contains no feature files

  Scenario: The directory's directories are modeled.
    Then directory "test_directory" contains the following directories:
      | nested_directory |
    And directory "test_directory/nested_directory" contains no directories

  @redundant
  Scenario Outline: Directory models pass all other specifications
  Exact specifications detailing the API for directory models.
    Given that there are "<additional specifications>" detailing models
    When the those specifications are run
    Then all of those specifications are met
  Examples:
    | additional specifications     |
    | directory_unit_spec.rb        |
    | directory_integration_spec.rb |
