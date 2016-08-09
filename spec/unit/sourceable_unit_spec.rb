require 'spec_helper'


describe 'Sourceable, Unit' do

  let(:nodule) { CukeModeler::Sourceable }
  let(:element) { Object.new.extend(nodule) }


  describe 'unique behavior' do

    it 'has a source line' do
      expect(element).to respond_to(:source_line)
    end

    it 'can change its source line' do
      expect(element).to respond_to(:source_line=)

      element.source_line = :some_source_line
      expect(element.source_line).to eq(:some_source_line)
      element.source_line = :some_other_source_line
      expect(element.source_line).to eq(:some_other_source_line)
    end

  end

end
