require "#{File.dirname(__FILE__)}/../spec_helper"


describe 'Parsing, Unit', :unit_test => true do

  let(:nodule) { CukeModeler::Parsing }


  before(:all) do
    @original_dialect = CukeModeler::Parsing.dialect
  end

  # Making sure that our changes don't escape a test and ruin the rest of the suite
  after(:all) do
    CukeModeler::Parsing.dialect = @original_dialect
  end


  describe 'unique behavior' do

    it 'can parse text' do
      expect(nodule).to respond_to(:parse_text)
    end

    it 'takes the text that is to be parsed and an optional file name' do
      expect(nodule.method(:parse_text).arity).to eq(-2)
    end

    it 'knows all of the available Gherkin dialects' do
      expect(nodule).to respond_to(:dialects)
    end

    it 'has an expected dialect to use for parsing' do
      expect(nodule).to respond_to(:dialect)
    end

    it 'can change its expected dialect' do
      expect(nodule).to respond_to(:dialect=)

      nodule.dialect = :some_dialect
      expect(nodule.dialect).to eq(:some_dialect)
      nodule.dialect = :some_other_dialect
      expect(nodule.dialect).to eq(:some_other_dialect)
    end

    it 'defaults to English if no dialect is set' do
      nodule.dialect = nil

      expect(nodule.dialect).to eq('en')
    end

  end

end
