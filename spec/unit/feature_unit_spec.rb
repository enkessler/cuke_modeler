require 'spec_helper'

SimpleCov.command_name('Feature') unless RUBY_VERSION.to_s < '1.9.0'

describe 'Feature, Unit' do

  clazz = CukeModeler::Feature

  describe 'generic tests' do
    it_should_behave_like 'a modeled element', clazz
    it_should_behave_like 'a named element', clazz
    it_should_behave_like 'a described element', clazz
    it_should_behave_like 'a tagged element', clazz
    it_should_behave_like 'a sourced element', clazz
  end

  describe 'specific tests' do

    before(:each) do
      @feature = clazz.new
    end

    # This may need to change once adapters are fully implemented
    it 'will complain about unknown element types' do
      parsed_element = {'description' => '',
                        'elements' => [{'keyword' => 'Scenario', 'description' => ''},
                                       {'keyword' => 'New Type', 'description' => ''}]}

      expect { clazz.new(parsed_element) }.to raise_error(ArgumentError)
    end

    it 'has a background' do
      @feature.should respond_to(:background)
    end

    it 'can change its background' do
      @feature.should respond_to(:background=)

      @feature.background = :some_background
      @feature.background.should == :some_background
      @feature.background = :some_other_background
      @feature.background.should == :some_other_background
    end

    it 'has tests' do
      @feature.should respond_to(:tests)
    end

    it 'can change its tests' do
      @feature.should respond_to(:tests=)

      @feature.tests = :some_tests
      @feature.tests.should == :some_tests
      @feature.tests = :some_other_tests
      @feature.tests.should == :some_other_tests
    end

    it 'contains a background and tests' do
      tests = [:test_1, :test_2]
      background = :a_background
      everything = [background] + tests

      @feature.background = background
      @feature.tests = tests

      @feature.contains.should =~ everything
    end

    it 'contains a background only if one is present' do
      tests = [:test_1, :test_2]
      background = nil
      everything = tests

      @feature.background = background
      @feature.tests = tests

      @feature.contains.should =~ everything
    end

    it 'starts with no background' do
      @feature.background.should == nil
    end

    it 'starts with no tests' do
      @feature.tests.should == []
    end

    it 'can selectively access its scenarios' do
      @feature.should respond_to(:scenarios)
    end

    it 'can selectively access its outlines' do
      @feature.should respond_to(:outlines)
    end

    it 'finds no scenarios or outlines when it has no tests' do
      @feature.tests = []

      @feature.scenarios.should == []
      @feature.outlines.should == []
    end


    describe 'feature output edge cases' do

      it 'can output an empty feature' do
        expect { clazz.new.to_s }.to_not raise_error
      end

      it 'can output a feature that has only a name' do
        @feature.name = 'a name'

        expect { @feature.to_s }.to_not raise_error
      end

      it 'can output a feature that has only a description' do
        @feature.description = 'a description'

        expect { @feature.to_s }.to_not raise_error
      end

    end
  end
end
