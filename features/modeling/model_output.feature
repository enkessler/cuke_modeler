Feature: Model output

  All models can be output in text form, suitable for use in feature files or anything else that 
  uses Gherkin (see the model output documentation for specific models for details).


  Scenario: Outputting a model element
    Given the element models provided by CukeModeler
    Then  all of them can be output as text appropriate to the model type
      """
        model = <model_class>.new
        
        model.to_s
      """
