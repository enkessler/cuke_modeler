unless RUBY_VERSION.to_s < '1.9.0'
  require 'simplecov'
  SimpleCov.command_name('cucumber_tests')
end

require 'test/unit/assertions'
include Test::Unit::Assertions

require File.dirname(__FILE__) + '/../../lib/cuke_modeler'


Before do
  begin
    @default_file_directory = "#{File.dirname(__FILE__)}/../temp_files"
    @default_feature_file_name = 'test_feature.feature'
    @default_step_file_name = 'test_steps.rb'
    @test_file_directory = "#{File.dirname(__FILE__)}/../test_files"
    @test_step_file_location = "#{@default_file_directory}/#{@default_step_file_name}"
    @spec_directory = "#{File.dirname(__FILE__)}/../../spec"

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


