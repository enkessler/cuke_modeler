require 'spec_helper'


describe 'Raw, Unit' do

  let(:nodule) { CukeModeler::Raw }
  let(:element) { Object.new.extend(nodule) }


  describe 'unique behavior' do

    it 'has a raw element' do
      element.should respond_to(:raw_element)
    end

    it 'can change its raw element' do
      expect(element).to respond_to(:raw_element=)

      element.raw_element = :some_raw_element
      element.raw_element.should == :some_raw_element
      element.raw_element = :some_other_raw_element
      element.raw_element.should == :some_other_raw_element
    end

  end

end
