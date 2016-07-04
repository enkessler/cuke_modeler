Feature: Model structure

When modeling an existing test suite, that suite is parsed and models are created for each piece of the
suite. These models form a nested structure of parent and child models which has the same shape as whatever
portion of the suite that they represent (see the documentation for specific models for details).

However, all models can also be used in an 'abstract' manner. That is, they can be created without any input
(such as a file path or snippet of Gherkin) that would normally be used for determining their structure and
properties. In these cases, their parent/child relationships and properties can be set directly rather than
being populated dynamically based on an actual test suite.


  Scenario: Creating abstract models
    Given the models provided by CukeModeler
    Then  all of them can be created without further context
      """
        abstract_model = <model_class>.new
      """

  Scenario: Nesting models
    Given the models provided by CukeModeler
    Then  all of them can contain other models
      """
        child_model = <model_class>.new
        parent_model = <model_class>.new

        parent_model.children << child_model
      """
    And   all of them can be contained inside of another model
      """
        child_model = <model_class>.new
        parent_model = <model_class>.new

        child_model.parent_model = parent_model
      """

  Scenario: Accessing the parsing data

  Note: Directory and feature file models do not store any parsing data because parsing Gherkin source text
  does not come into play until the feature level of modeling.

    Given the models provided by CukeModeler
    Then  all of them provide access to the parsing data that was used to create them
      """
        model = <model_class>.new(<source_text>)

        model.raw_element
      """
