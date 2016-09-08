Given(/^a step model based on the following gherkin:$/) do |source_text|
  @model = CukeModeler::Step.new(source_text)
end
