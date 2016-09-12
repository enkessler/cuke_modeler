require "#{File.dirname(__FILE__)}/../spec_helper"


describe 'Directory, Integration' do

  let(:clazz) { CukeModeler::Directory }


  describe 'common behavior' do

    it_should_behave_like 'a model, integration'

  end


  describe 'unique behavior' do


    describe 'modeling directories' do


      context 'with an existing directory' do

        let(:directory_path) { "#{@default_file_directory}/test_directory" }
        let(:directory) { clazz.new(directory_path) }

        before(:each) do
          FileUtils.mkdir(directory_path)
        end


        it 'models the path of the directory' do
          expect(directory.path).to eq(directory_path)
        end

        it 'models the name of the directory' do
          name = File.basename(directory_path)

          expect(directory.name).to eq(name)
        end


        context 'with both files and feature files' do

          let(:feature_files) { ['test_file_1.feature', 'test_file_2.feature'] }
          let(:non_feature_files) { ['random.file'] }

          before(:each) do
            feature_files.each do |file_name|
              # Some versions of Gherkin require feature content to be present in feature files
              File.open("#{directory_path}/#{file_name}", "w") { |file|
                file.puts('Feature: Test feature')
              }
            end

            non_feature_files.each do |file_name|
              FileUtils.touch("#{directory_path}/#{file_name}")
            end
          end


          it 'models the feature files contained in the directory' do
            modeled_files = directory.feature_files.collect { |file| file.name }

            expect(modeled_files).to match_array(feature_files)
          end

          it 'does not model non-feature files contained in the directory' do
            modeled_files = directory.feature_files.collect { |file| file.name }

            non_feature_files.all? do |file|
              expect(modeled_files).to_not include(file)
            end
          end

        end


        context 'with no feature files' do

          before(:each) do
            FileUtils.rm(Dir.glob("#{directory_path}/*"))
          end


          it 'models the feature files contained in the directory' do
            modeled_files = directory.feature_files.collect { |file| file.name }

            expect(modeled_files).to eq([])
          end

        end


        context 'with a nested directory' do

          let(:nested_directories) { ['nested_directory_1', 'nested_directory_2'] }

          before(:each) do
            nested_directories.each do |nested_directory|
              FileUtils.mkdir("#{directory_path}/#{nested_directory}")
            end
          end

          it 'models the directories in the directory' do
            modeled_directories = directory.directories.collect { |nested_directory| nested_directory.name }

            expect(modeled_directories).to match_array(nested_directories)
          end

        end


        context 'with no directories' do

          before(:each) do
            FileUtils.rm_r(Dir.glob("#{directory_path}/*"))
          end


          it 'models the directories contained in the directory' do
            modeled_directories = directory.directories.collect { |nested_directory| nested_directory.name }

            expect(modeled_directories).to eq([])
          end

        end

      end


      context 'with a non-existing directory' do

        let(:directory_path) { "#{@default_file_directory}/test_directory" }

        before(:each) do
          FileUtils.remove_dir(directory_path, true)
        end


        it 'cannot model a non-existent directory' do
          expect { clazz.new(directory_path) }.to raise_error(ArgumentError)
        end

      end

    end


    it 'properly sets its child models' do
      nested_directory = "#{@default_file_directory}/nested_directory"
      file_path = "#{@default_file_directory}/#{@default_feature_file_name}"

      FileUtils.mkdir(nested_directory)
      File.open(file_path, "w") { |file|
        file.puts('Feature: Test feature')
      }

      directory = clazz.new(@default_file_directory)
      nested_directory = directory.directories.first
      file = directory.feature_files.first

      expect(nested_directory.parent_model).to equal(directory)
      expect(file.parent_model).to equal(directory)
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


    describe 'directory output' do

      context 'from source text' do

        let(:directory_path) { "#{@default_file_directory}/test_directory" }
        let(:directory) { clazz.new(directory_path) }

        before(:each) do
          FileUtils.mkdir(directory_path)
        end


        it 'can output a directory' do
          directory_output = directory.to_s

          expect(directory_output).to eq(directory_path)
        end

      end

      it 'can be remade from its own output' do
        source = @default_file_directory
        directory = clazz.new(source)

        directory_output = directory.to_s
        remade_directory_output = clazz.new(directory_output).to_s

        expect(remade_directory_output).to eq(directory_output)
      end

    end

  end

end
