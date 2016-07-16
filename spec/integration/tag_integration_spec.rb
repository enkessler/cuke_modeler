require 'spec_helper'

SimpleCov.command_name('Tag') unless RUBY_VERSION.to_s < '1.9.0'

describe 'Tag, Integration' do

  let(:clazz) { CukeModeler::Tag }


  describe 'common behavior' do

    it_should_behave_like 'a modeled element, integration'

  end

  describe 'unique behavior' do

    describe 'getting ancestors' do

      before(:each) do
        source = ['@feature_tag',
                  'Feature: Test feature',
                  '',
                  '  Scenario Outline: Test test',
                  '    * a step',
                  '',
                  '  @example_tag',
                  '  Examples: Test example',
                  '    | a param |',
                  '    | a value |']
        source = source.join("\n")

        file_path = "#{@default_file_directory}/tag_test_file.feature"
        File.open(file_path, 'w') { |file| file.write(source) }
      end

      let(:directory) { CukeModeler::Directory.new(@default_file_directory) }
      let(:tag) { directory.feature_files.first.feature.tests.first.examples.first.tags.first }
      let(:high_level_tag) { directory.feature_files.first.feature.tags.first }


      it 'can get its directory' do
        ancestor = tag.get_ancestor(:directory)

        ancestor.should equal directory
      end

      it 'can get its feature file' do
        ancestor = tag.get_ancestor(:feature_file)

        ancestor.should equal directory.feature_files.first
      end

      it 'can get its feature' do
        ancestor = tag.get_ancestor(:feature)

        ancestor.should equal directory.feature_files.first.feature
      end

      context 'a tag that is part of a scenario' do

        before(:each) do
          source = 'Feature: Test feature
                      
                      @a_tag
                      Scenario: Test scenario
                        * a step'

          file_path = "#{@default_file_directory}/step_test_file.feature"
          File.open(file_path, 'w') { |file| file.write(source) }
        end

        let(:directory) { CukeModeler::Directory.new(@default_file_directory) }
        let(:tag) { directory.feature_files.first.feature.tests.first.tags.first }


        it 'can get its scenario' do
          ancestor = tag.get_ancestor(:scenario)

          expect(ancestor).to equal(directory.feature_files.first.feature.tests.first)
        end

      end

      context 'a tag that is part of an outline' do

        before(:each) do
          source = 'Feature: Test feature
                      
                      @a_tag
                      Scenario Outline: Test outline
                        * a step
                      Examples:
                        | param |
                        | value |'

          file_path = "#{@default_file_directory}/step_test_file.feature"
          File.open(file_path, 'w') { |file| file.write(source) }
        end

        let(:directory) { CukeModeler::Directory.new(@default_file_directory) }
        let(:tag) { directory.feature_files.first.feature.tests.first.tags.first }


        it 'can get its outline' do
          ancestor = tag.get_ancestor(:outline)

          expect(ancestor).to equal(directory.feature_files.first.feature.tests.first)
        end

      end

      context 'a tag that is part of an example' do

        before(:each) do
          source = 'Feature: Test feature
                      
                      Scenario Outline: Test outline
                        * a step
                      @a_tag
                      Examples:
                        | param |
                        | value |'
          file_path = "#{@default_file_directory}/step_test_file.feature"
          File.open(file_path, 'w') { |file| file.write(source) }
        end

        let(:directory) { CukeModeler::Directory.new(@default_file_directory) }
        let(:tag) { directory.feature_files.first.feature.tests.first.examples.first.tags.first }


        it 'can get its example' do
          ancestor = tag.get_ancestor(:example)

          expect(ancestor).to equal(directory.feature_files.first.feature.tests.first.examples.first)
        end

      end

      it 'returns nil if it does not have the requested type of ancestor' do
        ancestor = high_level_tag.get_ancestor(:example)

        ancestor.should be_nil
      end

    end


    describe 'model population' do

      context 'from source text' do

        it "models the tag's source line" do
          source_text = "Feature:

                           @a_tag
                           Scenario:
                             * step"
          tag = CukeModeler::Feature.new(source_text).tests.first.tags.first

          expect(tag.source_line).to eq(3)
        end

      end

    end


    describe 'tag output' do

      it 'can be remade from its own output' do
        source = '@some_tag'
        tag = clazz.new(source)

        tag_output = tag.to_s
        remade_tag_output = clazz.new(tag_output).to_s

        expect(remade_tag_output).to eq(tag_output)
      end

    end

  end

end
