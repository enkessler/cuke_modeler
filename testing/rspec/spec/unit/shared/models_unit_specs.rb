require "#{File.dirname(__FILE__)}/../../spec_helper"

shared_examples_for 'a model' do

  describe 'common behavior' do

    it_should_behave_like 'a bare bones model'
    it_should_behave_like 'a prepopulated model'
    it_should_behave_like 'a nested model'
    it_should_behave_like 'a containing model'
    it_should_behave_like 'a stringifiable model'

  end

end
