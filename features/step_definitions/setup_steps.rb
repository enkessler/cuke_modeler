Given(/^a directory "([^"]*)"$/) do |partial_directory_path|
  directory_path = "#{@default_file_directory}/#{partial_directory_path}"
  FileUtils.mkpath(directory_path) unless File.exists?(directory_path)
end

When(/^the file "([^"]*)"$/) do |partial_file_path|
  FileUtils.touch("#{@default_file_directory}/#{partial_file_path}")
end

Given(/^the following feature file(?: "([^"]*)")?:$/) do |partial_file_path, file_text|
  partial_file_path ||= @default_file_name

  File.open("#{@default_file_directory}/#{partial_file_path}", 'w') { |file| file.write(file_text) }
end
