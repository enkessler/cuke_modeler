require 'spec_helper'

shared_examples_for 'a modeled element, integration' do

  # clazz must be defined by the calling file

  let(:element) { clazz.new }


  describe 'unique behavior' do

    it 'inherits from the common model class' do
      expect(element).to be_a(CukeModeler::ModelElement)
    end

  end

end
