require "#{File.dirname(__FILE__)}/../spec_helper"


describe 'Model, Unit' do

  let(:clazz) { CukeModeler::Model }


  describe 'common behavior' do

    it_should_behave_like 'a model'

  end

end
