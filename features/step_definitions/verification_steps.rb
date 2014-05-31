Then(/^the following text is provided:$/) do |expected_text|
  expected_text.sub!('path_to', @default_file_directory)

  @output.should == expected_text
end

Then(/^the text provided is "(.*)"$/) do |text_string|
  @output.should == text_string.gsub('\n', "\n")
end
