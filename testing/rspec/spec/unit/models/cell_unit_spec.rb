require_relative '../../../../../environments/rspec_env'


RSpec.describe 'Cell, Unit', unit_test: true do

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

    it 'contains nothing' do
      expect(cell.children).to be_empty
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

      describe 'inspection' do

        it "can inspect a cell that doesn't have a value" do
          cell.value  = nil
          cell_output = cell.inspect

          expect(cell_output).to eq('#<CukeModeler::Cell:<object_id> @value: nil>'
                                      .sub('<object_id>', cell.object_id.to_s))
        end

        it 'can inspect a cell that has a value' do
          cell.value  = 'foo'
          cell_output = cell.inspect

          expect(cell_output).to eq('#<CukeModeler::Cell:<object_id> @value: "foo">'
                                      .sub('<object_id>', cell.object_id.to_s))
        end

      end


      describe 'stringification' do

        context 'from abstract instantiation' do

          let(:cell) { clazz.new }


          # The maximal cell case
          it 'can stringify a cell that has only a value' do
            cell.value = 'foo'

            expect(cell.to_s).to eq('foo')
          end


          describe 'edge cases' do

            # These cases would not produce valid Gherkin and so don't have any useful output
            # but they need to at least not explode

            # The minimal cell case
            it 'can stringify an empty cell' do
              expect { cell.to_s }.to_not raise_error
            end

          end

        end

      end

    end

  end

end
