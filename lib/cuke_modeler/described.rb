module CukeModeler

  # A mix-in module containing methods used by elements that have a description.

  module Described

    # The description of the element
    attr_accessor :description


    private


    def description_output_string
      text = ''

      unless description.empty?
        description_lines = description.split("\n")

        text << "\n" if description_lines.first =~ /\S/
        text << description_lines.collect { |line| "#{line}" }.join("\n")
      end

      text
    end

  end
end
