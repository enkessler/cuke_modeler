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
    def initialize(source_text = nil)
      @steps = []
      @tags = []
      @examples = []

      super(source_text)

      return unless source_text

      parsed_outline_data = parse_source(source_text)
      populate_outline(self, parsed_outline_data)
    end

    # Returns *true* if the two models have equivalent steps and *false* otherwise.
    def ==(other)
      return false unless other.respond_to?(:steps)

      steps == other.steps
    end

    # Returns the model objects that belong to this model.
    def children
      examples + steps + tags
    end

    # Building strings just isn't pretty
    # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity

    # Returns a string representation of this model. For an outline model,
    # this will be Gherkin text that is equivalent to the outline being modeled.
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

    # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity


    private


    def parse_source(source_text)
      base_file_string = "# language: #{Parsing.dialect}\n#{dialect_feature_keyword}: Fake feature to parse\n"
      source_text = base_file_string + source_text

      parsed_file = Parsing.parse_text(source_text, 'cuke_modeler_stand_alone_outline.feature')

      parsed_file['feature']['elements'].first
    end

    def examples_output_string
      examples.empty? ? '' : examples.join("\n\n")
    end

  end
end
