require_relative '../../../../../environments/rspec_env'


RSpec.describe 'Rule, Unit', unit_test: true do

  let(:clazz) { CukeModeler::Rule }
  let(:rule) { clazz.new }


  describe 'common behavior' do

    it_should_behave_like 'a model'
    it_should_behave_like 'a keyworded model'
    it_should_behave_like 'a named model'
    it_should_behave_like 'a described model'
    it_should_behave_like 'a sourced model'
    it_should_behave_like 'a tagged model'
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
      expect(rule).to respond_to(:background)
    end

    it 'can change its background' do
      expect(rule).to respond_to(:background=)

      rule.background = :some_background
      expect(rule.background).to eq(:some_background)
      rule.background = :some_other_background
      expect(rule.background).to eq(:some_other_background)
    end

    [:has_background?, :background?].each do |method_name|
      it "knows whether or not it presently has a background (##{method_name})" do
        expect(rule).to respond_to(method_name)

        rule.background = :a_background
        expect(rule.send(method_name)).to be true
        rule.background = nil
        expect(rule.send(method_name)).to_not be true
      end
    end

    it 'has tests' do
      expect(rule).to respond_to(:tests)
    end

    it 'can change its tests' do
      expect(rule).to respond_to(:tests=)

      rule.tests = :some_tests
      expect(rule.tests).to eq(:some_tests)
      rule.tests = :some_other_tests
      expect(rule.tests).to eq(:some_other_tests)
    end

    it 'can selectively access its scenarios' do
      expect(rule).to respond_to(:scenarios)
    end

    it 'can selectively access its outlines' do
      expect(rule).to respond_to(:outlines)
    end

    it 'finds no scenarios or outlines when it has no tests' do
      rule.tests = []

      expect(rule.scenarios).to be_empty
      expect(rule.outlines).to be_empty
    end

    it 'contains a background, tests, and tags' do
      tags = [:tag_1, :tag_2]
      tests = [:test_1, :test_2]
      background = :a_background
      everything = [background] + tests + tags

      rule.background = background
      rule.tests = tests
      rule.tags = tags

      expect(rule.children).to match_array(everything)
    end

    it 'contains a background only if one is present' do
      tests = [:test_1, :test_2]
      background = nil
      everything = tests

      rule.background = background
      rule.tests = tests

      expect(rule.children).to match_array(everything)
    end


    context 'from abstract instantiation' do

      let(:rule) { clazz.new }


      it 'starts with no background' do
        expect(rule.background).to be_nil
      end

      it 'starts with no tests' do
        expect(rule.tests).to eq([])
      end

    end


    describe 'rule output' do

      describe 'inspection' do

        it "can inspect a rule that doesn't have a name" do
          rule.name   = nil
          rule_output = rule.inspect

          expect(rule_output).to eq('#<CukeModeler::Rule:<object_id> @name: nil>'
                                      .sub('<object_id>', rule.object_id.to_s))
        end

        it 'can inspect a rule that has a name' do
          rule.name   = 'a name'
          rule_output = rule.inspect

          expect(rule_output).to eq('#<CukeModeler::Rule:<object_id> @name: "a name">'
                                      .sub('<object_id>', rule.object_id.to_s))
        end

      end


      describe 'stringification' do

        context 'from abstract instantiation' do

          let(:rule) { clazz.new }


          it 'can stringify a rule that has only a keyword' do
            rule.keyword = 'foo'

            expect(rule.to_s).to eq('foo:')
          end


          describe 'edge cases' do

            # These cases would not produce valid Gherkin and so don't have any useful output
            # but they need to at least not explode

            # The minimal rule case
            it 'can stringify an empty rule' do
              expect { rule.to_s }.to_not raise_error
            end

            it 'can stringify a rule that has only a name' do
              rule.name = 'a name'

              expect { rule.to_s }.to_not raise_error
            end

            it 'can stringify a rule that has only a description' do
              rule.description = 'a description'

              expect { rule.to_s }.to_not raise_error
            end

          end

        end

      end

    end

  end

end
