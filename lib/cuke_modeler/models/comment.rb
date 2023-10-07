module CukeModeler

  # A class modeling a comment in a feature file.
  class Comment < Model

    include Parsing
    include Parsed
    include Sourceable


    # The text of the comment
    attr_accessor :text


    # Creates a new Comment object and, if *source_text* is provided, populates the
    # object.
    def initialize(source_text = nil)
      super(source_text)
    end

    # Returns a string representation of this model. For a comment model,
    # this will be Gherkin text that is equivalent to the comment being modeled.
    def to_s
      text || ''
    end

    # See `Object#inspect`. Returns some basic information about the
    # object, including its class, object ID, and its most meaningful
    # attribute. For a comment model, this will be the text of the comment.
    def inspect(verbose: false)
      return super(verbose: verbose) if verbose

      "#{super.chop} @text: #{text.inspect}>"
    end


    private


    def process_source(source_text)
      base_file_string = "\n#{dialect_feature_keyword}: Fake feature to parse"
      source_text = "# language: #{Parsing.dialect}\n" + source_text + base_file_string

      parsed_file = Parsing.parse_text(source_text, 'cuke_modeler_stand_alone_comment.feature')

      parsed_file['comments'].last
    end

    def populate_model(processed_comment_data)
      populate_comment_text(processed_comment_data)
      populate_parsing_data(processed_comment_data)
      populate_source_location(processed_comment_data)
    end

    def populate_comment_text(parsed_comment_data)
      @text = parsed_comment_data['text'].strip
    end

  end
end
