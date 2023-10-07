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
    def initialize(source_text = nil)
      @steps = []

      super(source_text)
    end

    # Returns *true* if the two models have equivalent steps and *false* otherwise.
    def ==(other)
      return false unless other.respond_to?(:steps)

      steps == other.steps
    end

    # Returns the model objects that belong to this model.
    def children
      steps
    end

    # Returns a string representation of this model. For a background model,
    # this will be Gherkin text that is equivalent to the background being modeled.
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
    # attribute. For a background model, this will be the name of the
    # background.
    def inspect(verbose: false)
      return super(verbose: verbose) if verbose

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
