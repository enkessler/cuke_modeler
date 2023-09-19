Given(/^the models provided by CukeModeler/) do
  @available_model_classes = [].tap do |classes|
    CukeModeler.constants.each do |constant|
      next unless CukeModeler.const_get(constant).is_a?(Class) &&
                  CukeModeler.const_get(constant).ancestors.include?(CukeModeler::Model)

      classes << CukeModeler.const_get(constant)
    end
  end
end

When(/^the model is output as a string$/) do |code_text|
  @output = eval(code_text)
end

When(/^the model is inspected$/) do |code_text|
  @output = eval(code_text)
end

When(/^using (?:non-)?verbose inspection$/) do |code_text|
  @output = Hash.new { |hash, key| hash[key] = {} }

  @available_model_classes.each do |clazz|
    code = code_text.sub('<model_class>', clazz.to_s)
                    .gsub('model', '@model') # Changing variable type so that it is available in this step
                                             # definition but without making thing looks weird in the feature file # rubocop:disable Layout/CommentIndentation

    @output[clazz][:output] = eval(code)
    @output[clazz][:model]  = @model
  end
end

And(/^a(?:n)? \w+(?: \w+)? model based on that gherkin$/) do |code_text|
  code_text = code_text.gsub('<source_text>', "'#{@source_text}'")

  eval(code_text)
end

Given(/^(?:a|the) (?:directory|feature file) is modeled$/) do |code_text|
  code_text = code_text.gsub('<path_to>', @root_test_directory)

  eval(code_text)
end

When(/^the \w+(?: \w+)?'s \w+(?: \w+)? (?:is|are) requested$/) do |code_text|
  @result = eval(code_text)
end

Given(/^a model for the following background:$/) do |gherkin_text|
  @models ||= []
  @models << CukeModeler::Background.new(gherkin_text)
end

Given(/^a model for the following scenario:$/) do |gherkin_text|
  @models ||= []
  @models << CukeModeler::Scenario.new(gherkin_text)
end

Given(/^a model for the following outline:$/) do |gherkin_text|
  @models ||= []
  @models << CukeModeler::Outline.new(gherkin_text)
end

Given(/^a model for the following step:$/) do |gherkin_text|
  @models ||= []
  @models << CukeModeler::Step.new(gherkin_text)
end
