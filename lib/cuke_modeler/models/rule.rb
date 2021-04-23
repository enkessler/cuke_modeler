module CukeModeler

  # A class modeling a rule in a Cucumber suite.
  class Rule < Model

    include Parsing
    include Parsed
    include Named
    include Described
    include Taggable
    include Sourceable


    # The keyword for the rule
    attr_accessor :keyword

    # The Background object contained by the Rule
    attr_accessor :background

    # The Scenario and Outline objects contained by the Rule
    attr_accessor :tests


    # Creates a new Rule object and, if *source_text* is provided, populates the
    # object.
    def initialize(source_text = nil)
      @tags = []
      @tests = []

      super(source_text)

      return unless source_text

      parsed_rule_data = parse_source(source_text)
      populate_rule(self, parsed_rule_data)
    end

    # Returns *true* if the rule contains a background, *false* otherwise.
    def background?
      !@background.nil?
    end

    alias has_background? background?

    # Returns the scenario models contained in the rule.
    def scenarios
      @tests.select { |test| test.is_a? Scenario }
    end

    # Returns the outline models contained in the rule.
    def outlines
      @tests.select { |test| test.is_a? Outline }
    end

    # Returns the model objects that belong to this model.
    def children
      models = tests + tags
      models << background if background

      models
    end

    # Building strings just isn't pretty
    # rubocop:disable Metrics/AbcSize

    # Returns a string representation of this model. For a rule model,
    # this will be Gherkin text that is equivalent to the rule being modeled.
    def to_s
      text = ''

      text << "#{tag_output_string}\n" unless tags.empty?
      text << "#{@keyword}:#{name_output_string}"
      text << "\n#{description_output_string}" unless no_description_to_output?
      text << "\n\n#{background_output_string}" if background
      text << "\n\n#{tests_output_string}" unless tests.empty?

      text
    end
    # rubocop:enable Metrics/AbcSize


    private


    def parse_source(source_text)
      base_file_string = "# language: #{Parsing.dialect}\n#{dialect_feature_keyword}: Fake feature to parse\n"
      source_text = base_file_string + source_text

      parsed_file = Parsing.parse_text(source_text, 'cuke_modeler_stand_alone_rule.feature')

      parsed_file['feature']['elements'].first
    end

    def background_output_string
      test_output_string(background)
    end

    def tests_output_string
      tests.collect { |test| test_output_string(test) }.join("\n\n")
    end

    def test_output_string(model)
      model.to_s.split("\n").collect { |line| line.empty? ? '' : "  #{line}" }.join("\n")
    end

  end
end
