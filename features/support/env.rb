unless RUBY_VERSION.to_s < '1.9.0'
  require 'simplecov'
  SimpleCov.command_name('cucumber_tests')
end


require File.dirname(__FILE__) + '/../../lib/cuke_modeler'


Before do
  @default_file_directory = "#{File.dirname(__FILE__)}/../temp_files"

  FileUtils.mkdir(@default_file_directory)
end

After do
  FileUtils.remove_dir(@default_file_directory, true)
end
