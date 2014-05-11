require 'spec_helper'

SimpleCov.command_name('Directory') unless RUBY_VERSION.to_s < '1.9.0'

describe 'Directory, Unit' do

  clazz = CukeModeler::Directory

  describe 'generic tests' do
    it_should_behave_like 'a modeled element', clazz
  end

  describe 'specific tests' do

    before(:each) do
      @directory = clazz.new
    end

    it 'has a path' do
      @directory.should respond_to(:path)
    end

    it 'can change its path' do
      @directory.should respond_to(:path=)

      @directory.path = :some_path
      @directory.path.should == :some_path
      @directory.path = :some_other_path
      @directory.path.should == :some_other_path
    end

    it 'starts with no path' do
      @directory.path.should == ''
    end

    it 'cannot model a non-existent directory' do
      path = "#{@default_file_directory}/missing_directory"

      expect { CukeModeler::Directory.new(path) }.to raise_error(ArgumentError)
    end

    it 'has a name' do
      @directory.should respond_to(:name)
    end

    it 'starts with no name' do
      @directory.name.should == ''
    end

    it 'has feature files' do
      @directory.should respond_to(:feature_files)
    end

    it 'can change its feature files' do
      @directory.should respond_to(:feature_files=)

      @directory.feature_files = :some_feature_files
      @directory.feature_files.should == :some_feature_files
      @directory.feature_files = :some_other_feature_files
      @directory.feature_files.should == :some_other_feature_files
    end

    it 'has directories' do
      @directory.should respond_to(:directories)
    end

    it 'can change its directories' do
      @directory.should respond_to(:directories=)

      @directory.directories = :some_directories
      @directory.directories.should == :some_directories
      @directory.directories = :some_other_directories
      @directory.directories.should == :some_other_directories
    end

    it 'starts with no feature files or directories' do
      @directory.feature_files.should == []
      @directory.directories.should == []
    end

    it 'contains feature files and directories' do
      directories = [:directory_1, :directory_2]
      files = [:file_1, :file_2]
      everything = files + directories

      @directory.directories = directories
      @directory.feature_files = files

      @directory.contains.should =~ everything
    end

    describe 'directory output edge cases' do

      it 'can output an empty directory' do
        expect { clazz.new }.to_not raise_error
      end

    end

  end
end
