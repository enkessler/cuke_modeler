require 'spec_helper'


describe 'Row, Unit', :unit_test => true do

  let(:clazz) { CukeModeler::Row }
  let(:row) { clazz.new }


  describe 'common behavior' do

    it_should_behave_like 'a model'
    it_should_behave_like 'a sourced model'
    it_should_behave_like 'a parsed model'

  end


  describe 'unique behavior' do

    it 'has cells' do
      expect(row).to respond_to(:cells)
    end

    it 'can change its cells' do
      expect(row).to respond_to(:cells=)

      row.cells = :some_cells
      expect(row.cells).to eq(:some_cells)
      row.cells = :some_other_cells
      expect(row.cells).to eq(:some_other_cells)
    end


    describe 'abstract instantiation' do

      context 'a new row object' do

        let(:row) { clazz.new }


        it 'starts with no cells' do
          expect(row.cells).to eq([])
        end

      end

    end


    describe 'row output' do

      it 'is a String' do
        expect(row.to_s).to be_a(String)
      end


      context 'from abstract instantiation' do

        let(:row) { clazz.new }


        it 'can output an empty row' do
          expect { row.to_s }.to_not raise_error
        end

      end

    end

  end

end
