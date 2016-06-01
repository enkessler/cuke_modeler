Given(/^a directory model based on "([^"]*)"$/) do |directory_name|
  directory_path = "#{@default_file_directory}/#{directory_name}"
  FileUtils.mkdir(directory_path) unless File.exists?(directory_path)

  @model = CukeModeler::Directory.new(directory_path)
end

Given(/^a directory is modeled$/) do |code_text|
  code_text.gsub!('<path_to>', @default_file_directory)

  eval(code_text)
end

When(/^the directory's (?:path|name|feature files|directories) (?:is|are) requested$/) do |code_text|
  @result = eval(code_text)
end
