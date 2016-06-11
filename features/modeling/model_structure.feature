Feature: Model structure

When modeling an existing test suite, the element models form a nested structure that has the same shape
as whatever portion of the suite that they represent (see the documentation for specific models for details).

However, all models can also be used in an 'abstract' manner. That is, they can be created without any input
(such as a file path or snippet of Gherkin) that would normally be used for determining their structure and
properties. In these cases, their structure and properties can be set directly.


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
