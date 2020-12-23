require "#{File.dirname(__FILE__)}/../../spec_helper"


describe 'Cell, Integration' do

  let(:clazz) { CukeModeler::Cell }
  let(:minimum_viable_gherkin) { '' }
  let(:maximum_viable_gherkin) { 'a cell' }


  describe 'common behavior' do

    it_should_behave_like 'a model, integration'

  end


  describe 'unique behavior' do

    it 'can be instantiated with the minimum viable Gherkin' do
      expect { clazz.new(minimum_viable_gherkin) }.to_not raise_error
    end

    it 'can parse text that uses a non-default dialect' do
      original_dialect = CukeModeler::Parsing.dialect
      CukeModeler::Parsing.dialect = 'en-au'

      begin
        source_text = 'foo'

        expect { @model = clazz.new(source_text) }.to_not raise_error

        # Sanity check in case modeling failed in a non-explosive manner
        expect(@model.value).to eq('foo')
      ensure
        # Making sure that our changes don't escape a test and ruin the rest of the suite
        CukeModeler::Parsing.dialect = original_dialect
      end
    end

    it 'provides a descriptive filename when being parsed from stand alone text' do
      source = "not a \n cell"

      expect { clazz.new(source) }.to raise_error(/'cuke_modeler_stand_alone_cell\.feature'/)
    end

    describe 'parsing data' do

      context 'with minimum viable Gherkin' do

        let(:source_text) { minimum_viable_gherkin }

        it 'stores the original data generated by the parsing adapter' do
          cell = clazz.new(source_text)
          data = cell.parsing_data

          expect(data.keys).to match_array([:location, :value])
          expect(data[:location][:line]).to eq(5)
        end

      end

      context 'with maximum viable Gherkin' do

        let(:source_text) { maximum_viable_gherkin }

        it 'stores the original data generated by the parsing adapter' do
          cell = clazz.new(source_text)
          data = cell.parsing_data

          expect(data.keys).to match_array([:location, :value])
          expect(data[:value]).to eq('a cell')
        end

      end

    end

    describe 'getting ancestors' do

      before(:each) do
        CukeModeler::FileHelper.create_feature_file(text: source_gherkin,
                                                    name: 'cell_test_file',
                                                    directory: test_directory)
      end


      let(:test_directory) { CukeModeler::FileHelper.create_directory }
      let(:source_gherkin) {
        "#{FEATURE_KEYWORD}: Test feature

           #{SCENARIO_KEYWORD}: Test test
             #{STEP_KEYWORD} a step
               | a value |"
      }

      let(:directory_model) { CukeModeler::Directory.new(test_directory) }
      let(:cell_model) { directory_model.feature_files.first.feature.tests.first.steps.first.block.rows.first.cells.first } # rubocop:disable Layout/LineLength


      it 'can get its directory' do
        ancestor = cell_model.get_ancestor(:directory)

        expect(ancestor).to equal(directory_model)
      end

      it 'can get its feature file' do
        ancestor = cell_model.get_ancestor(:feature_file)

        expect(ancestor).to equal(directory_model.feature_files.first)
      end

      it 'can get its feature' do
        ancestor = cell_model.get_ancestor(:feature)

        expect(ancestor).to equal(directory_model.feature_files.first.feature)
      end

      context 'a cell that is part of an outline' do

        let(:test_directory) { CukeModeler::FileHelper.create_directory }
        let(:source_gherkin) {
          "#{FEATURE_KEYWORD}: Test feature

             #{OUTLINE_KEYWORD}: Test outline
               #{STEP_KEYWORD} a step
             #{EXAMPLE_KEYWORD}:
               | param |
               | value |"
        }

        let(:directory_model) { CukeModeler::Directory.new(test_directory) }
        let(:cell_model) { directory_model.feature_files.first.feature.tests.first.examples.first.rows.first.cells.first } # rubocop:disable Layout/LineLength


        it 'can get its outline' do
          ancestor = cell_model.get_ancestor(:outline)

          expect(ancestor).to equal(directory_model.feature_files.first.feature.tests.first)
        end

        it 'can get its example' do
          ancestor = cell_model.get_ancestor(:example)

          expect(ancestor).to equal(directory_model.feature_files.first.feature.tests.first.examples.first)
        end

        it 'can get its row' do
          ancestor = cell_model.get_ancestor(:row)

          expect(ancestor).to equal(directory_model.feature_files.first.feature.tests.first.examples.first.rows.first)
        end

      end


      context 'a cell that is part of a scenario' do

        let(:test_directory) { CukeModeler::FileHelper.create_directory }
        let(:source_gherkin) {
          "#{FEATURE_KEYWORD}: Test feature

             #{SCENARIO_KEYWORD}: Test test
               #{STEP_KEYWORD} a step:
                 | a | table |"
        }

        let(:directory_model) { CukeModeler::Directory.new(test_directory) }
        let(:cell_model) { directory_model.feature_files.first.feature.tests.first.steps.first.block.rows.first.cells.first } # rubocop:disable Layout/LineLength


        it 'can get its scenario' do
          ancestor = cell_model.get_ancestor(:scenario)

          expect(ancestor).to equal(directory_model.feature_files.first.feature.tests.first)
        end

      end

      context 'a cell that is part of a background' do

        let(:test_directory) { CukeModeler::FileHelper.create_directory }
        let(:source_gherkin) {
          "#{FEATURE_KEYWORD}: Test feature

             #{BACKGROUND_KEYWORD}: Test background
               #{STEP_KEYWORD} a step:
                 | a | table |"
        }

        let(:directory_model) { CukeModeler::Directory.new(test_directory) }
        let(:cell_model) { directory_model.feature_files.first.feature.background.steps.first.block.rows.first.cells.first } # rubocop:disable Layout/LineLength


        it 'can get its background' do
          ancestor = cell_model.get_ancestor(:background)

          expect(ancestor).to equal(directory_model.feature_files.first.feature.background)
        end

      end

      context 'a cell that is part of a step' do

        let(:test_directory) { CukeModeler::FileHelper.create_directory }
        let(:source_gherkin) {
          "#{FEATURE_KEYWORD}: Test feature

             #{SCENARIO_KEYWORD}: Test test
               #{STEP_KEYWORD} a step:
                 | a | table |"
        }

        let(:directory_model) { CukeModeler::Directory.new(test_directory) }
        let(:cell_model) { directory_model.feature_files.first.feature.tests.first.steps.first.block.rows.first.cells.first } # rubocop:disable Layout/LineLength


        it 'can get its step' do
          ancestor = cell_model.get_ancestor(:step)

          expect(ancestor).to equal(directory_model.feature_files.first.feature.tests.first.steps.first)
        end

        it 'can get its table' do
          ancestor = cell_model.get_ancestor(:table)

          expect(ancestor).to equal(directory_model.feature_files.first.feature.tests.first.steps.first.block)
        end

        it 'can get its row' do
          ancestor = cell_model.get_ancestor(:row)
          row = directory_model.feature_files.first.feature.tests.first.steps.first.block.rows.first

          expect(ancestor).to equal(row)
        end

      end

      it 'returns nil if it does not have the requested type of ancestor' do
        ancestor = cell_model.get_ancestor(:example)

        expect(ancestor).to be_nil
      end

    end


    describe 'model population' do

      context 'from source text' do

        let(:source_text) { 'a cell' }
        let(:cell) { clazz.new(source_text) }


        it "models the cell's value" do
          expect(cell.value).to eq('a cell')
        end

        it "models the cell's source line" do
          source_text = "#{FEATURE_KEYWORD}:

                           #{SCENARIO_KEYWORD}:
                             #{STEP_KEYWORD} a step
                               | value |"
          cell = CukeModeler::Feature.new(source_text).tests.first.steps.first.block.rows.first.cells.first

          expect(cell.source_line).to eq(5)
        end


        it "models the cell's fingerprint" do
          expect(cell.fingerprint).to eq(Digest::MD5.hexdigest(cell.to_s))
        end

      end

    end


    describe 'cell output' do

      it 'can be remade from its own output' do
        source = 'a \\\\ complex \| cell'
        cell = clazz.new(source)

        cell_output = cell.to_s
        remade_cell_output = clazz.new(cell_output).to_s

        expect(remade_cell_output).to eq(cell_output)
      end


      context 'from source text' do

        it 'can output a cell' do
          source = 'a cell'
          cell = clazz.new(source)

          expect(cell.to_s).to eq('a cell')
        end

        #  Because vertical bars mark the beginning and end of a cell, any vertical bars inside
        #  of the cell (which would have had to have been escaped to get inside of the cell in
        #  the first place) will be escaped when outputted so as to retain the quality of being
        #  able to use the output directly as Gherkin.

        it 'can output a cell that has vertical bars in it' do
          source = 'cell with a \| in it'
          cell = clazz.new(source)

          cell_output = cell.to_s

          expect(cell_output).to eq('cell with a \| in it')
        end

        #  Because backslashes are used to escape special characters, any backslashes inside
        #  of the cell (which would have had to have been escaped to get inside of the cell in
        #  the first place) will be escaped when outputted so as to retain the quality of being
        #  able to use the output directly as Gherkin.

        it 'can output a cell that has backslashes in it' do
          source = 'cell with a \\\\ in it'
          cell = clazz.new(source)

          cell_output = cell.to_s

          expect(cell_output).to eq('cell with a \\\\ in it')
        end

        # Depending on the order in which special characters are escaped, extra backslashes might occur.
        it 'can output a cell that has several kinds of special characters in it' do
          source = 'cell with a \\\\ and \| in it'
          cell = clazz.new(source)

          cell_output = cell.to_s

          expect(cell_output).to eq('cell with a \\\\ and \| in it')
        end

      end

    end

  end

end
