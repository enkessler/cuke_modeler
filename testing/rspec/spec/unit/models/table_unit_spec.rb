require "#{File.dirname(__FILE__)}/../../spec_helper"


describe 'Table, Unit', unit_test: true do

  let(:clazz) { CukeModeler::Table }
  let(:table) { clazz.new }


  describe 'common behavior' do

    it_should_behave_like 'a model'
    it_should_behave_like 'a parsed model'
    it_should_behave_like 'a sourced model'

  end


  describe 'unique behavior' do

    it 'has rows' do
      expect(table).to respond_to(:rows)
    end

    it 'can change its rows' do
      expect(table).to respond_to(:rows=)

      table.rows = :some_rows
      expect(table.rows).to eq(:some_rows)
      table.rows = :some_other_rows
      expect(table.rows).to eq(:some_other_rows)
    end


    describe 'abstract instantiation' do

      context 'a new table object' do

        let(:table) { clazz.new }


        it 'starts with no rows' do
          expect(table.rows).to eq([])
        end

      end

    end

    it 'contains rows' do
      rows = [:row_1, :row_2]
      everything = rows

      table.rows = rows

      expect(table.children).to match_array(everything)
    end


    describe 'table output' do

      context 'from abstract instantiation' do

        let(:table) { clazz.new }


        it 'can output an empty table' do
          expect { table.to_s }.to_not raise_error
        end

      end

    end

  end

end
