require 'spec_helper'

SimpleCov.command_name('Cell') unless RUBY_VERSION.to_s < '1.9.0'


describe 'Cell, Integration' do

  let(:clazz) { CukeModeler::Cell }


  describe 'common behavior' do

    it_should_behave_like 'a modeled element, integration'

  end


  describe 'unique behavior' do

    describe 'getting ancestors' do

      before(:each) do
        source = ['Feature: Test feature',
                  '',
                  '  Scenario: Test test',
                  '    * a step',
                  '      | a value |']
        source = source.join("\n")

        file_path = "#{@default_file_directory}/cell_test_file.feature"
        File.open(file_path, 'w') { |file| file.write(source) }
      end

      let(:directory) { CukeModeler::Directory.new(@default_file_directory) }
      let(:cell) { directory.feature_files.first.feature.tests.first.steps.first.block.rows.first.cells.first }


      it 'can get its directory' do
        ancestor = cell.get_ancestor(:directory)

        expect(ancestor).to equal(directory)
      end

      it 'can get its feature file' do
        ancestor = cell.get_ancestor(:feature_file)

        expect(ancestor).to equal(directory.feature_files.first)
      end

      it 'can get its feature' do
        ancestor = cell.get_ancestor(:feature)

        expect(ancestor).to equal(directory.feature_files.first.feature)
      end

      context 'a cell that is part of an outline' do

        before(:each) do
          source = 'Feature: Test feature
                      
                      Scenario Outline: Test outline
                        * a step
                      Examples:
                        | param |
                        | value |'

          file_path = "#{@default_file_directory}/cell_test_file.feature"
          File.open(file_path, 'w') { |file| file.write(source) }
        end

        let(:directory) { CukeModeler::Directory.new(@default_file_directory) }
        let(:cell) { directory.feature_files.first.feature.tests.first.examples.first.rows.first.cells.first }


        it 'can get its outline' do
          ancestor = cell.get_ancestor(:test)

          expect(ancestor).to equal(directory.feature_files.first.feature.tests.first)
        end

        it 'can get its example' do
          ancestor = cell.get_ancestor(:example)

          expect(ancestor).to equal(directory.feature_files.first.feature.tests.first.examples.first)
        end

        it 'can get its row' do
          ancestor = cell.get_ancestor(:row)

          expect(ancestor).to equal(directory.feature_files.first.feature.tests.first.examples.first.rows.first)
        end

      end


      context 'a cell that is part of a scenario' do

        before(:each) do
          source = 'Feature: Test feature

                      Scenario: Test test
                        * a step:
                          | a | table |'

          file_path = "#{@default_file_directory}/cell_test_file.feature"
          File.open(file_path, 'w') { |file| file.write(source) }
        end

        let(:directory) { CukeModeler::Directory.new(@default_file_directory) }
        let(:cell) { directory.feature_files.first.feature.tests.first.steps.first.block.rows.first.cells.first }


        it 'can get its scenario' do
          ancestor = cell.get_ancestor(:test)

          expect(ancestor).to equal(directory.feature_files.first.feature.tests.first)
        end

      end

      context 'a cell that is part of a background' do

        before(:each) do
          source = 'Feature: Test feature

                      Background: Test background
                        * a step:
                          | a | table |'

          file_path = "#{@default_file_directory}/cell_test_file.feature"
          File.open(file_path, 'w') { |file| file.write(source) }
        end

        let(:directory) { CukeModeler::Directory.new(@default_file_directory) }
        let(:cell) { directory.feature_files.first.feature.background.steps.first.block.rows.first.cells.first }


        it 'can get its background' do
          ancestor = cell.get_ancestor(:test)

          expect(ancestor).to equal(directory.feature_files.first.feature.background)
        end

      end

      context 'a cell that is part of a step' do

        before(:each) do
          source = 'Feature: Test feature

                      Scenario: Test test
                        * a step:
                          | a | table |'

          file_path = "#{@default_file_directory}/cell_test_file.feature"
          File.open(file_path, 'w') { |file| file.write(source) }
        end

        let(:directory) { CukeModeler::Directory.new(@default_file_directory) }
        let(:cell) { directory.feature_files.first.feature.tests.first.steps.first.block.rows.first.cells.first }


        it 'can get its step' do
          ancestor = cell.get_ancestor(:step)

          expect(ancestor).to equal(directory.feature_files.first.feature.tests.first.steps.first)
        end

        it 'can get its table' do
          ancestor = cell.get_ancestor(:table)

          expect(ancestor).to equal(directory.feature_files.first.feature.tests.first.steps.first.block)
        end

        it 'can get its row' do
          ancestor = cell.get_ancestor(:row)

          expect(ancestor).to equal(directory.feature_files.first.feature.tests.first.steps.first.block.rows.first)
        end

      end

      it 'returns nil if it does not have the requested type of ancestor' do
        ancestor = cell.get_ancestor(:example)

        expect(ancestor).to be_nil
      end

    end


    describe 'model population' do

      context 'from source text' do

        it "models the cell's source line" do
          source_text = 'Feature:

                           Scenario:
                             * a step
                               | value |'
          cell = CukeModeler::Feature.new(source_text).tests.first.steps.first.block.rows.first.cells.first

          expect(cell.source_line).to eq(5)
        end

      end

    end


    describe 'cell output' do

      it 'can be remade from its own output' do
        source = 'a complex \| cell'
        cell = clazz.new(source)

        cell_output = cell.to_s
        remade_cell_output = clazz.new(cell_output).to_s

        expect(remade_cell_output).to eq(cell_output)
      end

    end

  end

end
