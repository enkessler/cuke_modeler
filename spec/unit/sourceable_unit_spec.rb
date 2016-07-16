require 'spec_helper'


describe 'Sourceable, Unit' do

  let(:nodule) { CukeModeler::Sourceable }
  let(:element) { Object.new.extend(nodule) }


  describe 'unique behavior' do

    it 'has a source line' do
      element.should respond_to(:source_line)
    end

  end

end
