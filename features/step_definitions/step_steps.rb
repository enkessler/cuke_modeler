Then /^(?:the )?(?:feature "([^"]*)" )?test(?: "([^"]*)")? step(?: "([^"]*)")? keyword is "([^"]*)"$/ do |file, test, step, keyword|
  file ||= 1
  test ||= 1
  step ||= 1

  expected = keyword
  actual = @parsed_files[file - 1].feature.tests[test - 1].steps[step - 1].keyword

  assert(actual == expected, "Expected: #{expected}\n but was: #{actual}")
end

Then /^(?:the )?(?:feature "([^"]*)" )?(?:test(?: "([^"]*)")? )?step(?: "([^"]*)")? has the following block:$/ do |file, test, step, block|
  file ||= 1
  test ||= 1
  step ||= 1

  expected = block.raw.flatten.collect do |cell_value|
    if cell_value.start_with? "'"
      cell_value.slice(1..cell_value.length - 2)
    else
      cell_value
    end
  end

  actual = @parsed_files[file - 1].feature.tests[test - 1].steps[step - 1].block.flatten

  assert(actual == expected, "Expected: #{expected}\n but was: #{actual}")
end

Then /^(?:the )?(?:feature "([^"]*)" )?(?:test(?: "([^"]*)")? )?step(?: "([^"]*)")? has no block$/ do |file, test, step|
  file ||= 1
  test ||= 1
  step ||= 1

  expected = nil
  actual = @parsed_files[file - 1].feature.tests[test - 1].steps[step - 1].block

  actual.should == expected
end

Then /^(?:the )?(?:feature "([^"]*)" )?test(?: "([^"]*)")? step(?: "([^"]*)")? text is "([^"]*)"$/ do |file, test, step, text|
  file ||= 1
  test ||= 1
  step ||= 1

  expected = text
  actual = @parsed_files[file - 1].feature.tests[test - 1].steps[step - 1].base

  assert(actual == expected, "Expected: #{expected}\n but was: #{actual}")
end

Then /^(?:the )?(?:feature "([^"]*)" )?test(?: "([^"]*)")? step(?: "([^"]*)")? arguments are:$/ do |file, test, step, arguments|
  file ||= 1
  test ||= 1
  step ||= 1

  expected = arguments.raw.flatten
  actual = @parsed_files[file - 1].feature.tests[test - 1].steps[step - 1].arguments

  assert(actual == expected, "Expected: #{expected}\n but was: #{actual}")
end

Then /^(?:the )?(?:feature "([^"]*)" )?test(?: "([^"]*)")? step(?: "([^"]*)")? has no arguments$/ do |file, test, step|
  file ||= 1
  test ||= 1
  step ||= 1

  expected = []
  actual = @parsed_files[file - 1].feature.tests[test - 1].steps[step - 1].arguments

  assert(actual == expected, "Expected: #{expected}\n but was: #{actual}")
end

Then /^(?:the )?(?:feature "([^"]*)" )?(?:test(?: "([^"]*)")? )?step(?: "([^"]*)")? has a "([^"]*)"$/ do |file, test, step, type|
  file ||= 1
  test ||= 1
  step ||= 1

  case type
    when 'doc string'
      expected = CukeModeler::DocString
    when 'table'
      expected = CukeModeler::Table
    else
      raise(ArgumentError, "Unknown block type: #{type}")
  end

  actual = @parsed_files[file - 1].feature.tests[test - 1].steps[step - 1].block.class

  actual.should == expected
end

Then /^(?:the )?(?:feature "([^"]*)" )?(?:test(?: "([^"]*)")? )?step(?: "([^"]*)")? source line is "([^"]*)"$/ do |file, test, step, line_number|
  file ||= 1
  test ||= 1
  step ||= 1

  expected = line_number.to_i
  actual = @parsed_files[file - 1].feature.tests[test - 1].steps[step - 1].source_line

  actual.should == expected
end

Then /^(?:the )?(?:feature "([^"]*)" )?test(?: "([^"]*)")? step(?: "([^"]*)")? correctly stores its underlying implementation$/ do |file, test, step|
  file ||= 1
  test ||= 1
  step ||= 1

  raw_element = @parsed_files[file - 1].feature.tests[test - 1].steps[step - 1].raw_element

  if Gem.loaded_specs['gherkin'].version.version[/^3|4/]
    raw_element.has_key?(:keyword).should be_true
  else
    raw_element.has_key?('keyword').should be_true
  end
end

Then /^(?:the )?(?:feature "([^"]*)" )?(?:test(?: "([^"]*)")? )?step(?: "([^"]*)")? table row(?: "([^"]*)")? is found to have the following properties:$/ do |file, test, step, row, properties|
  file ||= 1
  test ||= 1
  step ||= 1
  row ||= 1

  properties = properties.rows_hash

  properties.each do |property, value|
    expected = value
    actual = @parsed_files[file - 1].feature.tests[test - 1].steps[step - 1].block.rows[row - 1].send(property.to_sym).to_s

    assert(actual == expected, "Expected: #{expected}\n but was: #{actual}")
  end
end

Then /^(?:the )?(?:feature "([^"]*)" )?(?:test(?: "([^"]*)")? )?step(?: "([^"]*)")? table row(?: "([^"]*)")? correctly stores its underlying implementation$/ do |file, test, step, row|
  file ||= 1
  test ||= 1
  step ||= 1
  row ||= 1

  raw_element = @parsed_files[file - 1].feature.tests[test - 1].steps[step - 1].block.rows[row - 1].raw_element

  if Gem.loaded_specs['gherkin'].version.version[/^3|4/]
    raw_element.has_key?(:cells).should be_true
  else
    raw_element.has_key?('cells').should be_true
  end
end

Then /^(?:the )?(?:feature "([^"]*)" )?(?:test(?: "([^"]*)")? )?step(?: "([^"]*)")? table row(?: "([^"]*)")? cells are as follows:$/ do |file, test, step, row, cells|
  file ||= 1
  test ||= 1
  step ||= 1
  row ||= 1

  expected = cells.raw.flatten
  actual = @parsed_files[file - 1].feature.tests[test - 1].steps[step - 1].block.rows[row - 1].cells

  assert(actual == expected, "Expected: #{expected}\n but was: #{actual}")
end

Given(/^a step element based on the following gherkin:$/) do |step_text|
  @model = CukeModeler::Step.new(step_text)
end

Then(/^the step has convenient output$/) do
  @parsed_files.first.feature.tests.first.steps.first.method(:to_s).owner.should == CukeModeler::Step
end
