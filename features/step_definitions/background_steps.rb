Then /^the(?: feature "([^"]*)")? background is found to have the following properties:$/ do |file, properties|
  file ||= 1
  properties = properties.rows_hash

  properties.each do |property, expected_value|
    expected = expected_value
    actual = @parsed_files[file - 1].feature.background.send(property.to_sym).to_s

    actual.should == expected
  end
end

Then /^the(?: feature "([^"]*)")? background has the following description:/ do |file, text|
  file ||= 1

  description = @parsed_files[file - 1].feature.background.description

  expect(description).to eq(text)
end

Then /^the(?: feature "([^"]*)")? background's steps are as follows:$/ do |file, steps|
  file ||= 1

  steps = steps.raw.flatten.collect do |step|
    if step.start_with? "'"
      step.slice(1..step.length - 2)
    else
      step
    end
  end

  actual_steps = Array.new.tap do |steps|
    @parsed_files[file - 1].feature.background.steps.each do |step|
      steps << step.base
    end
  end

  expected = steps
  actual = actual_steps.flatten

  assert(actual == expected, "Expected: #{expected}\n but was: #{actual}")
end

When /^step "([^"]*)" of the background (?:of feature "([^"]*)" )?has the following block:$/ do |step, file, block|
  file ||= 1

  block = block.raw.flatten.collect do |line|
    if line.start_with? "'"
      line.slice(1..line.length - 2)
    else
      line
    end
  end

  assert @parsed_files[file - 1].feature.background.steps[step - 1].block == block
end


Then(/^the(?: feature "([^"]*)")? background correctly stores its underlying implementation$/) do |file|
  file ||= 1

  raw_element = @parsed_files[file - 1].feature.background.raw_element

  expected = 'Background'
  if Gem.loaded_specs['gherkin'].version.version[/^3|4/]
    actual = raw_element[:keyword]
  else
    actual = raw_element['keyword']
  end

  assert(actual == expected, "Expected: #{expected}\n but was: #{actual}")
end

Given(/^a background element based on the following gherkin:$/) do |background_text|
  @model = CukeModeler::Background.new(background_text)
end

Then /^the background has convenient output$/ do
  @parsed_files.first.feature.background.method(:to_s).owner.should == CukeModeler::Background
end

When(/^the background's (?:source line|name|description|steps) (?:is|are) requested$/) do |code_text|
  @result = eval(code_text)
end

And(/^the background model of that feature model$/) do |code_text|
  eval(code_text)
end
