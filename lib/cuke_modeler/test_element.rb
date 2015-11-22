module CukeModeler

  # A class modeling an element that contains steps.

  class TestElement < FeatureElement

    include Containing


    # The steps contained by the TestElement
    attr_accessor :steps


    # Creates a new TestElement object and, if *parsed_test_element* is provided,
    # populates the object.
    def initialize(parsed_test_element = nil)
      super

      @steps = []

      build_test_element(parsed_test_element) if parsed_test_element
    end

    # Returns true if the two elements have equivalent steps and false otherwise.
    def ==(other_element)
      return false unless other_element.respond_to?(:steps)

      steps == other_element.steps
    end

    # Returns the immediate child elements of the element.
    def contains
      @steps
    end


    private


    def process_source(source)
      case
        when source.is_a?(String)
          parse_test_element(source)
        else
          source
      end
    end

    def parse_test_element(source_text)
      base_file_string = "Feature: Fake feature to parse\n"
      source_text = base_file_string + source_text

      parsed_file = Parsing::parse_text(source_text)

      parsed_file.first['elements'].first
    end

    def build_test_element(parsed_test_element)
      populate_test_element_steps(parsed_test_element)
    end

    def populate_test_element_steps(parsed_test_element)
      if parsed_test_element['steps']
        parsed_test_element['steps'].each do |step|
          @steps << build_child_element(Step, step)
        end
      end
    end

    def steps_output_string
      steps.collect { |step| indented_step_text(step) }.join("\n")
    end

    def indented_step_text(step)
      step.to_s.split("\n").collect { |line| "  #{line}" }.join("\n")
    end

  end
end
