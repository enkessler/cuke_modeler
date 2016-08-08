require 'spec_helper'


describe 'Tag, Unit' do

  let(:clazz) { CukeModeler::Tag }
  let(:element) { clazz.new }


  describe 'common behavior' do

    it_should_behave_like 'a modeled element'
    it_should_behave_like 'a sourced element'
    it_should_behave_like 'a parsed element'

  end


  describe 'unique behavior' do

    it 'has a name' do
      expect(element).to respond_to(:name)
    end

    it 'can change its name' do
      expect(element).to respond_to(:name=)

      element.name = :some_name
      expect(element.name).to eq(:some_name)
      element.name = :some_other_name
      expect(element.name).to eq(:some_other_name)
    end


    describe 'abstract instantiation' do

      context 'a new tag object' do

        let(:tag) { clazz.new }


        it 'starts with no name' do
          expect(tag.name).to be_nil
        end

      end

    end

  end


  describe 'tag output' do

    it 'is a String' do
      expect(element.to_s).to be_a(String)
    end


    context 'from abstract instantiation' do

      let(:tag) { clazz.new }


      it 'can output an empty tag' do
        expect { tag.to_s }.to_not raise_error
      end

    end

  end

end
