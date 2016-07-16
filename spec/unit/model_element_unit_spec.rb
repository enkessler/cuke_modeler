require 'spec_helper'


describe 'ModelElement, Unit' do

  let(:clazz) { CukeModeler::ModelElement }


  describe 'common behavior' do

    it_should_behave_like 'a modeled element'

  end

end
