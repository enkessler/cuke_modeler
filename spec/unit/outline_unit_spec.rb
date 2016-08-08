require 'spec_helper'


describe 'Outline, Unit' do

  let(:clazz) { CukeModeler::Outline }
  let(:outline) { clazz.new }


  describe 'common behavior' do

    it_should_behave_like 'a modeled element'
    it_should_behave_like 'a named element'
    it_should_behave_like 'a described element'
    it_should_behave_like 'a stepped element'
    it_should_behave_like 'a tagged element'
    it_should_behave_like 'a sourced element'
    it_should_behave_like 'a parsed element'

  end


  describe 'unique behavior' do

    it 'has examples' do
      expect(outline).to respond_to(:examples)
    end

    it 'can change its examples' do
      expect(outline).to respond_to(:examples=)

      outline.examples = :some_examples
      expect(outline.examples).to eq(:some_examples)
      outline.examples = :some_other_examples
      expect(outline.examples).to eq(:some_other_examples)
    end


    describe 'abstract instantiation' do

      context 'a new outline object' do

        let(:outline) { clazz.new }


        it 'starts with no examples' do
          expect(outline.examples).to eq([])
        end

      end

    end

    it 'contains steps, examples, and tags' do
      tags = [:tag_1, :tagt_2]
      steps = [:step_1, :step_2, :step_3]
      examples = [:example_1, :example_2, :example_3]
      everything = steps + examples + tags

      outline.steps = steps
      outline.examples = examples
      outline.tags = tags

      expect(outline.children).to match_array(everything)
    end


    describe 'comparison' do

      it 'can gracefully be compared to other types of objects' do
        # Some common types of object
        [1, 'foo', :bar, [], {}].each do |thing|
          expect { outline == thing }.to_not raise_error
          expect(outline == thing).to be false
        end
      end

    end


    describe 'outline output' do

      it 'is a String' do
        expect(outline.to_s).to be_a(String)
      end


      context 'from abstract instantiation' do

        let(:outline) { clazz.new }


        it 'can output an empty outline' do
          expect { outline.to_s }.to_not raise_error
        end

        it 'can output an outline that has only a name' do
          outline.name = 'a name'

          expect { outline.to_s }.to_not raise_error
        end

        it 'can output an outline that has only a description' do
          outline.description = 'a description'

          expect { outline.to_s }.to_not raise_error
        end

      end

    end

  end

end
