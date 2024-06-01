module CukeModeler

  # A class modeling a feature's background.
  class Background < Model

    include Parsing
    include Parsed
    include Named
    include Described
    include Stepped
    include Sourceable


    # The background's keyword
    attr_accessor :keyword


    # Creates a new Background object and, if *source_text* is provided, populates
    # the object.
    #
    # @example
    #   Background.new
    #   Background.new("Background:\n  * a step")
    #
    # @param source_text [String] The Gherkin text that will be used to populate the model
    # @raise [ArgumentError] If *source_text* is not a String
    # @return [Background] A new Background instance
    def initialize(source_text = nil)
      @steps = []

      super
    end

    # TODO: Have (all) models be equivalent if they have the same #to_s output. Would
    # likely require major version change.

    # Compares this model with another object. Returns *true* if the two objects
    # have equivalent steps and *false* otherwise.
    #
    # @example
    #   background_1 == background_2
    #
    # @param other [Object] The object to compare this model with
    # @return [Boolean] Whether the two objects are equivalent
    def ==(other)
      return false unless other.respond_to?(:steps)

      steps == other.steps
    end

    # Returns the model objects that are children of this model. For a
    # Background model, these would be any associated Step models.
    #
    # @example
    #   background.children
    #
    # @return [Array<Step>] A collection of child models
    def children
      steps
    end

    # Returns a string representation of this model. For a Background model,
    # this will be Gherkin text that is equivalent to the background being modeled.
    #
    # @example
    #   background.to_s
    #
    # @return [String] A string representation of this model
    def to_s
      text = ''

      text << "#{@keyword}:#{name_output_string}"
      text << "\n#{description_output_string}" unless no_description_to_output?
      text << "\n" unless steps.empty? || no_description_to_output?
      text << "\n#{steps_output_string}" unless steps.empty?

      text
    end

    # See `Object#inspect`. Returns some basic information about the
    # object, including its class, object ID, and its most meaningful
    # attribute. For a Background model, this will be the name of the
    # background. If *verbose* is true, provides default Ruby inspection
    # behavior instead.
    #
    # @example
    #   background.inspect
    #   background.inspect(verbose: true)
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

      parsed_file = Parsing.parse_text(source_text, 'cuke_modeler_stand_alone_background.feature')

      parsed_file['feature']['elements'].first
    end

    def populate_model(parsed_background_data)
      populate_parsing_data(parsed_background_data)
      populate_keyword(parsed_background_data)
      populate_name(parsed_background_data)
      populate_description(parsed_background_data)
      populate_source_location(parsed_background_data)
      populate_steps(parsed_background_data)
    end

  end
end
