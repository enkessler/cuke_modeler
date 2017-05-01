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
    @root_test_directory = Dir.mktmpdir
  rescue => e
    $stdout.puts 'Problem caught in Before hook!'
    $stdout.puts "Type: #{e.class}"
    $stdout.puts "Message: #{e.message}"
  end
end
