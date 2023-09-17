require_relative '../../../../../environments/rspec_env'


RSpec.describe 'Row, Unit', unit_test: true do

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

    it 'contains cells' do
      cells = [:cell_1, :cell_2]
      everything = cells

      row.cells = cells

      expect(row.children).to match_array(everything)
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

      describe 'inspection' do

        it "can inspect a row that doesn't have cells (empty)" do
          row.cells  = []
          row_output = row.inspect

          expect(row_output).to eq('#<CukeModeler::Row:<object_id> @cells: []>'
                                     .sub('<object_id>', row.object_id.to_s))
        end

        it "can inspect a row that doesn't have cells (nil)" do
          row.cells  = nil
          row_output = row.inspect

          expect(row_output).to eq('#<CukeModeler::Row:<object_id> @cells: nil>'
                                     .sub('<object_id>', row.object_id.to_s))
        end

      end


      describe 'stringification' do

        context 'from abstract instantiation' do

          let(:row) { clazz.new }


          describe 'edge cases' do

            # These cases would not produce valid Gherkin and so don't have any useful output
            # but they need to at least not explode

            # The minimal row case
            it 'can stringify an empty row' do
              expect { row.to_s }.to_not raise_error
            end

          end

        end

      end

    end

  end

end
