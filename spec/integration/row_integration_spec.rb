require 'spec_helper'


describe 'Row, Integration' do

  let(:clazz) { CukeModeler::Row }


  describe 'common behavior' do

    it_should_behave_like 'a modeled element, integration'

  end

  describe 'unique behavior' do

    it 'properly sets its child elements' do
      source = '| cell 1 | cell 2 |'

      row = clazz.new(source)
      cell_1 = row.cells.first
      cell_2 = row.cells.last

      expect(cell_1.parent_model).to equal(row)
      expect(cell_2.parent_model).to equal(row)
    end


    describe 'getting ancestors' do

      before(:each) do
        source = ['Feature: Test feature',
                  '',
                  '  Scenario Outline: Test test',
                  '    * a step',
                  '  Examples: Test example',
                  '    | a param |',
                  '    | a value |']
        source = source.join("\n")

        file_path = "#{@default_file_directory}/row_test_file.feature"
        File.open(file_path, 'w') { |file| file.write(source) }
      end

      let(:directory) { CukeModeler::Directory.new(@default_file_directory) }
      let(:row) { directory.feature_files.first.feature.tests.first.examples.first.rows.first }


      it 'can get its directory' do
        ancestor = row.get_ancestor(:directory)

        expect(ancestor).to equal(directory)
      end

      it 'can get its feature file' do
        ancestor = row.get_ancestor(:feature_file)

        expect(ancestor).to equal(directory.feature_files.first)
      end

      it 'can get its feature' do
        ancestor = row.get_ancestor(:feature)

        expect(ancestor).to equal(directory.feature_files.first.feature)
      end

      context 'a row that is part of an outline' do

        before(:each) do
          source = 'Feature: Test feature
                      
                      Scenario Outline: Test outline
                        * a step
                      Examples:
                        | param |
                        | value |'

          file_path = "#{@default_file_directory}/step_test_file.feature"
          File.open(file_path, 'w') { |file| file.write(source) }
        end

        let(:directory) { CukeModeler::Directory.new(@default_file_directory) }
        let(:row) { directory.feature_files.first.feature.tests.first.examples.first.rows.first }


        it 'can get its outline' do
          ancestor = row.get_ancestor(:outline)

          expect(ancestor).to equal(directory.feature_files.first.feature.tests.first)
        end

        it 'can get its example' do
          ancestor = row.get_ancestor(:example)

          expect(ancestor).to equal(directory.feature_files.first.feature.tests.first.examples.first)
        end

      end

      it 'returns nil if it does not have the requested type of ancestor' do
        ancestor = row.get_ancestor(:table)

        expect(ancestor).to be_nil
      end

    end


    describe 'model population' do

      context 'from source text' do

        it "models the row's source line" do
          source_text = "Feature: Test feature

                           Scenario Outline: Test outline
                             * a step
                           Examples:
                             | param |
                             | value |"
          row = CukeModeler::Feature.new(source_text).tests.first.examples.first.rows.first

          expect(row.source_line).to eq(6)
        end

      end

    end


    describe 'row output' do

      it 'can be remade from its own output' do
        source = ['| value1 | value2 |']
        source = source.join("\n")
        row = clazz.new(source)

        row_output = row.to_s
        remade_row_output = clazz.new(row_output).to_s

        expect(remade_row_output).to eq(row_output)
      end

    end

  end

end
