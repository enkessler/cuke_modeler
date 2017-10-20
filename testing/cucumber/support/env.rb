unless RUBY_VERSION.to_s < '1.9.0'
  require 'simplecov'
  SimpleCov.command_name('cucumber_tests')
end

require 'test/unit/assertions'
include Test::Unit::Assertions

this_dir = File.dirname(__FILE__)

require "#{this_dir}/../../../lib/cuke_modeler"

require "#{this_dir}/../../file_helper"


Before do
  begin
    @root_test_directory = CukeModeler::FileHelper.create_directory
  rescue => e
    $stdout.puts 'Problem caught in Before hook!'
    $stdout.puts "Type: #{e.class}"
    $stdout.puts "Message: #{e.message}"
  end
end

at_exit {
  CukeModeler::FileHelper.created_directories.each do |dir_path|
    FileUtils.remove_entry(dir_path, true)
  end
}
