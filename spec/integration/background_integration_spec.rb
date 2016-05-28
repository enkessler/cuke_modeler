require 'spec_helper'

SimpleCov.command_name('Background') unless RUBY_VERSION.to_s < '1.9.0'

describe 'Background, Integration' do

  let(:clazz) { CukeModeler::Background }


  describe 'common behavior' do

    it_should_behave_like 'a modeled element, integration'

  end

  describe 'unique behavior' do

    it 'properly sets its child elements' do
      source = ['  Background: Test background',
                '    * a step']
      source = source.join("\n")

      background = clazz.new(source)
      step = background.steps.first

      expect(step.parent_model).to equal(background)
    end

    describe 'getting ancestors' do

      before(:each) do
        source = ['Feature: Test feature',
                  '',
                  '  Background: Test background',
                  '    * a step:']
        source = source.join("\n")

        file_path = "#{@default_file_directory}/background_test_file.feature"
        File.open(file_path, 'w') { |file| file.write(source) }
      end

      let(:directory) { CukeModeler::Directory.new(@default_file_directory) }
      let(:background) { directory.feature_files.first.feature.background }


      it 'can get its directory' do
        ancestor = background.get_ancestor(:directory)

        expect(ancestor).to equal(directory)
      end

      it 'can get its feature file' do
        ancestor = background.get_ancestor(:feature_file)

        expect(ancestor).to equal(directory.feature_files.first)
      end

      it 'can get its feature' do
        ancestor = background.get_ancestor(:feature)

        expect(ancestor).to equal(directory.feature_files.first.feature)
      end

      it 'returns nil if it does not have the requested type of ancestor' do
        ancestor = background.get_ancestor(:example)

        expect(ancestor).to be_nil
      end

    end


    describe 'comparison' do

      it 'is equal to a background with the same steps' do
        source = "Background:
                    * step 1
                    * step 2"
        background_1 = clazz.new(source)

        source = "Background:
                    * step 1
                    * step 2"
        background_2 = clazz.new(source)

        source = "Background:
                    * step 2
                    * step 1"
        background_3 = clazz.new(source)


        expect(background_1).to eq(background_2)
        expect(background_1).to_not eq(background_3)
      end

      it 'is equal to a scenario with the same steps' do
        source = "Background:
                    * step 1
                    * step 2"
        background = clazz.new(source)

        source = "Scenario:
                    * step 1
                    * step 2"
        scenario_1 = CukeModeler::Scenario.new(source)

        source = "Scenario:
                    * step 2
                    * step 1"
        scenario_2 = CukeModeler::Scenario.new(source)


        expect(background).to eq(scenario_1)
        expect(background).to_not eq(scenario_2)
      end

      it 'is equal to an outline with the same steps' do
        source = "Background:
                    * step 1
                    * step 2"
        background = clazz.new(source)

        source = "Scenario Outline:
                    * step 1
                    * step 2
                  Examples:
                    | param |
                    | value |"
        outline_1 = CukeModeler::Outline.new(source)

        source = "Scenario Outline:
                    * step 2
                    * step 1
                  Examples:
                    | param |
                    | value |"
        outline_2 = CukeModeler::Outline.new(source)


        expect(background).to eq(outline_1)
        expect(background).to_not eq(outline_2)
      end

    end


    describe 'background output edge cases' do

      context 'a new background object' do

        let(:background) { clazz.new }


        it 'can output a background that has only steps' do
          background.steps = [CukeModeler::Step.new]

          expect { background.to_s }.to_not raise_error
        end

      end

    end

  end

end
