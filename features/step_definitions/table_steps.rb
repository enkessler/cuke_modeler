Then /^(?:the )?(?:feature "([^"]*)" )?(?:test(?: "([^"]*)")? )?(?:step(?: "([^"]*)") )?table has the following contents:$/ do |file, test, step, contents|
  file ||= 1
  test ||= 1
  step ||= 1

  expected = contents.raw

  @parsed_files[file - 1].feature.tests[test - 1].steps[step - 1].block.row_elements.collect { |row| row.cells }.should == expected
  # todo - remove once #contents is no longer supported
  @parsed_files[file - 1].feature.tests[test - 1].steps[step - 1].block.contents.should == expected
end

Then /^(?:the )?(?:feature "([^"]*)" )?(?:test(?: "([^"]*)")? )?(?:step(?: "([^"]*)") )?table correctly stores its underlying implementation$/ do |file, test, step|
  file ||= 1
  test ||= 1
  step ||= 1

  raw_element = @parsed_files[file - 1].feature.tests[test - 1].steps[step - 1].block.raw_element

  if Gem.loaded_specs['gherkin'].version.version[/^3|4/]
    expect(raw_element).to have_key(:rows)
  else
    raw_element.is_a?(Array).should be_true
    raw_element.each { |row| row.has_key?('cells').should be_true }
  end
end

Given(/^a table row element$/) do
  @element = CukeModeler::TableRow.new
end

When(/^the table row element has no cells$/) do
  @element.cells = []
end

Given(/^a table row element based on the following gherkin:$/) do |row_text|
  @element = CukeModeler::TableRow.new(row_text)
end

Then(/^the table row has convenient output$/) do
  @parsed_files.first.feature.tests.first.steps.first.block.row_elements.first.method(:to_s).owner.should == CukeModeler::TableRow
end

Given(/^a table element$/) do
  @element = CukeModeler::Table.new
end

When(/^the table element has no rows$/) do
  @element.row_elements = []
end

Then(/^the table has convenient output$/) do
  @parsed_files.first.feature.tests.first.steps.first.block.method(:to_s).owner.should == CukeModeler::Table
end

Given(/^a table element based on the following gherkin:$/) do |table_text|
  @element = CukeModeler::Table.new(table_text)
end
