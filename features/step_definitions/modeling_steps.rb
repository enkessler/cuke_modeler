Given(/^the models provided by CukeModeler/) do
  @available_model_classes = Array.new.tap do |classes|
    CukeModeler.constants.each do |constant|
      if CukeModeler.const_get(constant).is_a?(Class)
        classes << CukeModeler.const_get(constant) if CukeModeler.const_get(constant).ancestors.include?(CukeModeler::ModelElement)
      end
    end
  end
end

When(/^the model is output as a string$/) do |code_text|
  @output = eval(code_text)
end

And(/^a (?:background|feature|scenario|tag) model based on that gherkin$/) do |code_text|
  code_text.gsub!('<source_text>', "'#{@source_text}'")

  eval(code_text)
end

When(/^the (?:background|scenario|tag)'s (?:source line|name|description|steps) (?:is|are) requested$/) do |code_text|
  @result = eval(code_text)
end

