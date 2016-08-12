require 'spec_helper'


describe 'Tag, Unit' do

  let(:clazz) { CukeModeler::Tag }
  let(:model) { clazz.new }


  describe 'common behavior' do

    it_should_behave_like 'a model'
    it_should_behave_like 'a sourced model'
    it_should_behave_like 'a parsed model'

  end


  describe 'unique behavior' do

    it 'has a name' do
      expect(model).to respond_to(:name)
    end

    it 'can change its name' do
      expect(model).to respond_to(:name=)

      model.name = :some_name
      expect(model.name).to eq(:some_name)
      model.name = :some_other_name
      expect(model.name).to eq(:some_other_name)
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
      expect(model.to_s).to be_a(String)
    end


    context 'from abstract instantiation' do

      let(:tag) { clazz.new }


      it 'can output an empty tag' do
        expect { tag.to_s }.to_not raise_error
      end

    end

  end

end
