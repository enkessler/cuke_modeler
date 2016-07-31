require 'spec_helper'


describe 'Example, Unit' do

  let(:clazz) { CukeModeler::Example }
  let(:example) { clazz.new }

  describe 'common behavior' do

    it_should_behave_like 'a modeled element'
    it_should_behave_like 'a named element'
    it_should_behave_like 'a described element'
    it_should_behave_like 'a tagged element'
    it_should_behave_like 'a sourced element'
    it_should_behave_like 'a parsed element'

  end


  describe 'unique behavior' do

    it 'can be instantiated with the minimum viable Gherkin', :gherkin4 => true do
      source = ['Examples:']
      source = source.join("\n")

      expect { @element = clazz.new(source) }.to_not raise_error
    end

    it 'provides a descriptive filename when being parsed from stand alone text' do
      source = 'bad example text'

      expect { clazz.new(source) }.to raise_error(/'cuke_modeler_stand_alone_example\.feature'/)
    end

    it 'trims whitespace from its source description' do
      source = ['Examples:',
                '  ',
                '        description line 1',
                '',
                '   description line 2',
                '     description line 3               ',
                '',
                '',
                '',
                '|param|',
                '|value|']
      source = source.join("\n")

      example = clazz.new(source)
      description = example.description.split("\n")

      expect(description).to eq(['     description line 1',
                                 '',
                                 'description line 2',
                                 '  description line 3'])
    end

    it 'has rows' do
      expect(example).to respond_to(:rows)
    end

    it 'can change its rows' do
      expect(example).to respond_to(:rows=)

      example.rows = :some_rows
      expect(example.rows).to eq(:some_rows)
      example.rows = :some_other_rows
      expect(example.rows).to eq(:some_other_rows)
    end

    it 'can selectively access its parameter row' do
      expect(example).to respond_to(:parameter_row)
    end

    it 'can selectively access its argument rows' do
      expect(example).to respond_to(:argument_rows)
    end

    it 'can determine its parameters' do
      expect(example).to respond_to(:parameters)
    end


    describe 'abstract instantiation' do

      context 'a new example object' do

        let(:example) { clazz.new }


        it 'starts with no rows' do
          expect(example.rows).to eq([])
        end

        it 'starts with no argument rows' do
          expect(example.argument_rows).to eq([])
        end

        it 'starts with no parameter row' do
          expect(example.parameter_row).to be_nil
        end

        it 'starts with no parameters' do
          expect(example.parameters).to eq([])
        end

      end

    end


    it 'can add a new example row' do
      expect(clazz.new).to respond_to(:add_row)
    end

    it 'can remove an existing example row' do
      expect(clazz.new).to respond_to(:remove_row)
    end

    it 'contains rows and tags' do
      tags = [:tag_1, :tag_2]
      rows = [:row_1, :row_2]
      everything = rows + tags

      example.rows = rows
      example.tags = tags

      expect(example.children).to match_array(everything)
    end


    describe 'model population' do

      context 'from source text' do

        context 'a filled example' do

          let(:source_text) { "Examples: test example

                                   Some example description.

                                 Some more.
                                     Even more." }
          let(:example) { clazz.new(source_text) }


          # gherkin 2.x/3.x does not accept incomplete examples
          it "models the example's name", :gherkin2 => false, :gherkin3 => false do
            expect(example.name).to eq('test example')
          end

          # gherkin 2.x/3.x does not accept incomplete examples
          it "models the example's description", :gherkin2 => false, :gherkin3 => false do
            description = example.description.split("\n")

            expect(description).to eq(['  Some example description.',
                                       '',
                                       'Some more.',
                                       '    Even more.'])
          end

        end

        # gherkin 2.x/3.x does not accept incomplete examples
        context 'an empty example', :gherkin2 => false, :gherkin3 => false do

          let(:source_text) { 'Examples:' }
          let(:example) { clazz.new(source_text) }

          it "models the example's name" do
            expect(example.name).to eq('')
          end

          it "models the example's description" do
            expect(example.description).to eq('')
          end

        end

      end

    end


    describe 'example output' do

      it 'is a String' do
        expect(example.to_s).to be_a(String)
      end


      context 'from source text' do

        # gherkin 2.x/3.x does not accept incomplete examples
        it 'can output an empty example', :gherkin2 => false, :gherkin3 => false do
          source = ['Examples:']
          source = source.join("\n")
          example = clazz.new(source)

          example_output = example.to_s.split("\n")

          expect(example_output).to eq(['Examples:'])
        end

        # gherkin 2.x/3.x does not accept incomplete examples
        it 'can output an example that has a name', :gherkin2 => false, :gherkin3 => false do
          source = ['Examples: test example']
          source = source.join("\n")
          example = clazz.new(source)

          example_output = example.to_s.split("\n")

          expect(example_output).to eq(['Examples: test example'])
        end

        # gherkin 2.x/3.x does not accept incomplete examples
        it 'can output an example that has a description', :gherkin2 => false, :gherkin3 => false do
          source = ['Examples:',
                    'Some description.',
                    'Some more description.']
          source = source.join("\n")
          example = clazz.new(source)

          example_output = example.to_s.split("\n")

          expect(example_output).to eq(['Examples:',
                                        '',
                                        'Some description.',
                                        'Some more description.'])
        end

      end


      context 'from abstract instantiation' do

        let(:example) { clazz.new }


        it 'can output an empty example' do
          expect { example.to_s }.to_not raise_error
        end

        it 'can output an example that has only a name' do
          example.name = 'a name'

          expect { example.to_s }.to_not raise_error
        end

        it 'can output an example that has only a description' do
          example.description = 'a description'

          expect { example.to_s }.to_not raise_error
        end

      end

    end

  end

end
