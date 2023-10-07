module CukeModeler

  # A class modeling a feature in a Cucumber suite.
  class Feature < Model

    include Parsed
    include Named
    include Described
    include Taggable
    include Sourceable


    # The language for the feature
    attr_accessor :language

    # The keyword for the feature
    attr_accessor :keyword

    # The Background object contained by the Feature
    attr_accessor :background

    # The Rule objects contained by the Feature
    attr_accessor :rules

    # The Scenario and Outline objects contained by the Feature
    attr_accessor :tests


    # Creates a new Feature object and, if *source_text* is provided, populates the
    # object.
    def initialize(source_text = nil)
      @tags = []
      @rules = []
      @tests = []

      super(source_text)
    end

    # Returns *true* if the feature contains a background, *false* otherwise.
    def background?
      !@background.nil?
    end

    alias has_background? background?

    # Returns the scenario models contained in the feature.
    def scenarios
      @tests.select { |test| test.is_a? Scenario }
    end

    # Returns the outline models contained in the feature.
    def outlines
      @tests.select { |test| test.is_a? Outline }
    end

    # TODO: Remove this and other deprecated methods on next major version release

    # @deprecated See CHANGELOG
    #
    # Returns the number of test cases contained in the feature. A test case is a
    # single set of test values, such as an individual scenario or one example row
    # of an outline.
    def test_case_count
      scenarios.count + outlines.reduce(0) do |outline_sum, outline|
        outline_sum + outline.examples.reduce(0) do |example_sum, example|
          example_sum + example.argument_rows.count
        end
      end
    end

    # Returns the model objects that belong to this model.
    def children
      models = rules + tests + tags
      models << background if background

      models
    end

    # Building strings just isn't pretty
    # rubocop:disable Metrics/AbcSize

    # Returns a string representation of this model. For a feature model,
    # this will be Gherkin text that is equivalent to the feature being modeled.
    def to_s
      text = ''

      text << "#{tag_output_string}\n" unless tags.empty?
      text << "#{@keyword}:#{name_output_string}"
      text << "\n#{description_output_string}" unless no_description_to_output?
      text << "\n\n#{background_output_string}" if background
      text << "\n\n#{tests_output_string}" unless tests.empty?
      text << "\n\n#{rules_output_string}" unless rules.empty?

      text
    end

    # rubocop:enable Metrics/AbcSize

    # See `Object#inspect`. Returns some basic information about the
    # object, including its class, object ID, and its most meaningful
    # attribute. For a feature model, this will be the name of the feature.
    def inspect(verbose: false)
      return super(verbose: verbose) if verbose

      "#{super.chop} @name: #{name.inspect}>"
    end


    private


    def process_source(source_text)
      parsed_file = Parsing.parse_text(source_text, 'cuke_modeler_stand_alone_feature.feature')

      parsed_file['feature']
    end

    def populate_model(parsed_feature_data)
      populate_parsing_data(parsed_feature_data)
      populate_source_location(parsed_feature_data)
      populate_language(parsed_feature_data)
      populate_keyword(parsed_feature_data)
      populate_name(parsed_feature_data)
      populate_description(parsed_feature_data)
      populate_tags(parsed_feature_data)
      populate_children(parsed_feature_data)
    end

    def populate_language(parsed_feature_data)
      @language = parsed_feature_data['language']
    end

    def background_output_string
      child_element_output_string(background)
    end

    def tests_output_string
      tests.collect { |test| child_element_output_string(test) }.join("\n\n")
    end

    def rules_output_string
      rules.collect { |rule| child_element_output_string(rule) }.join("\n\n")
    end

    def child_element_output_string(model)
      model.to_s.split("\n").collect { |line| line.empty? ? '' : "  #{line}" }.join("\n")
    end

  end
end
