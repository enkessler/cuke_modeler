require 'spec_helper'

SimpleCov.command_name('Scenario') unless RUBY_VERSION.to_s < '1.9.0'

describe 'Scenario, Integration' do

  let(:clazz) { CukeModeler::Scenario }


  describe 'common behavior' do

    it_should_behave_like 'a modeled element, integration'

  end

  describe 'unique behavior' do

    it 'properly sets its child elements' do
      source = ['@a_tag',
                'Scenario: Test scenario',
                '  * a step']
      source = source.join("\n")

      scenario = clazz.new(source)
      step = scenario.steps.first
      tag = scenario.tags.first

      step.parent_element.should equal scenario
      tag.parent_element.should equal scenario
    end


    describe 'getting ancestors' do

      before(:each) do
        source = ['Feature: Test feature',
                  '',
                  '  Scenario: Test test',
                  '    * a step']
        source = source.join("\n")

        file_path = "#{@default_file_directory}/scenario_test_file.feature"
        File.open(file_path, 'w') { |file| file.write(source) }
      end

      let(:directory) { CukeModeler::Directory.new(@default_file_directory) }
      let(:scenario) { directory.feature_files.first.features.first.tests.first }


      it 'can get its directory' do
        ancestor = scenario.get_ancestor(:directory)

        ancestor.should equal directory
      end

      it 'can get its feature file' do
        ancestor = scenario.get_ancestor(:feature_file)

        ancestor.should equal directory.feature_files.first
      end

      it 'can get its feature' do
        ancestor = scenario.get_ancestor(:feature)

        ancestor.should equal directory.feature_files.first.features.first
      end

      it 'returns nil if it does not have the requested type of ancestor' do
        ancestor = scenario.get_ancestor(:test)

        ancestor.should be_nil
      end


      describe 'comparison' do

        it 'is equal to a background with the same steps' do
          source = "Scenario:
                      * step 1
                      * step 2"
          scenario = clazz.new(source)

          source = "Background:
                      * step 1
                      * step 2"
          background_1 = CukeModeler::Background.new(source)

          source = "Background:
                      * step 2
                      * step 1"
          background_2 = CukeModeler::Background.new(source)


          expect(scenario).to eq(background_1)
          expect(scenario).to_not eq(background_2)
        end

        it 'is equal to a scenario with the same steps' do
          source = "Scenario:
                      * step 1
                      * step 2"
          scenario_1 = clazz.new(source)

          source = "Scenario:
                      * step 1
                      * step 2"
          scenario_2 = clazz.new(source)

          source = "Scenario:
                      * step 2
                      * step 1"
          scenario_3 = clazz.new(source)


          expect(scenario_1).to eq(scenario_2)
          expect(scenario_1).to_not eq(scenario_3)
        end

        it 'is equal to an outline with the same steps' do
          source = "Scenario:
                      * step 1
                      * step 2"
          scenario = clazz.new(source)

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


          expect(scenario).to eq(outline_1)
          expect(scenario).to_not eq(outline_2)
        end

      end


      describe 'scenario output edge cases' do

        context 'a new scenario object' do

          let(:scenario) { clazz.new }


          it 'can output a scenario that has only tags' do
            scenario.tags = [CukeModeler::Tag.new]

            expect { scenario.to_s }.to_not raise_error
          end

          it 'can output a scenario that has only steps' do
            scenario.steps = [CukeModeler::Step.new]

            expect { scenario.to_s }.to_not raise_error
          end

        end

      end

    end

  end

end
