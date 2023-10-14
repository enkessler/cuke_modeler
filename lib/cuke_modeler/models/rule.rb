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
    #
    # @example
    #   Rule.new
    #   Rule.new("Rule:\nThis is a rule")
    #
    # @param source_text [String] The Gherkin text that will be used to populate the model
    # @raise [ArgumentError] If *source_text* is not a String
    # @return [Rule] A new Rule instance
    def initialize(source_text = nil)
      @tags = []
      @tests = []

      super(source_text)
    end

    # Returns *true* if the rule contains a background, *false* otherwise.
    #
    # @example
    #   rule.background?
    #
    # @return [Boolean] Whether the rule contains a background
    def background?
      !@background.nil?
    end

    alias has_background? background?

    # Returns the scenario models contained in the rule.
    #
    # @example
    #   rule.scenarios
    #
    # @return [Array<Scenario>] Child Scenario models
    def scenarios
      @tests.select { |test| test.is_a? Scenario }
    end

    # Returns the outline models contained in the rule.
    #
    # @example
    #   rule.outlines
    #
    # @return [Array<Outline>] Child Outline models
    def outlines
      @tests.select { |test| test.is_a? Outline }
    end

    # Returns the model objects that are children of this model. For a
    # Rule model, these would be any associated Background, Scenario,
    # Outline, or Tag models.
    #
    # @example
    #   rule.children
    #
    # @return [Array<Background, Scenario, Outline, Tag>] A collection of child models
    def children
      models = tests + tags
      models << background if background

      models
    end

    # Returns a string representation of this model. For a Rule model,
    # this will be Gherkin text that is equivalent to the rule being modeled.
    #
    # @example
    #   rule.to_s
    #
    # @return [String] A string representation of this model
    def to_s
      text = ''

      text << "#{tag_output_string}\n" unless tags.empty?
      text << "#{@keyword}:#{name_output_string}"
      text << "\n#{description_output_string}" unless no_description_to_output?
      text << "\n\n#{background_output_string}" if background
      text << "\n\n#{tests_output_string}" unless tests.empty?

      text
    end

    # See `Object#inspect`. Returns some basic information about the
    # object, including its class, object ID, and its most meaningful
    # attribute. For a Rule model, this will be the name of the rule.
    # If *verbose* is true, provides default Ruby inspection behavior
    # instead.
    #
    # @example
    #   rule.inspect
    #   rule.inspect(verbose: true)
    #
    # @param verbose [Boolean] Whether or not to return the full details of
    #   the object. Defaults to false.
    # @return [String] A string representation of this model
    def inspect(verbose: false)
      return super(verbose: verbose) if verbose

      "#{super.chop} @name: #{@name.inspect}>"
    end


    private


    def process_source(source_text)
      base_file_string = "# language: #{Parsing.dialect}\n#{dialect_feature_keyword}: Fake feature to parse\n"
      source_text = base_file_string + source_text

      parsed_file = Parsing.parse_text(source_text, 'cuke_modeler_stand_alone_rule.feature')

      parsed_file['feature']['elements'].first
    end

    def populate_model(parsed_rule_data)
      populate_parsing_data(parsed_rule_data)
      populate_source_location(parsed_rule_data)
      populate_keyword(parsed_rule_data)
      populate_name(parsed_rule_data)
      populate_description(parsed_rule_data)
      populate_tags(parsed_rule_data)
      populate_children(parsed_rule_data)
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
