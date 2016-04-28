require 'spec_helper'

SimpleCov.command_name('Directory') unless RUBY_VERSION.to_s < '1.9.0'

describe 'Directory, Integration' do

  let(:clazz) { CukeModeler::Directory }

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

    expect(nested_directory.parent_element).to equal(directory)
    expect(file.parent_element).to equal(directory)
  end

  describe 'getting ancestors' do

    before(:each) do
      FileUtils.mkdir("#{@default_file_directory}/nested_directory")
    end

    let(:directory) { clazz.new(@default_file_directory) }
    let(:nested_directory) { directory.directories.first }


    it 'can get its directory' do
      ancestor = nested_directory.get_ancestor(:directory)

      expect(ancestor).to equal(directory)
    end

    it 'returns nil if it does not have the requested type of ancestor' do
      ancestor = nested_directory.get_ancestor(:example)

      expect(ancestor).to be_nil
    end

  end
end
