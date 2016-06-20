require 'spec_helper'

SimpleCov.command_name('FeatureFile') unless RUBY_VERSION.to_s < '1.9.0'

describe 'FeatureFile, Integration' do

  let(:clazz) { CukeModeler::FeatureFile }


  describe 'common behavior' do

    it_should_behave_like 'a modeled element, integration'

  end

  describe 'unique behavior' do

    it 'provides its own filename when being parsed' do
      path = "#{@default_file_directory}/#{@default_feature_file_name}"
      File.open(path, "w") { |file| file.puts 'bad feature text' }

      expect { clazz.new(path) }.to raise_error(/'#{path}'/)
    end

    it 'cannot model a non-existent feature file' do
      path = "#{@default_file_directory}/missing_file.txt"

      expect { clazz.new(path) }.to raise_error(ArgumentError)
    end


    describe 'model population' do

      let(:source_text) { "Feature: Test feature" }
      let(:feature_file_path) { "#{@default_file_directory}/#{@default_feature_file_name}" }
      let(:feature_file) { clazz.new(feature_file_path) }

      before(:each) do
        File.open(feature_file_path, "w") { |file| file.puts source_text }
      end

      it "models the feature file's name" do
        expect(feature_file.name).to eq(@default_feature_file_name)
      end

      it "models the feature file's path" do
        expect(feature_file.path).to eq(feature_file_path)
      end

      it "models the feature file's feature" do
        feature_name = feature_file.feature.name

        expect(feature_name).to eq('Test feature')
      end

      context 'an empty feature file' do

        let(:source_text) { '' }
        let(:feature_file_path) { "#{@default_file_directory}/#{@default_feature_file_name}" }
        let(:feature_file) { clazz.new(feature_file_path) }

        before(:each) do
          File.open(feature_file_path, "w") { |file| file.puts source_text }
        end


        it "models the feature file's feature" do
          expect(feature_file.feature).to be_nil
        end

      end

    end

    it 'properly sets its child elements' do
      file_path = "#{@default_file_directory}/#{@default_feature_file_name}"

      File.open(file_path, "w") { |file|
        file.puts('Feature: Test feature')
      }

      file = clazz.new(file_path)
      feature = file.feature

      expect(feature.parent_model).to equal(file)
    end


    describe 'getting ancestors' do

      before(:each) do
        file_path = "#{@default_file_directory}/feature_file_test_file.feature"
        File.open(file_path, 'w') { |file| file.write('Feature: Test feature') }
      end

      let(:directory) { CukeModeler::Directory.new(@default_file_directory) }
      let(:feature_file) { directory.feature_files.first }


      it 'can get its directory' do
        ancestor = feature_file.get_ancestor(:directory)

        expect(ancestor).to equal(directory)
      end

      it 'returns nil if it does not have the requested type of ancestor' do
        ancestor = feature_file.get_ancestor(:example)

        expect(ancestor).to be_nil
      end

    end


    describe 'feature file output' do

      context 'from source text' do

        let(:source_text) { "Feature: Test feature" }
        let(:feature_file_path) { "#{@default_file_directory}/#{@default_feature_file_name}" }
        let(:feature_file) { clazz.new(feature_file_path) }

        before(:each) do
          File.open(feature_file_path, "w") { |file| file.puts source_text }
        end


        it 'can output a feature file' do
          feature_file_output = feature_file.to_s

          expect(feature_file_output).to eq(feature_file_path)
        end

      end

      it 'can be remade from its own output' do
        path = "#{@default_file_directory}/#{@default_feature_file_name}"
        File.open(path, "w") { |file| file.puts "Feature:" }

        source = path
        feature_file = clazz.new(source)

        feature_file_output = feature_file.to_s
        remade_feature_file_output = clazz.new(feature_file_output).to_s

        expect(remade_feature_file_output).to eq(feature_file_output)
      end

    end

  end

end
