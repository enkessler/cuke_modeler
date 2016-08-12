require 'spec_helper'


describe 'Model, Integration' do

  let(:clazz) { CukeModeler::Model }


  describe 'common behavior' do

    it_should_behave_like 'a model, integration'

  end

end
