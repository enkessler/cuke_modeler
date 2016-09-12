require "#{File.dirname(__FILE__)}/../spec_helper"


describe 'Scenario, Unit', :unit_test => true do

  let(:clazz) { CukeModeler::Scenario }
  let(:scenario) { clazz.new }


  describe 'common behavior' do

    it_should_behave_like 'a model'
    it_should_behave_like 'a named model'
    it_should_behave_like 'a described model'
    it_should_behave_like 'a stepped model'
    it_should_behave_like 'a tagged model'
    it_should_behave_like 'a sourced model'
    it_should_behave_like 'a parsed model'

  end


  describe 'unique behavior' do

    it 'contains steps and tags' do
      tags = [:tag_1, :tag_2]
      steps = [:step_1, :step_2]
      everything = steps + tags

      scenario.steps = steps
      scenario.tags = tags

      expect(scenario.children).to match_array(everything)
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
        expect(scenario.to_s).to be_a(String)
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
