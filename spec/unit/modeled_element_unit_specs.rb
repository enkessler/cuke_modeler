require 'spec_helper'

shared_examples_for 'a modeled element' do

  describe 'common behavior' do

    it_should_behave_like 'a bare bones element'
    it_should_behave_like 'a prepopulated element'
    it_should_behave_like 'a nested element'
    it_should_behave_like 'a containing element'
    it_should_behave_like 'a stringifiable element'

  end

end
