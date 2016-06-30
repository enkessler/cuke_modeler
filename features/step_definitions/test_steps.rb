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
