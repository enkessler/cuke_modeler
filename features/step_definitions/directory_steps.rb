Given(/^a directory model based on "([^"]*)"$/) do |directory_name|
  directory_path = "#{@default_file_directory}/#{directory_name}"
  FileUtils.mkdir(directory_path) unless File.exists?(directory_path)

  @model = CukeModeler::Directory.new(directory_path)
end
