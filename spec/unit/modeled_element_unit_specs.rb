require 'spec_helper'

shared_examples_for 'a modeled element' do |clazz|

  describe 'generic tests' do
    it_should_behave_like 'a bare bones element', clazz
    it_should_behave_like 'a prepopulated element', clazz
    it_should_behave_like 'a nested element', clazz
    it_should_behave_like 'a containing element', clazz
  end

end
