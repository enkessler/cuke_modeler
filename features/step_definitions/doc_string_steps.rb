Then /^(?:the )?(?:feature "([^"]*)" )?(?:test(?: "([^"]*)")? )?(?:step(?: "([^"]*)") )?doc string content type is "([^"]*)"$/ do |file, test, step, type|
  file ||= 1
  test ||= 1
  step ||= 1

  expected = type
  actual = @parsed_files[file - 1].feature.tests[test - 1].steps[step - 1].block.content_type

  assert(actual == expected, "Expected: #{expected}\n but was: #{actual}")
end

Then /^(?:the )?(?:feature "([^"]*)" )?(?:test(?: "([^"]*)")? )?(?:step(?: "([^"]*)") )?doc string has no content type$/ do |file, test, step|
  file ||= 1
  test ||= 1
  step ||= 1

  expected = nil
  actual = @parsed_files[file - 1].feature.tests[test - 1].steps[step - 1].block.content_type

  assert(actual == expected, "Expected: #{expected}\n but was: #{actual}")
end

Then /^(?:the )?(?:feature "([^"]*)" )?(?:test(?: "([^"]*)")? )?(?:step(?: "([^"]*)") )?doc string has the following contents:$/ do |file, test, step, contents|
  file ||= 1
  test ||= 1
  step ||= 1

  @parsed_files[file - 1].feature.tests[test - 1].steps[step - 1].block.contents_text.should == contents
  # Remove once Array contents is no longer supported
  @parsed_files[file - 1].feature.tests[test - 1].steps[step - 1].block.contents.should == contents.split("\n", -1)
end

Then /^(?:the )?(?:feature "([^"]*)" )?(?:test(?: "([^"]*)")? )?(?:step(?: "([^"]*)") )?doc string contents are empty$/ do |file, test, step|
  file ||= 1
  test ||= 1
  step ||= 1

  #todo Remove once Array contents is no longer supported
  @parsed_files[file - 1].feature.tests[test - 1].steps[step - 1].block.contents.should be_empty
  @parsed_files[file - 1].feature.tests[test - 1].steps[step - 1].block.contents_text.should be_empty
end

Then(/^(?:the )?(?:feature "([^"]*)" )?(?:test(?: "([^"]*)")? )?(?:step(?: "([^"]*)") )?doc string correctly stores its underlying implementation$/) do |file, test, step|
  file ||= 1
  test ||= 1
  step ||= 1

  raw_element = @parsed_files[file - 1].feature.tests[test - 1].steps[step - 1].block.raw_element

  if Gem.loaded_specs['gherkin'].version.version[/^3/]
    raw_element.has_key?(:contentType).should be_true
  else
    raw_element.has_key?('content_type').should be_true
  end
end

Then(/^the doc string has convenient output$/) do
  @parsed_files.first.feature.tests.first.steps.first.block.method(:to_s).owner.should == CukeModeler::DocString
end

Given(/^a doc string element based on the following gherkin:$/) do |doc_string_text|
  @element = CukeModeler::DocString.new(doc_string_text)
end

Given(/^a doc string element based on the string "(.*)"$/) do |string|
  @element = CukeModeler::DocString.new(string.gsub('\n', "\n"))
end
