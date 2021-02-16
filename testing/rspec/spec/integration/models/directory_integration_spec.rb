require_relative '../../../../../environments/rspec_env'


RSpec.describe 'Directory, Integration' do

  let(:clazz) { CukeModeler::Directory }


  describe 'common behavior' do

    it_should_behave_like 'a model, integration'

  end


  describe 'unique behavior' do


    describe 'modeling directories' do


      context 'with an existing directory' do

        let(:root_test_path) { CukeModeler::FileHelper.create_directory }

        let(:directory_path) { CukeModeler::FileHelper.create_directory(name: 'nested_directory',
                                                                        directory: root_test_path) }
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
              CukeModeler::FileHelper.create_feature_file(text: "#{FEATURE_KEYWORD}: Test feature",
                                                          name: file_name,
                                                          directory: directory_path)
            end

            non_feature_files.each do |file_name|
              CukeModeler::FileHelper.create_file(text: '',
                                                  name: file_name,
                                                  extension: '.file',
                                                  directory: directory_path)
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

          let(:directory_path) { CukeModeler::FileHelper.create_directory(name: 'empty_directory',
                                                                          directory: root_test_path) }
          let(:directory_model) { clazz.new(directory_path) }


          it 'models the feature files contained in the directory' do
            modeled_files = directory_model.feature_files.map(&:name)

            expect(modeled_files).to eq([])
          end

        end


        context 'with a nested directory' do

          let(:directory_path) { CukeModeler::FileHelper.create_directory(name: 'test_directory',
                                                                          directory: root_test_path) }
          let(:directory_model) { clazz.new(directory_path) }

          let(:nested_directories) { ['nested_directory_1', 'nested_directory_2'] }

          before(:each) do
            nested_directories.each do |nested_directory|
              CukeModeler::FileHelper.create_directory(name: nested_directory, directory: directory_path)
            end
          end


          it 'models the directories in the directory' do
            modeled_directories = directory_model.directories.collect { |nested_directory| nested_directory.name[/nested_directory_\d/] } # rubocop:disable Layout/LineLength

            expect(modeled_directories).to match_array(nested_directories)
          end

        end


        context 'with no directories' do

          let(:directory_path) { CukeModeler::FileHelper.create_directory(name: 'empty_directory',
                                                                          directory: root_test_path) }
          let(:directory_model) { clazz.new(directory_path) }


          it 'models the directories contained in the directory' do
            modeled_directories = directory_model.directories.map(&:name)

            expect(modeled_directories).to eq([])
          end

        end

      end


      context 'with a non-existing directory' do

        let(:root_test_path) { CukeModeler::FileHelper.create_directory }
        let(:directory_path) { "#{root_test_path}/this_directory_should_not_exist" }


        it 'cannot model a non-existent directory' do
          expect { clazz.new(directory_path) }.to raise_error(ArgumentError)
        end

      end

    end


    it 'properly sets its child models' do
      directory_path = CukeModeler::FileHelper.create_directory
      _nested_directory_path = CukeModeler::FileHelper.create_directory(name: 'nested_directory',
                                                                        directory: directory_path)

      CukeModeler::FileHelper.create_feature_file(text: "#{FEATURE_KEYWORD}: Test feature",
                                                  name: 'test_file',
                                                  directory: directory_path)


      directory_model = clazz.new(directory_path)
      nested_directory_model = directory_model.directories.first
      file_model = directory_model.feature_files.first

      expect(nested_directory_model.parent_model).to equal(directory_model)
      expect(file_model.parent_model).to equal(directory_model)
    end


    describe 'getting ancestors' do

      before(:each) do
        CukeModeler::FileHelper.create_directory(name: 'nested_directory', directory: test_directory)
      end

      let(:test_directory) { CukeModeler::FileHelper.create_directory }

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

        let(:directory_path) { CukeModeler::FileHelper.create_directory }
        let(:directory_model) { clazz.new(directory_path) }


        it 'can output a directory' do
          directory_output = directory_model.to_s

          expect(directory_output).to eq(directory_path)
        end

      end

      it 'can be remade from its own output' do
        source = CukeModeler::FileHelper.create_directory
        directory = clazz.new(source)

        directory_output = directory.to_s
        remade_directory_output = clazz.new(directory_output).to_s

        expect(remade_directory_output).to eq(directory_output)
      end

    end

  end

end
