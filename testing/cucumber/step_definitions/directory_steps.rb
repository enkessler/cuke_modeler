Given(/^a directory model based on "([^"]*)"$/) do |directory_name|
  directory_path = "#{@root_test_directory}/#{directory_name}"
  FileUtils.mkdir_p(directory_path)

  @model = CukeModeler::Directory.new(directory_path)
end
