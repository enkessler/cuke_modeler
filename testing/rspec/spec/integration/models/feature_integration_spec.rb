require_relative '../../../../../environments/rspec_env'


RSpec.describe 'Feature, Integration' do

  # Rules became taggable in Gherkin 18
  let(:gherkin_versions_with_untagged_rules) { (9..17) }

  let(:clazz) { CukeModeler::Feature }
  let(:feature) { clazz.new }
  let(:minimum_viable_gherkin) { "#{FEATURE_KEYWORD}:" }
  let(:maximum_viable_gherkin) do
    tag_text = gherkin?(gherkin_versions_with_untagged_rules) ? '' : "@tag1 @tag2 @tag3\n"

    "# language: #{CukeModeler::Parsing.dialect}
     @tag1 @tag2 @tag3
     #{FEATURE_KEYWORD}: A feature with everything it could have

     Including a description
     and then some.

       #{BACKGROUND_KEYWORD}: non-nested background

       Background
       description

         #{STEP_KEYWORD} a step
           | value1 |
           | value2 |
         #{STEP_KEYWORD} another step

       @scenario_tag
       #{SCENARIO_KEYWORD}: non-nested scenario

       Scenario
       description

         #{STEP_KEYWORD} a step
         #{STEP_KEYWORD} another step
           \"\"\" with content type
           some text
           \"\"\"

       #{tag_text}#{RULE_KEYWORD}: a rule

       Rule description

       #{BACKGROUND_KEYWORD}: nested background
         #{STEP_KEYWORD} a step

         @outline_tag
         #{OUTLINE_KEYWORD}: nested outline

         Outline
         description

           #{STEP_KEYWORD} a step
             | value2 |
           #{STEP_KEYWORD} another step
             \"\"\"
             some text
             \"\"\"

         @example_tag
         #{EXAMPLE_KEYWORD}:

         Example
         description

           | param |
           | value |
         #{EXAMPLE_KEYWORD}: additional example

       #{tag_text}#{RULE_KEYWORD}: another rule

       Which is empty"
  end


  describe 'common behavior' do

    it_should_behave_like 'a model, integration'

  end

  describe 'unique behavior' do

    it 'can be instantiated with the minimum viable Gherkin' do
      expect { clazz.new(minimum_viable_gherkin) }.to_not raise_error
    end

    it 'can parse text that uses a non-default dialect' do
      original_dialect = CukeModeler::Parsing.dialect
      CukeModeler::Parsing.dialect = 'en-au'

      begin
        source_text = "# language: en-au
                       Pretty much: Feature name"

        expect { @model = clazz.new(source_text) }.to_not raise_error

        # Sanity check in case modeling failed in a non-explosive manner
        expect(@model.name).to eq('Feature name')
      ensure
        # Making sure that our changes don't escape a test and ruin the rest of the suite
        CukeModeler::Parsing.dialect = original_dialect
      end
    end

    it 'provides a descriptive filename when being parsed from stand alone text' do
      source = 'bad feature text'

      expect { clazz.new(source) }.to raise_error(/'cuke_modeler_stand_alone_feature\.feature'/)
    end

    it 'properly sets its child models' do
      source = "@a_tag
                #{FEATURE_KEYWORD}: Test feature
                  #{BACKGROUND_KEYWORD}: Test background
                  #{SCENARIO_KEYWORD}: Test scenario
                  #{OUTLINE_KEYWORD}: Test outline
                  #{EXAMPLE_KEYWORD}: Test Examples
                    | param |
                    | value |
                  #{RULE_KEYWORD}: Test rule"


      feature = clazz.new(source)
      background = feature.background
      rule = feature.rules[0]
      scenario = feature.tests[0]
      outline = feature.tests[1]
      tag = feature.tags[0]


      expect(outline.parent_model).to equal(feature)
      expect(scenario.parent_model).to equal(feature)
      expect(background.parent_model).to equal(feature)
      expect(rule.parent_model).to equal(feature)
      expect(tag.parent_model).to equal(feature)
    end

    describe 'parsing data' do

      context 'with minimum viable Gherkin' do

        let(:source_text) { minimum_viable_gherkin }

        it 'stores the original data generated by the parsing adapter', if: gherkin?((20..MOST_CURRENT_GHERKIN_VERSION)) do # rubocop:disable Layout/LineLength
          feature = clazz.new(source_text)
          data = feature.parsing_data

          expect(data).to be_a(Cucumber::Messages::Feature)
          expect(data.keyword).to eq(FEATURE_KEYWORD)
        end

        it 'stores the original data generated by the parsing adapter', if: gherkin?(19) do
          feature = clazz.new(source_text)
          data = feature.parsing_data

          expect(data.keys).to match_array([:children, :description, :keyword, :language, :location, :name, :tags])
          expect(data[:keyword]).to eq(FEATURE_KEYWORD)
        end

        it 'stores the original data generated by the parsing adapter', if: gherkin?((9..18)) do
          feature = clazz.new(source_text)
          data = feature.parsing_data

          expect(data.keys).to match_array([:location, :language, :keyword, :name])
          expect(data[:keyword]).to eq(FEATURE_KEYWORD)
        end

      end

      context 'with maximum viable Gherkin' do

        let(:source_text) { maximum_viable_gherkin }

        it 'stores the original data generated by the parsing adapter', if: gherkin?((20..MOST_CURRENT_GHERKIN_VERSION)) do # rubocop:disable Layout/LineLength
          feature = clazz.new(source_text)
          data = feature.parsing_data

          expect(data).to be_a(Cucumber::Messages::Feature)
          expect(data.name).to eq('A feature with everything it could have')
        end

        it 'stores the original data generated by the parsing adapter', if: gherkin?((9..19)) do
          feature = clazz.new(source_text)
          data = feature.parsing_data

          expect(data.keys).to match_array([:tags, :location, :language, :keyword, :name, :children, :description])
          expect(data[:name]).to eq('A feature with everything it could have')
        end

      end

    end


    it 'trims whitespace from its source description' do
      source = ["#{FEATURE_KEYWORD}:",
                '  ',
                '        description line 1',
                '',
                '   description line 2',
                '     description line 3               ',
                '',
                '',
                '',
                "  #{SCENARIO_KEYWORD}:"]
      source = source.join("\n")

      feature = clazz.new(source)
      description = feature.description.split("\n", -1)

      expect(description).to eq(['     description line 1',
                                 '',
                                 'description line 2',
                                 '  description line 3'])
    end

    it 'can selectively access its scenarios and outlines' do
      scenarios = [CukeModeler::Scenario.new, CukeModeler::Scenario.new]
      outlines = [CukeModeler::Outline.new, CukeModeler::Outline.new]

      feature.tests = scenarios + outlines

      expect(feature.scenarios).to match_array(scenarios)
      expect(feature.outlines).to match_array(outlines)
    end


    describe 'model population' do

      context 'from source text' do

        it "models the feature's keyword" do
          source_text = "#{FEATURE_KEYWORD}:"
          feature = CukeModeler::Feature.new(source_text)

          expect(feature.keyword).to eq(FEATURE_KEYWORD)
        end

        it "models the feature's source line" do
          source_text = "#{FEATURE_KEYWORD}:"
          feature = CukeModeler::Feature.new(source_text)

          expect(feature.source_line).to eq(1)
        end

        it "models the feature's source column" do
          source_text = "#{FEATURE_KEYWORD}:"
          feature = CukeModeler::Feature.new(source_text)

          expect(feature.source_column).to eq(1)
        end


        context 'a filled feature' do

          let(:source_text) {
            "# language: #{CukeModeler::Parsing.dialect}
             @tag_1 @tag_2
             #{FEATURE_KEYWORD}: Feature Foo

                 Some feature description.

               Some more.
                   And some more.

               #{BACKGROUND_KEYWORD}: The background
                 #{STEP_KEYWORD} some setup step

               #{SCENARIO_KEYWORD}: Scenario 1
                 #{STEP_KEYWORD} a step

               #{OUTLINE_KEYWORD}: Outline 1
                 #{STEP_KEYWORD} a step
               #{EXAMPLE_KEYWORD}:
                 | param |
                 | value |

               #{SCENARIO_KEYWORD}: Scenario 2
                 #{STEP_KEYWORD} a step

               #{OUTLINE_KEYWORD}: Outline 2
                 #{STEP_KEYWORD} a step
               #{EXAMPLE_KEYWORD}:
                 | param |
                 | value |

               #{RULE_KEYWORD}: Rule 1
               #{RULE_KEYWORD}: Rule 2"
          }
          let(:feature) { clazz.new(source_text) }


          it "models the feature's language" do
            expect(feature.language).to eq(CukeModeler::Parsing.dialect)
          end

          it "models the feature's name" do
            expect(feature.name).to eq('Feature Foo')
          end

          it "models the feature's description" do
            description = feature.description.split("\n", -1)

            expect(description).to eq(['  Some feature description.',
                                       '',
                                       'Some more.',
                                       '    And some more.'])
          end

          it "models the feature's background" do
            expect(feature.background.name).to eq('The background')
          end

          it "models the feature's rules" do
            rule_names = feature.rules.map(&:name)

            expect(rule_names).to eq(['Rule 1', 'Rule 2'])
          end

          it "models the feature's scenarios" do
            scenario_names = feature.scenarios.map(&:name)

            expect(scenario_names).to eq(['Scenario 1', 'Scenario 2'])
          end

          it "models the feature's outlines" do
            outline_names = feature.outlines.map(&:name)

            expect(outline_names).to eq(['Outline 1', 'Outline 2'])
          end

          it "models the feature's tags" do
            tag_names = feature.tags.map(&:name)

            expect(tag_names).to eq(['@tag_1', '@tag_2'])
          end

        end


        context 'an empty feature' do

          let(:source_text) { "#{FEATURE_KEYWORD}:" }
          let(:feature) { clazz.new(source_text) }


          # A language is always used, even if it's just the default language
          it "models the feature's language" do
            expect(feature.language).to eq(CukeModeler::Parsing.dialect)
          end

          it "models the feature's name" do
            expect(feature.name).to eq('')
          end

          it "models the feature's description" do
            expect(feature.description).to eq('')
          end

          it "models the feature's background" do
            expect(feature.background).to be_nil
          end

          it "models the feature's rules" do
            expect(feature.rules).to eq([])
          end

          it "models the feature's scenarios" do
            expect(feature.scenarios).to eq([])
          end

          it "models the feature's outlines" do
            expect(feature.outlines).to eq([])
          end

          it "models the feature's tags" do
            expect(feature.tags).to eq([])
          end

        end

      end

    end


    it 'knows how many test cases it has' do
      source_1 = "#{FEATURE_KEYWORD}: Test feature"

      source_2 = "#{FEATURE_KEYWORD}: Test feature
                    #{SCENARIO_KEYWORD}: Test scenario
                    #{OUTLINE_KEYWORD}: Test outline
                      #{STEP_KEYWORD} a step
                    #{EXAMPLE_KEYWORD}: Test examples
                      |param|
                      |value_1|
                      |value_2|"

      feature_1 = clazz.new(source_1)
      feature_2 = clazz.new(source_2)

      expect(feature_1.test_case_count).to eq(0)
      expect(feature_2.test_case_count).to eq(3)
    end


    describe 'getting ancestors' do

      before(:each) do
        CukeModeler::FileHelper.create_feature_file(text: source_gherkin,
                                                    name: 'feature_test_file',
                                                    directory: test_directory)
      end


      let(:test_directory) { CukeModeler::FileHelper.create_directory }
      let(:source_gherkin) { "#{FEATURE_KEYWORD}: Test feature" }

      let(:directory_model) { CukeModeler::Directory.new(test_directory) }
      let(:feature_model) { directory_model.feature_files.first.feature }


      it 'can get its directory' do
        ancestor = feature_model.get_ancestor(:directory)

        expect(ancestor).to equal(directory_model)
      end

      it 'can get its feature file' do
        ancestor = feature_model.get_ancestor(:feature_file)

        expect(ancestor).to equal(directory_model.feature_files.first)
      end

      it 'returns nil if it does not have the requested type of ancestor' do
        ancestor = feature_model.get_ancestor(:test)

        expect(ancestor).to be_nil
      end

    end


    describe 'feature output' do

      describe 'stringification' do

        context 'from source text' do

          it 'can be remade from its own stringified output' do
            source = "@tag1 @tag2 @tag3
                      #{FEATURE_KEYWORD}: A feature with everything it could have

                      Including a description
                      and then some.

                        #{BACKGROUND_KEYWORD}: non-nested background

                        Background
                        description

                          #{STEP_KEYWORD} a step
                            | value1 |
                            | value2 |
                          #{STEP_KEYWORD} another step

                        @scenario_tag
                        #{SCENARIO_KEYWORD}: non-nested scenario

                        Scenario
                        description

                          #{STEP_KEYWORD} a step
                          #{STEP_KEYWORD} another step
                            \"\"\" with content type
                            some text
                            \"\"\"

                        #{RULE_KEYWORD}: a rule

                        Rule description

                        #{BACKGROUND_KEYWORD}: nested background
                          #{STEP_KEYWORD} a step

                          @outline_tag
                          #{OUTLINE_KEYWORD}: nested outline

                          Outline
                          description

                            #{STEP_KEYWORD} a step
                              | value2 |
                            #{STEP_KEYWORD} another step
                              \"\"\"
                              some text
                              \"\"\"

                          @example_tag
                          #{EXAMPLE_KEYWORD}:

                          Example
                          description

                            | param |
                            | value |
                          #{EXAMPLE_KEYWORD}: additional example

                      #{RULE_KEYWORD}: another rule

                      Which is empty"

            feature = clazz.new(source)

            feature_output        = feature.to_s
            remade_feature_output = clazz.new(feature_output).to_s

            expect(remade_feature_output).to eq(feature_output)
          end

          # The minimal feature case
          it 'can stringify an empty feature' do
            source  = ["#{FEATURE_KEYWORD}:"]
            source  = source.join("\n")
            feature = clazz.new(source)

            feature_output = feature.to_s.split("\n", -1)

            expect(feature_output).to eq(["#{FEATURE_KEYWORD}:"])
          end

          it 'can stringify a feature that has a name' do
            source  = ["#{FEATURE_KEYWORD}: test feature"]
            source  = source.join("\n")
            feature = clazz.new(source)

            feature_output = feature.to_s.split("\n", -1)

            expect(feature_output).to eq(["#{FEATURE_KEYWORD}: test feature"])
          end

          it 'can stringify a feature that has a description' do
            source  = ["#{FEATURE_KEYWORD}:",
                       'Some description.',
                       'Some more description.']
            source  = source.join("\n")
            feature = clazz.new(source)

            feature_output = feature.to_s.split("\n", -1)

            expect(feature_output).to eq(["#{FEATURE_KEYWORD}:",
                                          '',
                                          'Some description.',
                                          'Some more description.'])
          end

          it 'can stringify a feature that has tags' do
            source  = ['@tag1 @tag2',
                       '@tag3',
                       "#{FEATURE_KEYWORD}:"]
            source  = source.join("\n")
            feature = clazz.new(source)

            feature_output = feature.to_s.split("\n", -1)

            expect(feature_output).to eq(['@tag1 @tag2 @tag3',
                                          "#{FEATURE_KEYWORD}:"])
          end

          it 'can stringify a feature that has a background' do
            source  = ["#{FEATURE_KEYWORD}:",
                       "#{BACKGROUND_KEYWORD}:",
                       "#{STEP_KEYWORD} a step"]
            source  = source.join("\n")
            feature = clazz.new(source)

            feature_output = feature.to_s.split("\n", -1)

            expect(feature_output).to eq(["#{FEATURE_KEYWORD}:",
                                          '',
                                          "  #{BACKGROUND_KEYWORD}:",
                                          "    #{STEP_KEYWORD} a step"])
          end

          it 'can stringify a feature that has a rule' do
            source = ["#{FEATURE_KEYWORD}:",
                      "#{RULE_KEYWORD}:",
                      "#{SCENARIO_KEYWORD}:",
                      "#{STEP_KEYWORD} a step"]

            source  = source.join("\n")
            feature = clazz.new(source)

            feature_output = feature.to_s.split("\n", -1)

            expect(feature_output).to eq(["#{FEATURE_KEYWORD}:",
                                          '',
                                          "  #{RULE_KEYWORD}:",
                                          '',
                                          "    #{SCENARIO_KEYWORD}:",
                                          "      #{STEP_KEYWORD} a step"])
          end

          it 'can stringify a feature that has a scenario' do
            source  = ["#{FEATURE_KEYWORD}:",
                       "#{SCENARIO_KEYWORD}:",
                       "#{STEP_KEYWORD} a step"]
            source  = source.join("\n")
            feature = clazz.new(source)

            feature_output = feature.to_s.split("\n", -1)

            expect(feature_output).to eq(["#{FEATURE_KEYWORD}:",
                                          '',
                                          "  #{SCENARIO_KEYWORD}:",
                                          "    #{STEP_KEYWORD} a step"])
          end

          it 'can stringify a feature that has an outline' do
            source  = ["#{FEATURE_KEYWORD}:",
                       "#{OUTLINE_KEYWORD}:",
                       "#{STEP_KEYWORD} a step",
                       "#{EXAMPLE_KEYWORD}:",
                       '|param|',
                       '|value|']
            source  = source.join("\n")
            feature = clazz.new(source)

            feature_output = feature.to_s.split("\n", -1)

            expect(feature_output).to eq(["#{FEATURE_KEYWORD}:",
                                          '',
                                          "  #{OUTLINE_KEYWORD}:",
                                          "    #{STEP_KEYWORD} a step",
                                          '',
                                          "  #{EXAMPLE_KEYWORD}:",
                                          '    | param |',
                                          '    | value |'])
          end

          # The maximal feature case
          it 'can stringify a feature that has everything' do
            source  = ['@tag1 @tag2 @tag3',
                       "#{FEATURE_KEYWORD}: A feature with everything it could have",
                       'Including a description',
                       'and then some.',
                       "#{BACKGROUND_KEYWORD}: non-nested background",
                       'Background',
                       'description',
                       "#{STEP_KEYWORD} a step",
                       '|value1|',
                       '|value2|',
                       "#{STEP_KEYWORD} another step",
                       '@scenario_tag',
                       "#{SCENARIO_KEYWORD}: non-nested scenario",
                       'Scenario',
                       'description',
                       "#{STEP_KEYWORD} a step",
                       "#{STEP_KEYWORD} another step",
                       '""" with content type',
                       'some text',
                       '"""',
                       "#{RULE_KEYWORD}: a rule",
                       'Rule description ',
                       "#{BACKGROUND_KEYWORD}: nested background",
                       "#{STEP_KEYWORD} a step",
                       '@outline_tag',
                       "#{OUTLINE_KEYWORD}: nested outline",
                       'Outline',
                       'description',
                       "#{STEP_KEYWORD} a step",
                       '|value2|',
                       "#{STEP_KEYWORD} another step",
                       '"""',
                       'some text',
                       '"""',
                       '@example_tag',
                       "#{EXAMPLE_KEYWORD}:",
                       'Example',
                       'description',
                       '|param|',
                       '|value|',
                       "#{EXAMPLE_KEYWORD}: additional example",
                       "#{RULE_KEYWORD}: another rule",
                       'Which is empty']
            source  = source.join("\n")
            feature = clazz.new(source)

            feature_output = feature.to_s.split("\n", -1)

            expect(feature_output).to eq(['@tag1 @tag2 @tag3',
                                          "#{FEATURE_KEYWORD}: A feature with everything it could have",
                                          '',
                                          'Including a description',
                                          'and then some.',
                                          '',
                                          "  #{BACKGROUND_KEYWORD}: non-nested background",
                                          '',
                                          '  Background',
                                          '  description',
                                          '',
                                          "    #{STEP_KEYWORD} a step",
                                          '      | value1 |',
                                          '      | value2 |',
                                          "    #{STEP_KEYWORD} another step",
                                          '',
                                          '  @scenario_tag',
                                          "  #{SCENARIO_KEYWORD}: non-nested scenario",
                                          '',
                                          '  Scenario',
                                          '  description',
                                          '',
                                          "    #{STEP_KEYWORD} a step",
                                          "    #{STEP_KEYWORD} another step",
                                          '      """ with content type',
                                          '      some text',
                                          '      """',
                                          '',
                                          "  #{RULE_KEYWORD}: a rule",
                                          '',
                                          '  Rule description',
                                          '',
                                          "    #{BACKGROUND_KEYWORD}: nested background",
                                          "      #{STEP_KEYWORD} a step",
                                          '',
                                          '    @outline_tag',
                                          "    #{OUTLINE_KEYWORD}: nested outline",
                                          '',
                                          '    Outline',
                                          '    description',
                                          '',
                                          "      #{STEP_KEYWORD} a step",
                                          '        | value2 |',
                                          "      #{STEP_KEYWORD} another step",
                                          '        """',
                                          '        some text',
                                          '        """',
                                          '',
                                          '    @example_tag',
                                          "    #{EXAMPLE_KEYWORD}:",
                                          '',
                                          '    Example',
                                          '    description',
                                          '',
                                          '      | param |',
                                          '      | value |',
                                          '',
                                          "    #{EXAMPLE_KEYWORD}: additional example",
                                          '',
                                          "  #{RULE_KEYWORD}: another rule",
                                          '',
                                          '  Which is empty'])
          end

        end


        context 'from abstract instantiation' do

          let(:feature) { clazz.new }


          describe 'edge cases' do

            # These cases would not produce valid Gherkin and so don't have any useful output
            # but they need to at least not explode

            it 'can stringify a feature that has only tags' do
              feature.tags = [CukeModeler::Tag.new]

              expect { feature.to_s }.to_not raise_error
            end

            it 'can stringify a feature that has only a background' do
              feature.background = [CukeModeler::Background.new]

              expect { feature.to_s }.to_not raise_error
            end

            it 'can stringify a feature that has only rules' do
              feature.rules = [CukeModeler::Rule.new]

              expect { feature.to_s }.to_not raise_error
            end

            it 'can stringify a feature that has only scenarios' do
              feature.tests = [CukeModeler::Scenario.new]

              expect { feature.to_s }.to_not raise_error
            end

            it 'can stringify a feature that has only outlines' do
              feature.tests = [CukeModeler::Outline.new]

              expect { feature.to_s }.to_not raise_error
            end

          end

        end

      end

    end

  end


  describe 'stuff that is in no way part of the public API and entirely subject to change' do

    it 'provides a useful explosion message if it encounters an entirely new type of feature child' do
      begin
        CukeModeler::HelperMethods.test_storage[:old_method] = CukeModeler::Parsing.method(:parse_text)


        # Monkey patch the parsing method to mimic what would essentially be Gherkin creating new
        # types of language objects
        module CukeModeler
          module Parsing # rubocop:disable Style/Documentation
            class << self
              def parse_text(source_text, filename)
                result = CukeModeler::HelperMethods.test_storage[:old_method].call(source_text, filename)

                result['feature']['elements'].first['type'] = :some_unknown_type

                result
              end
            end
          end
        end


        expect { clazz.new("#{FEATURE_KEYWORD}:\n#{SCENARIO_KEYWORD}:\n#{STEP_KEYWORD} foo") }
          .to raise_error(ArgumentError, /Unknown.*some_unknown_type/)
      ensure
        # Making sure that our changes don't escape a test and ruin the rest of the suite
        module CukeModeler
          module Parsing # rubocop:disable Style/Documentation
            class << self
              define_method(:parse_text, CukeModeler::HelperMethods.test_storage[:old_method])
            end
          end
        end
      end
    end

  end

end
