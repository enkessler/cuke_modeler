require_relative '../../../../../environments/rspec_env'


RSpec.describe 'Model, Integration' do

  let(:clazz) { CukeModeler::Model }
  let(:maximal_string_input) { '' } # The input doesn't matter for the base model class


  describe 'common behavior' do

    it_should_behave_like 'a model, integration'

  end

end
