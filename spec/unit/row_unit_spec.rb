require 'spec_helper'

SimpleCov.command_name('Row') unless RUBY_VERSION.to_s < '1.9.0'

describe 'Row, Unit' do

  let(:clazz) { CukeModeler::Row }
  let(:row) { clazz.new }


  describe 'common behavior' do

    it_should_behave_like 'a nested element'
    it_should_behave_like 'a bare bones element'
    it_should_behave_like 'a prepopulated element'
    it_should_behave_like 'a sourced element'
    it_should_behave_like 'a raw element'

  end


  describe 'unique behavior' do

    it 'can be parsed from stand alone text' do
      source = '| a | row |'

      expect { @element = clazz.new(source) }.to_not raise_error

      # Sanity check in case instantiation failed in a non-explosive manner
      @element.cells.should == ['a', 'row']
    end

    it 'provides a descriptive filename when being parsed from stand alone text' do
      source = " |bad |row| text| \n @foo "

      expect { clazz.new(source) }.to raise_error(/'cuke_modeler_stand_alone_row\.feature'/)
    end

    it 'stores the original data generated by the parsing adapter', :gherkin4 => true do
      example_row = clazz.new("| a | row |")
      raw_data = example_row.raw_element

      expect(raw_data.keys).to match_array([:type, :location, :cells])
      expect(raw_data[:type]).to eq(:TableRow)
    end

    it 'stores the original data generated by the parsing adapter', :gherkin3 => true do
      example_row = clazz.new("| a | row |")
      raw_data = example_row.raw_element

      expect(raw_data.keys).to match_array([:type, :location, :cells])
      expect(raw_data[:type]).to eq('TableRow')
    end

    it 'stores the original data generated by the parsing adapter', :gherkin2 => true do
      example_row = clazz.new("| a | row |")
      raw_data = example_row.raw_element

      expect(raw_data.keys).to match_array(['cells', 'line', 'id'])
      expect(raw_data['cells']).to eq(['a', 'row'])
    end

    it 'has cells - #cells' do
      row.should respond_to(:cells)
    end

    it 'can get and set its cells - #cells, #cells=' do
      expect(row).to respond_to(:cells=)

      row.cells = :some_cells
      row.cells.should == :some_cells
      row.cells = :some_other_cells
      row.cells.should == :some_other_cells
    end

    it 'starts with no cells' do
      row.cells.should == []
    end

    describe 'row output edge cases' do

      it 'is a String' do
        row.to_s.should be_a(String)
      end


      context 'a new row object' do

        let(:row) { clazz.new }


        it 'can output an empty row' do
          expect { row.to_s }.to_not raise_error
        end

      end

    end

  end

end
