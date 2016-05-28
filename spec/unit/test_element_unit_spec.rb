require 'spec_helper'

SimpleCov.command_name('TestElement') unless RUBY_VERSION.to_s < '1.9.0'

describe 'TestElement, Unit' do

  let(:clazz) { CukeModeler::TestElement }
  let(:element) { clazz.new }


  describe 'common behavior' do

    it_should_behave_like 'a test element'
    it_should_behave_like 'a feature element'
    it_should_behave_like 'a nested element'
    it_should_behave_like 'a prepopulated element'
    it_should_behave_like 'a bare bones element'

  end


  describe 'unique behavior' do

    it 'contains only steps' do
      steps = [:step_1, :step_2, :step_3]
      element.steps = steps

      element.children.should =~ steps
    end

    it 'can determine its equality with another TestElement' do
      element_1 = clazz.new
      element_2 = clazz.new
      element_3 = clazz.new

      element_1.steps = :some_steps
      element_2.steps = :some_steps
      element_3.steps = :some_other_steps

      (element_1 == element_2).should be_true
      (element_1 == element_3).should be_false
    end

    it 'can gracefully be compared to other types of objects' do
      # Some common types of object
      [1, 'foo', :bar, [], {}].each do |thing|
        expect { element == thing }.to_not raise_error
        expect(element == thing).to be false
      end
    end

  end

end
