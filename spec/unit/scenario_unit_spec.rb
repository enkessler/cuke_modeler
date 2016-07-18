require 'spec_helper'


describe 'Scenario, Unit' do

  let(:clazz) { CukeModeler::Scenario }
  let(:scenario) { clazz.new }


  describe 'common behavior' do

    it_should_behave_like 'a modeled element'
    it_should_behave_like 'a named element'
    it_should_behave_like 'a described element'
    it_should_behave_like 'a stepped element'
    it_should_behave_like 'a tagged element'
    it_should_behave_like 'a sourced element'
    it_should_behave_like 'a raw element'

  end


  describe 'unique behavior' do

    it 'can be instantiated with the minimum viable Gherkin' do
      source = 'Scenario:'

      expect { clazz.new(source) }.to_not raise_error
    end

    it 'provides a descriptive filename when being parsed from stand alone text' do
      source = "bad scenario text \n Scenario:\n And a step\n @foo "

      expect { clazz.new(source) }.to raise_error(/'cuke_modeler_stand_alone_scenario\.feature'/)
    end

    it 'trims whitespace from its source description' do
      source = ['Scenario:',
                '  ',
                '        description line 1',
                '',
                '   description line 2',
                '     description line 3               ',
                '',
                '',
                '',
                '  * a step']
      source = source.join("\n")

      scenario = clazz.new(source)
      description = scenario.description.split("\n")

      expect(description).to eq(['     description line 1',
                                 '',
                                 'description line 2',
                                 '  description line 3'])
    end

    it 'contains steps and tags' do
      tags = [:tag_1, :tag_2]
      steps = [:step_1, :step_2]
      everything = steps + tags

      scenario.steps = steps
      scenario.tags = tags

      expect(scenario.children).to match_array(everything)
    end


    describe 'model population' do

      context 'from source text' do

        context 'a filled scenario' do

          let(:source_text) { "Scenario: Scenario name

                               Scenario description.

                             Some more.
                                 Even more." }
          let(:scenario) { clazz.new(source_text) }


          it "models the scenario's name" do
            expect(scenario.name).to eq('Scenario name')
          end

          it "models the scenario's description" do
            description = scenario.description.split("\n")

            expect(description).to eq(['  Scenario description.',
                                       '',
                                       'Some more.',
                                       '    Even more.'])
          end

        end

        context 'an empty scenario' do

          let(:source_text) { 'Scenario:' }
          let(:scenario) { clazz.new(source_text) }

          it "models the scenario's name" do
            expect(scenario.name).to eq('')
          end

          it "models the scenario's description" do
            expect(scenario.description).to eq('')
          end

        end

      end

    end


    describe 'comparison' do

      it 'can gracefully be compared to other types of objects' do
        # Some common types of object
        [1, 'foo', :bar, [], {}].each do |thing|
          expect { scenario == thing }.to_not raise_error
          expect(scenario == thing).to be false
        end
      end

    end


    describe 'scenario output' do

      it 'is a String' do
        scenario.to_s.should be_a(String)
      end


      context 'from source text' do

        it 'can output an empty scenario' do
          source = ['Scenario:']
          source = source.join("\n")
          scenario = clazz.new(source)

          scenario_output = scenario.to_s.split("\n")

          expect(scenario_output).to eq(['Scenario:'])
        end

        it 'can output a scenario that has a name' do
          source = ['Scenario: test scenario']
          source = source.join("\n")
          scenario = clazz.new(source)

          scenario_output = scenario.to_s.split("\n")

          expect(scenario_output).to eq(['Scenario: test scenario'])
        end

        it 'can output a scenario that has a description' do
          source = ['Scenario:',
                    'Some description.',
                    'Some more description.']
          source = source.join("\n")
          scenario = clazz.new(source)

          scenario_output = scenario.to_s.split("\n")

          expect(scenario_output).to eq(['Scenario:',
                                         '',
                                         'Some description.',
                                         'Some more description.'])
        end

      end


      context 'from abstract instantiation' do

        let(:scenario) { clazz.new }


        it 'can output an empty scenario' do
          expect { scenario.to_s }.to_not raise_error
        end

        it 'can output a scenario that has only a name' do
          scenario.name = 'a name'

          expect { scenario.to_s }.to_not raise_error
        end

        it 'can output a scenario that has only a description' do
          scenario.description = 'a description'

          expect { scenario.to_s }.to_not raise_error
        end

      end

    end

  end

end
