require "#{File.dirname(__FILE__)}/../spec_helper"


describe 'Cell, Unit', :unit_test => true do

  let(:clazz) { CukeModeler::Cell }
  let(:cell) { clazz.new }


  describe 'common behavior' do

    it_should_behave_like 'a model'
    it_should_behave_like 'a sourced model'
    it_should_behave_like 'a parsed model'

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
          expect(cell.value).to be_nil
        end

      end

    end


    describe 'cell output' do

      context 'from abstract instantiation' do

        let(:cell) { clazz.new }


        it 'can output an empty cell' do
          expect { cell.to_s }.to_not raise_error
        end

      end

    end

  end

end
