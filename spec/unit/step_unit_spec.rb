require 'spec_helper'

SimpleCov.command_name('Step') unless RUBY_VERSION.to_s < '1.9.0'

describe 'Step, Unit' do

  clazz = CukeModeler::Step


  describe 'generic tests' do
    it_should_behave_like 'a modeled element', clazz
  end

  describe 'specific tests' do

    before(:each) do
      @step = clazz.new
    end

    it 'has a base' do
      @step.should respond_to(:base)
    end

    it 'can change its base' do
      @step.should respond_to(:base=)

      @step.base = :some_base
      @step.base.should == :some_base
      @step.base = :some_other_base
      @step.base.should == :some_other_base
    end

    it 'starts with no base' do
      @step.base.should == ''
    end

  end
end
