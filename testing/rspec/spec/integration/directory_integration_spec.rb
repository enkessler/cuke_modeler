require "#{File.dirname(__FILE__)}/../spec_helper"


describe 'Directory, Integration' do

  let(:clazz) { CukeModeler::Directory }


  describe 'common behavior' do

    it_should_behave_like 'a model, integration'

  end


  describe 'unique behavior' do


    describe 'modeling directories' do


      context 'with an existing directory' do

        let(:root_test_path) { Dir.mktmpdir }

        let(:directory_path) { Dir.mktmpdir('nested_directory', root_test_path) }
        let(:directory_model) { clazz.new(directory_path) }


        it 'models the path of the directory' do
          expect(directory_model.path).to eq(directory_path)
        end

        it 'models the name of the directory' do
          name = File.basename(directory_path)

          expect(directory_model.name).to eq(name)
        end


        context 'with both files and feature files' do

          let(:feature_files) { ['test_file_1', 'test_file_2'] }
          let(:non_feature_files) { ['test_file_3'] }

          before(:each) do
            feature_files.each do |file_name|
              # Some versions of Gherkin require feature content to be present in feature files
              CukeModeler::FileHelper.create_feature_file("#{@feature_keyword}: Test feature", file_name, directory_path)
            end

            non_feature_files.each do |file_name|
              CukeModeler::FileHelper.create_file('', file_name, '.file', directory_path)
            end
          end


          it 'models the feature files contained in the directory' do
            modeled_files = directory_model.feature_files.collect { |file| file.name[/test_file_\d/] }

            expect(modeled_files).to match_array(feature_files)
          end

          it 'does not model non-feature files contained in the directory' do
            modeled_files = directory_model.feature_files.collect { |file| file.name[/test_file_\d/] }

            non_feature_files.all? do |file|
              expect(modeled_files).to_not include(file)
            end
          end

        end


        context 'with no feature files' do

          let(:directory_path) { Dir.mktmpdir('empty_directory', root_test_path) }
          let(:directory_model) { clazz.new(directory_path) }


          it 'models the feature files contained in the directory' do
            modeled_files = directory_model.feature_files.collect { |file| file.name }

            expect(modeled_files).to eq([])
          end

        end


        context 'with a nested directory' do

          let(:directory_path) { Dir.mktmpdir('test_directory', root_test_path) }
          let(:directory_model) { clazz.new(directory_path) }

          let(:nested_directories) { ['nested_directory_1', 'nested_directory_2'] }

          before(:each) do
            nested_directories.each do |nested_directory|
              Dir.mktmpdir(nested_directory, directory_path)
            end
          end


          it 'models the directories in the directory' do
            modeled_directories = directory_model.directories.collect { |nested_directory| nested_directory.name[/nested_directory_\d/] }

            expect(modeled_directories).to match_array(nested_directories)
          end

        end


        context 'with no directories' do

          let(:directory_path) { Dir.mktmpdir('empty_directory', root_test_path) }
          let(:directory_model) { clazz.new(directory_path) }


          it 'models the directories contained in the directory' do
            modeled_directories = directory_model.directories.collect { |nested_directory| nested_directory.name }

            expect(modeled_directories).to eq([])
          end

        end

      end


      context 'with a non-existing directory' do

        let(:root_test_path) { Dir.mktmpdir }
        let(:directory_path) { "#{root_test_path}/this_directory_should_not_exist" }


        it 'cannot model a non-existent directory' do
          expect { clazz.new(directory_path) }.to raise_error(ArgumentError)
        end

      end

    end


    it 'properly sets its child models' do
      directory_path = Dir.mktmpdir
      _nested_directory_path = Dir.mktmpdir('nested_directory', directory_path)

      CukeModeler::FileHelper.create_feature_file("#{@feature_keyword}: Test feature", 'test_file', directory_path)


      directory_model = clazz.new(directory_path)
      nested_directory_model = directory_model.directories.first
      file_model = directory_model.feature_files.first

      expect(nested_directory_model.parent_model).to equal(directory_model)
      expect(file_model.parent_model).to equal(directory_model)
    end


    describe 'getting ancestors' do

      before(:each) do
        Dir.mktmpdir('nested_directory', test_directory)
      end

      let(:test_directory) { Dir.mktmpdir }

      let(:directory_model) { clazz.new(test_directory) }
      let(:nested_directory_model) { directory_model.directories.first }


      it 'can get its directory' do
        ancestor = nested_directory_model.get_ancestor(:directory)

        expect(ancestor).to equal(directory_model)
      end

      it 'returns nil if it does not have the requested type of ancestor' do
        ancestor = nested_directory_model.get_ancestor(:example)

        expect(ancestor).to be_nil
      end

    end


    describe 'directory output' do

      context 'from source text' do

        let(:directory_path) { Dir.mktmpdir }
        let(:directory_model) { clazz.new(directory_path) }


        it 'can output a directory' do
          directory_output = directory_model.to_s

          expect(directory_output).to eq(directory_path)
        end

      end

      it 'can be remade from its own output' do
        source = Dir.mktmpdir
        directory = clazz.new(source)

        directory_output = directory.to_s
        remade_directory_output = clazz.new(directory_output).to_s

        expect(remade_directory_output).to eq(directory_output)
      end

    end

  end

end
