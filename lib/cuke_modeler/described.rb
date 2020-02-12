module CukeModeler

  # NOT A PART OF THE PUBLIC API
  # A mix-in module containing methods used by models that represent an element that has a description.

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
