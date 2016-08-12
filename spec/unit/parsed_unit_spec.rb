require 'spec_helper'


describe 'Parsed, Unit' do

  let(:nodule) { CukeModeler::Parsed }
  let(:model) { Object.new.extend(nodule) }


  describe 'unique behavior' do

    it 'can access its original parsing data' do
      expect(model).to respond_to(:parsing_data)
    end

    it 'can change its parsing data' do
      expect(model).to respond_to(:parsing_data=)

      model.parsing_data = :some_parsing_data
      expect(model.parsing_data).to eq(:some_parsing_data)
      model.parsing_data = :some_other_parsing_data
      expect(model.parsing_data).to eq(:some_other_parsing_data)
    end

  end

end
