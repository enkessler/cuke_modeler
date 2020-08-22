require "#{File.dirname(__FILE__)}/../../spec_helper"


describe 'Background, Unit', unit_test: true do

  let(:clazz) { CukeModeler::Background }
  let(:background) { clazz.new }


  describe 'common behavior' do

    it_should_behave_like 'a model'
    it_should_behave_like 'a keyworded model'
    it_should_behave_like 'a named model'
    it_should_behave_like 'a described model'
    it_should_behave_like 'a stepped model'
    it_should_behave_like 'a sourced model'
    it_should_behave_like 'a parsed model'

  end


  describe 'unique behavior' do

    it 'contains steps' do
      steps = [:step_1, :step_2]
      everything = steps

      background.steps = steps

      expect(background.children).to match_array(everything)
    end


    describe 'comparison' do

      it 'can gracefully be compared to other types of objects' do
        # Some common types of object
        [1, 'foo', :bar, [], {}].each do |thing|
          expect { background == thing }.to_not raise_error
          expect(background == thing).to be false
        end
      end

    end


    describe 'background output' do

      context 'from abstract instantiation' do

        let(:background) { clazz.new }


        it 'can output an empty background' do
          expect { background.to_s }.to_not raise_error
        end

        it 'can output a background that has only a keyword' do
          background.keyword = 'foo'

          expect(background.to_s).to eq('foo:')
        end

        it 'can output a background that has only a name' do
          background.name = 'a name'

          expect { background.to_s }.to_not raise_error
        end

        it 'can output a background that has only a description' do
          background.description = 'a description'

          expect { background.to_s }.to_not raise_error
        end

      end

    end

  end

end
