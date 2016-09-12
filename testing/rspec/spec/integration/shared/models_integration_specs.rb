require "#{File.dirname(__FILE__)}/../../spec_helper"

shared_examples_for 'a model, integration' do

  # clazz must be defined by the calling file

  let(:model) { clazz.new }


  describe 'unique behavior' do

    it 'inherits from the common model class' do
      expect(model).to be_a(CukeModeler::Model)
    end

  end

end
