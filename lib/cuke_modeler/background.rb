module CukeModeler

  # A class modeling a Cucumber feature's Background.

  class Background < TestElement

    # Creates a new Background object and, if *source* is provided, populates
    # the object.
    def initialize(source = nil)
      parsed_background = process_source(source, 'cuke_modeler_stand_alone_background.feature')

      super(parsed_background)

      build_background(parsed_background) if parsed_background
    end

    # Returns gherkin representation of the background.
    def to_s
      text = ''

      text << "Background:#{name_output_string}"
      text << "\n" + description_output_string unless description_text.empty?
      text << "\n" unless steps.empty? || description_text.empty?
      text << "\n" + steps_output_string unless steps.empty?

      text
    end


    private


    def build_background(parsed_background)
      # Just a stub in case something specific needs to be done
    end

  end
end
