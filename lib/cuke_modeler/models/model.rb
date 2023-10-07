module CukeModeler

  # A class modeling an element of a Cucumber suite.
  class Model

    include Nested
    include Containing

    # TODO: add @example tags to other methods
    # TODO: add @option/param tags to other methods
    # TODO: add @raise tags to other methods
    # TODO: add @return tags to other methods
    # TODO: add @yield/@yieldparam/@yieldreturn tags to other methods

    # Creates a new Model object and, if *source_text* is provided,
    # populates the object. For the base model class, there is nothing
    # to populate.
    #
    # @example
    #   Model.new
    #   Model.new('some source text')
    #
    # @param source_text [String] The string that will be used to populate the model
    # @raise [ArgumentError] If *source_text* is not a String
    def initialize(source_text = nil)
      error_message = "Can only create models from Strings but was given a #{source_text.class}."
      raise(ArgumentError, error_message) if source_text && !source_text.is_a?(String)

      return unless source_text

      source_data = process_source(source_text)
      populate_model(source_data)
    end

    # It's a lazy implementation but it's mandatory for the class to define this method
    # rubocop:disable Lint/UselessMethodDefinition

    # Returns a string representation of this model.
    def to_s
      super
    end

    # rubocop:enable Lint/UselessMethodDefinition

    # Returns the model objects that belong to this model.
    def children
      []
    end

    # See `Object#inspect`. Returns some basic information about the
    # object, including its class and object ID.
    def inspect(verbose: false)
      return super() if verbose

      "#<#{self.class.name}:#{object_id}>"
    end


    private


    def process_source(source_text)
      # No-op
    end

    def populate_model(model_data)
      # No-op
    end

  end
end
