module CukeModeler

  # A class modeling a Cucumber Scenario Outline.

  class Outline < TestElement

    include Taggable


    # The Example objects contained by the Outline
    attr_accessor :examples


    # Creates a new Outline object and, if *source* is provided, populates the
    # object.
    def initialize(source = nil)
      parsed_outline = process_source(source, 'cuke_modeler_stand_alone_outline.feature')

      super(parsed_outline)

      @tags = []
      @tag_elements = []
      @examples = []

      build_outline(parsed_outline) if parsed_outline
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
      text << "\n" + description_output_string unless description_text.empty?
      text << "\n" unless steps.empty? || description_text.empty?
      text << "\n" + steps_output_string unless steps.empty?
      text << "\n\n" + examples_output_string unless examples.empty?

      text
    end


    private


    def build_outline(parsed_outline)
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
