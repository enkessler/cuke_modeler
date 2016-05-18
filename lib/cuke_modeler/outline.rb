module CukeModeler

  # A class modeling a Cucumber Scenario Outline.

  class Outline < ModelElement

    include Raw
    include Named
    include Described
    include Stepped
    include Sourceable
    include Containing
    include Taggable


    # The Example objects contained by the Outline
    attr_accessor :examples


    # Creates a new Outline object and, if *source* is provided, populates the
    # object.
    def initialize(source = nil)
      parsed_outline = process_source(source)

      super(parsed_outline)


      @name = ''
      @description = ''
      @steps = []
      @tags = []
      @examples = []

      build_outline(parsed_outline) if parsed_outline
    end

    # Returns true if the two elements have equivalent steps and false otherwise.
    def ==(other_element)
      return false unless other_element.respond_to?(:steps)

      steps == other_element.steps
    end

    # Returns the immediate child elements of the outline (i.e. its Example
    # objects.
    def children
      @examples + @steps
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


    def parse_model(source_text)
      base_file_string = "Feature: Fake feature to parse\n"
      source_text = base_file_string + source_text

      parsed_file = Parsing::parse_text(source_text, 'cuke_modeler_stand_alone_outline.feature')

      parsed_file.first['elements'].first
    end

    def build_outline(parsed_outline)
      populate_raw_element(parsed_outline)
      populate_element_source_line(parsed_outline)
      populate_name(parsed_outline)
      populate_description(parsed_outline)
      populate_steps(parsed_outline)
      populate_element_tags(parsed_outline)
      populate_outline_examples(parsed_outline['examples']) if parsed_outline['examples']
    end

    def populate_outline_examples(parsed_examples)
      parsed_examples.each do |example|
        @examples << build_child_element(Example, example)
      end
    end

    def examples_output_string
      examples.empty? ? '' : examples.collect { |example| example.to_s }.join("\n\n")
    end

  end
end
