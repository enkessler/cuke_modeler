module CukeModeler

  # A mix-in module containing methods used by elements that have a description.

  module Described

    # Deprecated
    #
    # The description of the element
    attr_accessor :description

    # The description of the element
    attr_accessor :description_text


    private


    def populate_description(parsed_element)
      @description_text = parsed_element['description']
      @description = parsed_element['description'].split("\n").collect { |line| line.strip }
      @description.delete('')
    end

    def description_output_string
      text = ''

      unless description.empty?
        description_lines = description_text.split("\n")

        text << "  \n" if description_lines.first =~ /\S/
        text << description_lines.collect { |line| "  #{line}" }.join("\n")
      end

      text
    end

  end
end
