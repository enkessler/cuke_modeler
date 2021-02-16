require_relative '../../../../../environments/rspec_env'


RSpec.describe 'Model, Unit' do

  let(:clazz) { CukeModeler::Model }
  let(:model) { clazz.new }


  describe 'common behavior' do

    it_should_behave_like 'a model'

  end


  describe 'unique behavior' do

    it 'contains nothing' do
      expect(model.children).to be_empty
    end

  end

end
