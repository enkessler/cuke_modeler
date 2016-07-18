module CukeModeler

  # A class modeling a Cucumber Scenario Outline.

  class Outline < ModelElement

    include Raw
    include Named
    include Described
    include Stepped
    include Sourceable
    include Taggable


    # The Example objects contained by the Outline
    attr_accessor :examples


    # Creates a new Outline object and, if *source* is provided, populates the
    # object.
    def initialize(source_text = nil)
      @name = ''
      @description = ''
      @steps = []
      @tags = []
      @examples = []

      super(source_text)

      if source_text
        parsed_outline_data = parse_source(source_text)
        populate_outline(self, parsed_outline_data)
      end
    end

    # Returns true if the two elements have equivalent steps and false otherwise.
    def ==(other_element)
      return false unless other_element.respond_to?(:steps)

      steps == other_element.steps
    end

    # Returns the model objects that belong to this model.
    def children
      examples + steps + tags
    end

    # Returns a gherkin representation of the outline.
    def to_s
      text = ''

      text << tag_output_string + "\n" unless tags.empty?
      text << "Scenario Outline:#{name_output_string}"
      text << "\n" + description_output_string unless description.empty?
      text << "\n" unless steps.empty? || description.empty?
      text << "\n" + steps_output_string unless steps.empty?
      text << "\n\n" + examples_output_string unless examples.empty?

      text
    end


    private


    def parse_source(source_text)
      base_file_string = "Feature: Fake feature to parse\n"
      source_text = base_file_string + source_text

      parsed_file = Parsing::parse_text(source_text, 'cuke_modeler_stand_alone_outline.feature')

      parsed_file.first['elements'].first
    end

    def examples_output_string
      examples.empty? ? '' : examples.collect { |example| example.to_s }.join("\n\n")
    end

  end
end
