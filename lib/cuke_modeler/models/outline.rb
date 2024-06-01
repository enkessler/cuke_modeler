module CukeModeler

  # A class modeling an individual outline in a Cucumber suite.
  class Outline < Model

    include Parsing
    include Parsed
    include Named
    include Described
    include Stepped
    include Sourceable
    include Taggable


    # The outline's keyword
    attr_accessor :keyword

    # The Example objects contained by the Outline
    attr_accessor :examples


    # Creates a new Outline object and, if *source_text* is provided, populates the
    # object.
    #
    # @example
    #   Outline.new
    #   Outline.new("Scenario Outline:\n  * a step")
    #
    # @param source_text [String] The Gherkin text that will be used to populate the model
    # @raise [ArgumentError] If *source_text* is not a String
    # @return [Outline] A new Outline instance
    def initialize(source_text = nil)
      @steps = []
      @tags = []
      @examples = []

      super
    end

    # Compares this model with another object. Returns *true* if the two objects
    # have equivalent steps and *false* otherwise.
    #
    # @example
    #   outline_1 == outline_2
    #
    # @param other [Object] The object to compare this model with
    # @return [Boolean] Whether the two objects are equivalent
    def ==(other)
      return false unless other.respond_to?(:steps)

      steps == other.steps
    end

    # Returns the model objects that are children of this model. For
    # an Outline model, these would be any associated Step, Tag, or
    # Example models.
    #
    # @example
    #   outline.children
    #
    # @return [Array<Step, Tag, Example>] A collection of child models
    def children
      examples + steps + tags
    end

    # Building strings just isn't pretty
    # rubocop:disable Metrics/AbcSize

    # Returns a string representation of this model. For an Outline model,
    # this will be Gherkin text that is equivalent to the outline being modeled.
    #
    # @example
    #   outline.to_s
    #
    # @return [String] A string representation of this model
    def to_s
      text = ''

      text << "#{tag_output_string}\n" unless tags.empty?
      text << "#{@keyword}:#{name_output_string}"
      text << "\n#{description_output_string}" unless no_description_to_output?
      text << "\n" unless steps.empty? || no_description_to_output?
      text << "\n#{steps_output_string}" unless steps.empty?
      text << "\n\n#{examples_output_string}" unless examples.empty?

      text
    end

    # rubocop:enable Metrics/AbcSize

    # See `Object#inspect`. Returns some basic information about the
    # object, including its class, object ID, and its most meaningful
    # attribute. For an Outline model, this will be the name of the
    # outline. If *verbose* is true, provides default Ruby inspection
    # behavior instead.
    #
    # @example
    #   outline.inspect
    #   outline.inspect(verbose: true)
    #
    # @param verbose [Boolean] Whether or not to return the full details of
    #   the object. Defaults to false.
    # @return [String] A string representation of this model
    def inspect(verbose: false)
      return super if verbose

      "#{super.chop} @name: #{name.inspect}>"
    end


    private


    def process_source(source_text)
      base_file_string = "# language: #{Parsing.dialect}\n#{dialect_feature_keyword}: Fake feature to parse\n"
      source_text = base_file_string + source_text

      parsed_file = Parsing.parse_text(source_text, 'cuke_modeler_stand_alone_outline.feature')

      parsed_file['feature']['elements'].first
    end

    def populate_model(parsed_outline_data)
      populate_parsing_data(parsed_outline_data)
      populate_source_location(parsed_outline_data)
      populate_keyword(parsed_outline_data)
      populate_name(parsed_outline_data)
      populate_description(parsed_outline_data)
      populate_steps(parsed_outline_data)
      populate_tags(parsed_outline_data)
      populate_outline_examples(parsed_outline_data['examples']) if parsed_outline_data['examples']
    end

    def populate_outline_examples(parsed_examples)
      parsed_examples.each do |example_data|
        @examples << build_child_model(Example, example_data)
      end
    end

    def examples_output_string
      examples.empty? ? '' : examples.join("\n\n")
    end

  end
end
