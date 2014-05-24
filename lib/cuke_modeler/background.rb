module CukeModeler

  # A class modeling a Cucumber feature's Background.

  class Background < ModelElement

    include Named
    include Described
    include Sourceable
    include Containing


    attr_accessor :steps


    # Creates a new Background object and, if *source* is provided, populates
    # the object.
    def initialize(source = nil)
      parsed_background = process_source(source)

      @name = ''
      @description = ''
      @steps = []

      build_background(parsed_background) if parsed_background
    end

    # Returns gherkin representation of the background.
    def to_s
      text = ''

      text << "Background:#{name_output_string}"
      text << "\n" + description_output_string unless description.empty?

      text
    end

    def contains
      steps
    end


    private


    def parse_model(source_text)
      base_file_string = "Feature: Fake feature to parse\n"
      source_text = base_file_string + source_text

      parsed_file = Parsing::parse_text(source_text)

      parsed_file.first['elements'].first
    end

    def build_background(parsed_background)
      populate_name(parsed_background)
      populate_source_line(parsed_background)
      populate_description(parsed_background)
      populate_steps(parsed_background)
    end

    def populate_steps(parsed_background)
      if parsed_background['steps']
        parsed_background['steps'].each do |step|
          @steps << build_child_element(Step, step)
        end
      end
    end

  end
end
