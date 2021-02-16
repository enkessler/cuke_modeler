require_relative '../../../../../environments/rspec_env'


RSpec.describe 'Feature, Unit', unit_test: true do

  let(:clazz) { CukeModeler::Feature }
  let(:feature) { clazz.new }


  describe 'common behavior' do

    it_should_behave_like 'a model'
    it_should_behave_like 'a keyworded model'
    it_should_behave_like 'a named model'
    it_should_behave_like 'a described model'
    it_should_behave_like 'a tagged model'
    it_should_behave_like 'a sourced model'
    it_should_behave_like 'a parsed model'

  end


  describe 'unique behavior' do

    it 'will complain about unknown element types' do
      parsed_element = { 'description' => '',
                         'elements'    => [{ 'keyword' => 'Scenario', 'description' => '' },
                                           { 'keyword' => 'New Type', 'description' => '' }] }

      expect { clazz.new(parsed_element) }.to raise_error(ArgumentError)
    end

    it 'has a background' do
      expect(feature).to respond_to(:background)
    end

    it 'can change its background' do
      expect(feature).to respond_to(:background=)

      feature.background = :some_background
      expect(feature.background).to eq(:some_background)
      feature.background = :some_other_background
      expect(feature.background).to eq(:some_other_background)
    end

    [:has_background?, :background?].each do |method_name|
      it "knows whether or not it presently has a background (##{method_name})" do
        expect(feature).to respond_to(method_name)

        feature.background = :a_background
        expect(feature.send(method_name)).to be true
        feature.background = nil
        expect(feature.send(method_name)).to_not be true
      end
    end

    it 'has rules' do
      expect(feature).to respond_to(:rules)
    end

    it 'can change its rules' do
      expect(feature).to respond_to(:rules=)

      feature.rules = :some_rules
      expect(feature.rules).to eq(:some_rules)
      feature.rules = :some_other_rules
      expect(feature.rules).to eq(:some_other_rules)
    end

    it 'has tests' do
      expect(feature).to respond_to(:tests)
    end

    it 'can change its tests' do
      expect(feature).to respond_to(:tests=)

      feature.tests = :some_tests
      expect(feature.tests).to eq(:some_tests)
      feature.tests = :some_other_tests
      expect(feature.tests).to eq(:some_other_tests)
    end

    it 'can selectively access its scenarios' do
      expect(feature).to respond_to(:scenarios)
    end

    it 'can selectively access its outlines' do
      expect(feature).to respond_to(:outlines)
    end

    it 'finds no scenarios or outlines when it has no tests' do
      feature.tests = []

      expect(feature.scenarios).to be_empty
      expect(feature.outlines).to be_empty
    end

    it 'contains a background, rules, tests, and tags' do
      tags = [:tag_1, :tagt_2]
      rules = [:rule_1, :rule_2]
      tests = [:test_1, :test_2]
      background = :a_background
      everything = [background] + rules + tests + tags

      feature.background = background
      feature.rules = rules
      feature.tests = tests
      feature.tags = tags

      expect(feature.children).to match_array(everything)
    end

    it 'contains a background only if one is present' do
      tests = [:test_1, :test_2]
      background = nil
      everything = tests

      feature.background = background
      feature.tests = tests

      expect(feature.children).to match_array(everything)
    end


    context 'from abstract instantiation' do

      let(:feature) { clazz.new }


      it 'starts with no background' do
        expect(feature.background).to be_nil
      end

      it 'starts with no rules' do
        expect(feature.rules).to eq([])
      end

      it 'starts with no tests' do
        expect(feature.tests).to eq([])
      end

    end


    describe 'feature output' do

      context 'from abstract instantiation' do

        let(:feature) { clazz.new }


        it 'can output an empty feature' do
          expect { feature.to_s }.to_not raise_error
        end

        it 'can output a feature that has only a keyword' do
          feature.keyword = 'foo'

          expect(feature.to_s).to eq('foo:')
        end

        it 'can output a feature that has only a name' do
          feature.name = 'a name'

          expect { feature.to_s }.to_not raise_error
        end

        it 'can output a feature that has only a description' do
          feature.description = 'a description'

          expect { feature.to_s }.to_not raise_error
        end

      end

    end

  end

end
