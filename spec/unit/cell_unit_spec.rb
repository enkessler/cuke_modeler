require 'spec_helper'


describe 'Cell, Unit' do

  let(:clazz) { CukeModeler::Cell }
  let(:cell) { clazz.new }


  describe 'common behavior' do

    it_should_behave_like 'a modeled element'
    it_should_behave_like 'a sourced element'
    it_should_behave_like 'a parsed element'

  end


  describe 'unique behavior' do

    it 'has a value' do
      expect(cell).to respond_to(:value)
    end

    it 'can change its value' do
      expect(cell).to respond_to(:value=)

      cell.value = :some_value
      expect(cell.value).to eq(:some_value)
      cell.value = :some_other_value
      expect(cell.value).to eq(:some_other_value)
    end


    describe 'abstract instantiation' do

      context 'a new cell object' do

        let(:cell) { clazz.new }


        it 'starts with no value' do
          expect(cell.value).to eq('')
        end

      end

    end


    describe 'cell output' do

      it 'is a String' do
        expect(cell.to_s).to be_a(String)
      end


      context 'from abstract instantiation' do

        let(:cell) { clazz.new }


        it 'can output an empty cell' do
          expect { cell.to_s }.to_not raise_error
        end

      end

    end

  end

end
