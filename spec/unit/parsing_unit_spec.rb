require 'spec_helper'


describe 'Parsing, Unit' do

  let(:nodule) { CukeModeler::Parsing }


  describe 'unique behavior' do

    it 'can parse text' do
      expect(nodule).to respond_to(:parse_text)
    end

    it 'takes the text that is to be parsed and an optional file name' do
      expect(nodule.method(:parse_text).arity).to eq(-2)
    end

  end

end
