require 'spec_helper'

SimpleCov.command_name('Directory') unless RUBY_VERSION.to_s < '1.9.0'

describe 'Directory, Integration' do

  clazz = CukeModeler::Directory


  it 'cannot model a non-existent directory' do
    path = "#{@default_file_directory}/missing_directory"

    expect { clazz.new(path) }.to raise_error(ArgumentError)
  end

  it 'properly sets its child elements' do
    nested_directory = "#{@default_file_directory}/nested_directory"
    file_path = "#{@default_file_directory}/#{@default_feature_file_name}"

    FileUtils.mkdir(nested_directory)
    File.open(file_path, "w") { |file|
      file.puts('Feature: Test feature')
    }

    directory = clazz.new(@default_file_directory)
    nested_directory = directory.directories.first
    file = directory.feature_files.first

    nested_directory.parent_element.should equal directory
    file.parent_element.should equal directory
  end

  describe 'getting ancestors' do

    before(:each) do
      nested_directory = "#{@default_file_directory}/nested_directory"
      FileUtils.mkdir(nested_directory)

      @directory = clazz.new(@default_file_directory)
      @nested_directory = @directory.directories.first
    end


    it 'can get its directory' do
      ancestor = @nested_directory.get_ancestor(:directory)

      ancestor.should equal @directory
    end

    it 'returns nil if it does not have the requested type of ancestor' do
      ancestor = clazz.new.get_ancestor(:directory)

      ancestor.should be_nil
    end

  end
end
