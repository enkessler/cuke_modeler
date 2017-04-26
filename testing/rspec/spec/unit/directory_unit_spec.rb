require "#{File.dirname(__FILE__)}/../spec_helper"


describe 'Directory, Unit', :unit_test => true do

  let(:clazz) { CukeModeler::Directory }
  let(:directory) { clazz.new }


  describe 'common behavior' do

    it_should_behave_like 'a model'

  end


  describe 'unique behavior' do

    it 'has a name' do
      expect(directory).to respond_to(:name)
    end

    it 'derives its directory name from its path' do
      directory.path = 'path/to/foo'

      expect(directory.name).to eq('foo')
    end


    describe 'attributes' do

      it 'has a path' do
        expect(directory).to respond_to(:path)
      end

      it 'can change its path' do
        expect(directory).to respond_to(:path=)

        directory.path = :some_path
        expect(directory.path).to eq(:some_path)
        directory.path = :some_other_path
        expect(directory.path).to eq(:some_other_path)
      end

      it 'has feature files' do
        expect(directory).to respond_to(:feature_files)
      end

      it 'can change its feature files' do
        expect(directory).to respond_to(:feature_files=)

        directory.feature_files = :some_feature_files
        expect(directory.feature_files).to eq(:some_feature_files)
        directory.feature_files = :some_other_feature_files
        expect(directory.feature_files).to eq(:some_other_feature_files)
      end

      it 'has directories' do
        expect(directory).to respond_to(:directories)
      end

      it 'can change its directories' do
        expect(directory).to respond_to(:directories=)

        directory.directories = :some_directories
        expect(directory.directories).to eq(:some_directories)
        directory.directories = :some_other_directories
        expect(directory.directories).to eq(:some_other_directories)
      end

    end


    describe 'abstract instantiation' do

      context 'a new directory object' do

        let(:directory) { clazz.new }


        it 'starts with no path' do
          expect(directory.path).to be_nil
        end

        it 'starts with no name' do
          expect(directory.name).to be_nil
        end

        it 'starts with no feature files or directories' do
          expect(directory.feature_files).to eq([])
          expect(directory.directories).to eq([])
        end

      end

    end

    it 'contains feature files and directories' do
      directories = [:directory_1, :directory_2, :directory_3]
      files = [:file_1, :file_2, :file_3]
      everything = files + directories

      directory.directories = directories
      directory.feature_files = files

      expect(directory.children).to match_array(everything)
    end


    describe 'directory output' do

      context 'from abstract instantiation' do

        let(:directory) { clazz.new }


        it 'can output an empty directory' do
          expect { directory.to_s }.to_not raise_error
        end

      end

    end

  end

end
