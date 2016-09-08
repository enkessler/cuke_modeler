unless RUBY_VERSION.to_s < '1.9.0'
  require 'simplecov'
  SimpleCov.command_name('cucumber_tests')
end

require 'test/unit/assertions'
include Test::Unit::Assertions

this_dir = File.dirname(__FILE__)

require "#{this_dir}/../../lib/cuke_modeler"


Before do
  begin
    @default_file_directory = "#{this_dir}/../temp_files"
    @default_feature_file_name = 'test_feature.feature'

    FileUtils.mkdir(@default_file_directory)
  rescue => e
    $stdout.puts 'Problem caught in Before hook!'
    $stdout.puts "Type: #{e.class}"
    $stdout.puts "Message: #{e.message}"
  end
end

After do
  begin
    FileUtils.remove_dir(@default_file_directory, true)
  rescue => e
    $stdout.puts 'Problem caught in After hook!'
    $stdout.puts "Type: #{e.class}"
    $stdout.puts "Message: #{e.message}"
  end
end


