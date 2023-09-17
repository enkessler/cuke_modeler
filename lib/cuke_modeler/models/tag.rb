module CukeModeler

  # A class modeling a tag.
  class Tag < Model

    include Parsing
    include Parsed
    include Sourceable


    # The name of the tag
    attr_accessor :name


    # Creates a new Tag object and, if *source_text* is provided, populates the
    # object.
    def initialize(source_text = nil)
      super(source_text)

      return unless source_text

      parsed_tag_data = parse_source(source_text)
      populate_tag(self, parsed_tag_data)
    end

    # Returns a string representation of this model. For a tag model,
    # this will be Gherkin text that is equivalent to the tag being modeled.
    def to_s
      name || ''
    end

    # See `Object#inspect`. Returns some basic information about the
    # object, including its class, object ID, and its most meaningful
    # attribute. For a tag model, this will be the name of the tag.
    def inspect
      base = super

      "#{base.chop} @name: #{@name.inspect}>"
    end


    private


    def parse_source(source_text)
      base_file_string = "\n#{dialect_feature_keyword}: Fake feature to parse"
      source_text = "# language: #{Parsing.dialect}\n" + source_text + base_file_string

      parsed_file = Parsing.parse_text(source_text, 'cuke_modeler_stand_alone_tag.feature')

      parsed_file['feature']['tags'].first
    end

    def populate_name(model, parsed_model_data)
      model.name = parsed_model_data['name']
    end

  end
end
