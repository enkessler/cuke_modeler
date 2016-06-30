Then /^(?:the )?(?:feature "([^"]*)" )?test(?: "([^"]*)")? example block(?: "([^"]*)")? rows are as follows:$/ do |file, test, example, rows|
  file ||= 1
  test ||= 1
  example ||= 1

  rows = rows.raw.flatten
  example = @parsed_files[file - 1].feature.tests[test - 1].examples[example - 1]

  expected = rows.collect { |row| row.split(',') }

  actual = example.argument_rows.collect { |row| row.cells }
  assert(actual == expected, "Expected: #{expected}\n but was: #{actual}")
end

When /^(?:the )?(?:feature "([^"]*)" )?test(?: "([^"]*)")? example block(?: "([^"]*)")? has the following rows added to it:$/ do |file, test, example, rows|
  file ||= 1
  test ||= 1
  example ||= 1

  rows = rows.raw.flatten

  rows.each do |row|
    row = row.split(',')
    @parsed_files[file - 1].feature.tests[test - 1].examples[example - 1].add_row(row)
  end
end

When /^(?:the )?(?:feature "([^"]*)" )?test(?: "([^"]*)")? example block(?: "([^"]*)")? has the following rows removed from it:$/ do |file, test, example, rows|
  file ||= 1
  test ||= 1
  example ||= 1

  rows = rows.raw.flatten

  rows.each do |row|
    row = row.split(',')
    @parsed_files[file - 1].feature.tests[test - 1].examples[example - 1].remove_row(row)
  end
end

Then /^(?:the )?(?:feature "([^"]*)" )?test(?: "([^"]*)")? example block(?: "([^"]*)")? has no rows$/ do |file, test, example|
  file ||= 1
  test ||= 1
  example ||= 1

  example = @parsed_files[file - 1].feature.tests[test - 1].examples[example - 1]

  expect(example.argument_rows).to be_empty
end
