require 'spec_helper'

SimpleCov.command_name('Background') unless RUBY_VERSION.to_s < '1.9.0'

describe 'Background, Unit' do

  clazz = CukeModeler::Background

  describe 'generic tests' do
    it_should_behave_like 'a modeled element', clazz
    it_should_behave_like 'a named element', clazz
    it_should_behave_like 'a described element', clazz
    it_should_behave_like 'a sourced element', clazz
  end

  describe 'specific tests' do

    before(:each) do
      @background = clazz.new
    end

    it 'has steps' do
      @background.should respond_to(:steps)
    end

    it 'can change its steps' do
      @background.should respond_to(:steps=)

      @background.steps = :some_steps
      @background.steps.should == :some_steps
      @background.steps = :some_other_steps
      @background.steps.should == :some_other_steps
    end

    it 'starts with no steps' do
      @background.steps.should == []
    end

    it 'contains steps' do
      steps = [:step_1, :step_2]
      everything = steps

      @background.steps = steps

      @background.contains.should =~ everything
    end

    describe 'background output edge cases' do

      before(:each) do
        @background = clazz.new
      end

      it 'can output an empty background' do
        expect { @background.to_s }.to_not raise_error
      end

      it 'can output a background that has only a name' do
        @background.name = 'a name'

        expect { @background.to_s }.to_not raise_error
      end

      it 'can output a background that has only a description' do
        @background.description = 'a description'

        expect { @background.to_s }.to_not raise_error
      end

    end

  end

end
