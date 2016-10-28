require "#{File.dirname(__FILE__)}/../spec_helper"


describe 'Example, Unit', :unit_test => true do

  let(:clazz) { CukeModeler::Example }
  let(:example) { clazz.new }

  describe 'common behavior' do

    it_should_behave_like 'a model'
    it_should_behave_like 'a keyworded model'
    it_should_behave_like 'a named model'
    it_should_behave_like 'a described model'
    it_should_behave_like 'a tagged model'
    it_should_behave_like 'a sourced model'
    it_should_behave_like 'a parsed model'

  end


  describe 'unique behavior' do

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


    describe 'example output' do

      it 'is a String' do
        expect(example.to_s).to be_a(String)
      end


      context 'from abstract instantiation' do

        let(:example) { clazz.new }


        it 'can output an empty example' do
          expect { example.to_s }.to_not raise_error
        end

        it 'can output an example that has only a keyword' do
          example.keyword = 'foo'

          expect(example.to_s).to eq('foo:')
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
