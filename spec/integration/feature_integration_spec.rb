require 'spec_helper'

SimpleCov.command_name('Feature') unless RUBY_VERSION.to_s < '1.9.0'

describe 'Feature, Integration' do

  let(:clazz) { CukeModeler::Feature }
  let(:feature) { clazz.new }


  describe 'unique behavior' do

    it 'properly sets its child elements' do
      source = ['@a_tag',
                'Feature: Test feature',
                '  Background: Test background',
                '  Scenario: Test scenario',
                '  Scenario Outline: Test outline',
                '  Examples: Test Examples',
                '    | param |',
                '    | value |']
      source = source.join("\n")


      feature = clazz.new(source)
      background = feature.background
      scenario = feature.tests[0]
      outline = feature.tests[1]
      tag = feature.tag_elements[0]


      expect(outline.parent_element).to equal(feature)
      expect(scenario.parent_element).to equal(feature)
      expect(background.parent_element).to equal(feature)
      expect(tag.parent_element).to equal(feature)
    end

    it 'can selectively access its scenarios and outlines' do
      scenarios = [CukeModeler::Scenario.new, CukeModeler::Scenario.new]
      outlines = [CukeModeler::Outline.new, CukeModeler::Outline.new]

      feature.tests = scenarios + outlines

      expect(feature.scenarios).to match_array(scenarios)
      expect(feature.outlines).to match_array(outlines)
    end

    it 'knows how many scenarios it has' do
      scenarios = [CukeModeler::Scenario.new, CukeModeler::Scenario.new]
      outlines = [CukeModeler::Outline.new]

      feature.tests = []
      expect(feature.scenario_count).to eq(0)

      feature.tests = scenarios + outlines
      expect(feature.scenario_count).to eq(2)
    end

    it 'knows how many outlines it has' do
      scenarios = [CukeModeler::Scenario.new]
      outlines = [CukeModeler::Outline.new, CukeModeler::Outline.new]

      feature.tests = []
      expect(feature.outline_count).to eq(0)

      feature.tests = scenarios + outlines
      expect(feature.outline_count).to eq(2)
    end

    it 'knows how many test cases it has' do
      source_1 = ['Feature: Test feature']
      source_1 = source_1.join("\n")

      source_2 = ['Feature: Test feature',
                  '  Scenario: Test scenario',
                  '  Scenario Outline: Test outline',
                  '    * a step',
                  '  Examples: Test examples',
                  '    |param|',
                  '    |value_1|',
                  '    |value_2|']
      source_2 = source_2.join("\n")

      feature_1 = clazz.new(source_1)
      feature_2 = clazz.new(source_2)


      expect(feature_1.test_case_count).to eq(0)
      expect(feature_2.test_case_count).to eq(3)
    end


    describe 'getting ancestors' do

      before(:each) do
        source = ['Feature: Test feature']
        source = source.join("\n")

        file_path = "#{@default_file_directory}/feature_test_file.feature"
        File.open(file_path, 'w') { |file| file.write(source) }
      end

      let(:directory) { CukeModeler::Directory.new(@default_file_directory) }
      let(:feature) { directory.feature_files.first.features.first }


      it 'can get its directory' do
        ancestor = feature.get_ancestor(:directory)

        expect(ancestor).to equal(directory)
      end

      it 'can get its feature file' do
        ancestor = feature.get_ancestor(:feature_file)

        expect(ancestor).to equal(directory.feature_files.first)
      end

      it 'returns nil if it does not have the requested type of ancestor' do
        ancestor = feature.get_ancestor(:test)

        expect(ancestor).to be_nil
      end

    end

    describe 'feature output edge cases' do

      context 'a new feature object' do

        let(:feature) { clazz.new }


        it 'can output a feature that has only tag elements' do
          feature.tag_elements = [CukeModeler::Tag.new]

          expect { feature.to_s }.to_not raise_error
        end

        it 'can output a feature that has only a background' do
          feature.background = [CukeModeler::Background.new]

          expect { feature.to_s }.to_not raise_error
        end

        it 'can output a feature that has only scenarios' do
          feature.tests = [CukeModeler::Scenario.new]

          expect { feature.to_s }.to_not raise_error
        end

        it 'can output a feature that has only outlines' do
          feature.tests = [CukeModeler::Outline.new]

          expect { feature.to_s }.to_not raise_error
        end

      end

    end

  end

end
