Then /^the tags collected from (?:feature "([^"]*)" )?test "([^"]*)" are as follows:$/ do |file, test, expected_tags|
  file ||= 1
  expected_tags = expected_tags.raw.flatten

  CukeModeler::World.tags_in(@parsed_files[file - 1].feature.tests[test - 1]).sort.should == expected_tags.sort
  CukeModeler::World.tag_elements_in(@parsed_files[file - 1].feature.tests[test - 1]).collect { |tag| tag.name }.sort.should == expected_tags.sort
end

Then /^the tags collected from feature "([^"]*)" are as follows:$/ do |file, expected_tags|
  file ||= 1
  expected_tags = expected_tags.raw.flatten

  CukeModeler::World.tags_in(@parsed_files[file - 1].feature).sort == expected_tags.sort.should
  CukeModeler::World.tag_elements_in(@parsed_files[file - 1].feature).collect { |tag| tag.name }.sort.should == expected_tags.sort
end

Then /^the tags collected from file "([^"]*)" are as follows:$/ do |file, expected_tags|
  file ||= 1
  expected_tags = expected_tags.raw.flatten

  CukeModeler::World.tags_in(@parsed_files[file - 1]).sort.should == expected_tags.sort
  CukeModeler::World.tag_elements_in(@parsed_files[file - 1]).collect { |tag| tag.name }.sort.should == expected_tags.sort
end

Then /^the tags collected from directory are as follows:$/ do |expected_tags|
  expected_tags = expected_tags.raw.flatten

  CukeModeler::World.tags_in(@parsed_directories.last).sort.should == expected_tags.sort
  CukeModeler::World.tag_elements_in(@parsed_directories.last).collect { |tag| tag.name }.sort.should == expected_tags.sort
end

Then /^the(?: "([^"]*)")? steps collected from feature "([^"]*)" background are as follows:$/ do |defined, file, steps|
  file ||= 1
  steps = steps.raw.flatten
  container = @parsed_files[file - 1].feature.background

  case defined
    when 'defined'
      expected_steps = CukeModeler::World.defined_steps_in(container)
    when 'undefined'
      expected_steps = CukeModeler::World.undefined_steps_in(container)
    else
      expected_steps = CukeModeler::World.steps_in(container)
  end

  assert expected_steps.collect { |step| step.base }.flatten.sort == steps.sort
end

Then /^the(?: "([^"]*)")? steps collected from feature "([^"]*)" test "([^"]*)" are as follows:$/ do |defined, file, test, steps|
  file ||= 1
  steps = steps.raw.flatten
  container = @parsed_files[file - 1].feature.tests[test - 1]

  case defined
    when 'defined'
      expected_steps = CukeModeler::World.defined_steps_in(container)
    when 'undefined'
      expected_steps = CukeModeler::World.undefined_steps_in(container)
    else
      expected_steps = CukeModeler::World.steps_in(container)
  end

  assert expected_steps.collect { |step| step.base }.flatten.sort == steps.sort
end

When /^the(?: "([^"]*)")? steps collected from (?:the )?feature(?: "([^"]*)")? are as follows:$/ do |defined, file, steps|
  file ||= 1
  container = @parsed_files[file - 1].feature

  case defined
    when 'defined'
      actual_steps = CukeModeler::World.defined_steps_in(container)
    when 'undefined'
      actual_steps = CukeModeler::World.undefined_steps_in(container)
    else
      actual_steps = CukeModeler::World.steps_in(container)
  end

  expected = steps.raw.flatten.sort
  actual = actual_steps.collect { |step| step.base }.flatten.sort

  assert(actual == expected, "Expected: #{expected}\n but was: #{actual}")
end

When /^the(?: "([^"]*)")? steps collected from (?:the )?file(?: "([^"]*)")? are as follows:$/ do |defined, file, steps|
  file ||= 1
  container = @parsed_files[file - 1]

  case defined
    when 'defined'
      actual_steps = CukeModeler::World.defined_steps_in(container)
    when 'undefined'
      actual_steps = CukeModeler::World.undefined_steps_in(container)
    else
      actual_steps = CukeModeler::World.steps_in(container)
  end

  expected = steps.raw.flatten.sort
  actual = actual_steps.collect { |step| step.base }.flatten.sort

  assert(actual == expected, "Expected: #{expected}\n but was: #{actual}")
end

When /^the(?: "([^"]*)")? steps collected from the directory are as follows:$/ do |defined, steps|
  container = @parsed_directories.last

  case defined
    when 'defined'
      actual_steps = CukeModeler::World.defined_steps_in(container)
    when 'undefined'
      actual_steps = CukeModeler::World.undefined_steps_in(container)
    else
      actual_steps = CukeModeler::World.steps_in(container)
  end

  expected = steps.raw.flatten.sort
  actual = actual_steps.collect { |step| step.base }.flatten.sort

  assert(actual == expected, "Expected: #{expected}\n but was: #{actual}")
end

Then /^the tests collected from feature "([^"]*)" are as follows:$/ do |file, tests|
  file ||= 1

  actual_tests = CukeModeler::World.tests_in(@parsed_files[file - 1].feature).collect { |test| test.name }

  assert actual_tests.flatten.sort == tests.raw.flatten.sort
end

Then /^the tests collected from file "([^"]*)" are as follows:$/ do |file, tests|
  file ||= 1

  actual_tests = CukeModeler::World.tests_in(@parsed_files[file - 1]).collect { |test| test.name }

  assert actual_tests.flatten.sort == tests.raw.flatten.sort
end

Then /^the tests collected from directory "([^"]*)" are as follows:$/ do |directory, tests|
  directory ||= 1

  actual_tests = CukeModeler::World.tests_in(@parsed_directories[directory - 1]).collect { |test| test.name }

  assert actual_tests.flatten.sort == tests.raw.flatten.sort
end

Then /^the features collected from file "([^"]*)" are as follows:$/ do |file, features|
  file ||= 1

  actual_features = CukeModeler::World.features_in(@parsed_files[file - 1]).collect { |feature| feature.name }

  assert actual_features.flatten.sort == features.raw.flatten.sort
end

Then /^the features collected from directory "([^"]*)" are as follows:$/ do |directory, features|
  directory ||= 1

  expected = features.raw.flatten.sort
  actual = CukeModeler::World.features_in(@parsed_directories[directory - 1]).collect { |feature| feature.name }

  assert(actual == expected, "Expected: #{expected}\n but was: #{actual}")
end

Then /^the files collected from directory "([^"]*)" are as follows:$/ do |directory, files|
  directory ||= 1

  actual_files = CukeModeler::World.feature_files_in(@parsed_directories[directory - 1]).collect { |file| file.name }

  expected = files.raw.flatten.sort
  actual = actual_files.flatten.sort

  assert(actual == expected, "Expected: #{expected}\n but was: #{actual}")
end

Then /^the directories collected from directory "([^"]*)" are as follows:$/ do |directory, directories|
  directory ||= 1

  expected = directories.raw.flatten.sort
  actual = CukeModeler::World.directories_in(@parsed_directories[directory - 1]).collect { |sub_directory| sub_directory.name }

  assert(actual == expected, "Expected: #{expected}\n but was: #{actual}")
end

Then /^there are no directories collected from directory "([^"]*)"$/ do |directory|
  directory ||= 1

  actual_directories = CukeModeler::World.directories_in(@parsed_directories[directory - 1])

  assert actual_directories.flatten == []
end
