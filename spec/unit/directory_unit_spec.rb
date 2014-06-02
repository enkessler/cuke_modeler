require 'spec_helper'

SimpleCov.command_name('Directory') unless RUBY_VERSION.to_s < '1.9.0'

describe 'Directory, Unit' do

  clazz = CukeModeler::Directory

  it_should_behave_like 'a nested element', clazz
  it_should_behave_like 'a containing element', clazz
  it_should_behave_like 'a bare bones element', clazz
  it_should_behave_like 'a prepopulated element', clazz

  before(:each) do
    @directory = clazz.new
  end

  it 'cannot model a non-existent directory' do
    path = "#{@default_file_directory}/missing_directory"

    expect { CukeModeler::Directory.new(path) }.to raise_error(ArgumentError)
  end

  it 'knows the name of the directory that it is modeling' do
    path = "#{@default_file_directory}"

    directory = CukeModeler::Directory.new(path)

    directory.name.should == 'temp_files'
  end

  it 'knows the path of the directory that it is modeling' do
    path = "#{@default_file_directory}"

    directory = CukeModeler::Directory.new(path)

    directory.path.should == path
  end

  it 'has feature files - #feature_files' do
    @directory.should respond_to(:feature_files)
  end

  it 'can get and set its feature files - #feature_files, #feature_files=' do
    @directory.feature_files = :some_feature_files
    @directory.feature_files.should == :some_feature_files
    @directory.feature_files = :some_other_feature_files
    @directory.feature_files.should == :some_other_feature_files
  end

  it 'knows how many feature files it has - #feature_file_count' do
    @directory.feature_files = [:file_1, :file_2, :file_3]

    @directory.feature_file_count.should == 3
  end

  it 'has directories - #directories' do
    @directory.should respond_to(:directories)
  end

  it 'can get and set its directories - #directories, #directories=' do
    @directory.directories = :some_directories
    @directory.directories.should == :some_directories
    @directory.directories = :some_other_directories
    @directory.directories.should == :some_other_directories
  end

  it 'knows how many directories it has - #directory_count' do
    @directory.directories = [:directory_1, :directory_2, :directory_3]

    @directory.directory_count.should == 3
  end

  it 'starts with no feature files or directories' do
    @directory.feature_files.should == []
    @directory.directories.should == []
  end

  it 'contains feature files and directories' do
    directories = [:directory_1, :directory_2, :directory_3]
    files = [:file_1, :file_2, :file_3]
    everything = files + directories

    @directory.directories = directories
    @directory.feature_files = files

    @directory.contains.should =~ everything
  end

  context 'directory output edge cases' do

    it 'is a String' do
      @directory.to_s.should be_a(String)
    end

    it 'can output an empty directory' do
      expect { @directory.to_s }.to_not raise_error
    end

  end

end

