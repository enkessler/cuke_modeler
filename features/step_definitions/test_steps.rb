Then /^(?:the )?(?:feature "([^"]*)" )?test(?: "([^"]*)")? is found to have the following properties:$/ do |file, test, properties|
  file ||= 1
  test ||= 1

  properties = properties.rows_hash

  properties.each do |property, value|
    assert value == @parsed_files[file - 1].feature.tests[test - 1].send(property.to_sym).to_s
  end
end

Then /^(?:the )?(?:feature "([^"]*)" )?test(?: "([^"]*)")? has the following description:$/ do |file, test, text|
  file ||= 1
  test ||= 1

  new_description = @parsed_files[file - 1].feature.tests[test - 1].description_text
  old_description = @parsed_files[file - 1].feature.tests[test - 1].description

  new_description.should == text
  old_description.should == remove_whitespace(text)
end

Then /^(?:the )?(?:feature "([^"]*)" )?test(?: "([^"]*)")? steps are as follows:$/ do |file, test, steps|
  file ||= 1
  test ||= 1

  steps = steps.raw.flatten.collect do |step|
    if step.start_with? "'"
      step.slice(1..step.length - 2)
    else
      step
    end
  end

  actual_steps = Array.new.tap do |steps|
    @parsed_files[file - 1].feature.tests[test - 1].steps.each do |step|
      steps << step.base
    end
  end

  assert actual_steps.flatten == steps
end

Then /^(?:the )?(?:feature "([^"]*)" )?test(?: "([^"]*)")? is found to have the following tags:$/ do |file, test, expected_tags|
  file ||= 1
  test ||= 1

  expected_tags = expected_tags.raw.flatten

  @parsed_files[file - 1].feature.tests[test - 1].tags.should == expected_tags
  @parsed_files[file - 1].feature.tests[test - 1].tag_elements.collect { |tag| tag.name }.should == expected_tags
end

Then /^(?:the )?(?:feature "([^"]*)" )?test(?: "([^"]*)")? is found to have the following applied tags:$/ do |file, test, expected_tags|
  file ||= 1
  test ||= 1

  expected_tags = expected_tags.raw.flatten

  @parsed_files[file - 1].feature.tests[test - 1].applied_tags.should == expected_tags
  @parsed_files[file - 1].feature.tests[test - 1].applied_tag_elements.collect { |tag| tag.name }.should == expected_tags
end

Then /^(?:the )?(?:feature "([^"]*)" )?test(?: "([^"]*)")? step "([^"]*)" has the following block:$/ do |file, test, step, block|
  file ||= 1
  test ||= 1

  block = block.raw.flatten.collect do |line|
    if line.start_with? "'"
      line.slice(1..line.length - 2)
    else
      line
    end
  end

  assert @parsed_files[file - 1].feature.tests[test - 1].steps[step - 1].block == block
end

Then /^(?:the )?(?:feature "([^"]*)" )?test(?: "([^"]*)")? is equal to test "([^"]*)"$/ do |file, first_test, second_test|
  file ||= 1
  first_test ||= 1

  expected = true
  actual = @parsed_files[file - 1].feature.tests[first_test - 1] == @parsed_files[file - 1].feature.tests[second_test - 1]

  assert(actual == expected, "Expected: #{expected}\n but was: #{actual}")
end

Then /^(?:the )?(?:feature "([^"]*)" )?test(?: "([^"]*)")? is not equal to test "([^"]*)"$/ do |file, first_test, second_test|
  file ||= 1
  first_test ||= 1

  assert @parsed_files[file - 1].feature.tests[first_test - 1] != @parsed_files[file - 1].feature.tests[second_test - 1]
end

Then /^(?:the )?(?:feature "([^"]*)" )?test(?: "([^"]*)")? correctly stores its underlying implementation$/ do |file, test|
  file ||= 1
  test ||= 1

  raw_element = @parsed_files[file - 1].feature.tests[test - 1].raw_element

  if Gem.loaded_specs['gherkin'].version.version[/^3|4/]
    expected = ['Scenario', 'Scenario Outline']
    actual = raw_element[:keyword]
  else
    expected = ['Scenario', 'Scenario Outline']
    actual = raw_element['keyword']
  end

  expected.include?(actual).should be_true
end

Then(/^the scenario has convenient output$/) do
  @parsed_files.first.feature.tests.first.method(:to_s).owner.should == CukeModeler::Scenario
end

Given(/^a scenario element based on the following gherkin:$/) do |scenario_text|
  @element = CukeModeler::Scenario.new(scenario_text)
end
