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
        text << description_lines.join("\n")
      end

      text
    end

    def no_description_to_output?
      description.nil? || description.empty?
    end

    def populate_description(model, parsed_model_data)
      model.description = trimmed_description(parsed_model_data['description'])
    end

    def trimmed_description(description)
      description = description.split("\n")

      trim_leading_blank_lines(description)
      trim_trailing_blank_lines(description)
      trim_leading_spaces(description)
      trim_trailing_spaces(description)

      description.join("\n")
    end

    def trim_leading_blank_lines(description)
      description.replace(description.drop_while { |line| line !~ /\S/ })
    end

    def trim_trailing_blank_lines(_description)
      # Nothing to do. Already done by the parser but leaving this here in case that changes in future versions.
    end

    def trim_leading_spaces(description)
      non_blank_lines = description.select { |line| line =~ /\S/ }

      fewest_spaces = non_blank_lines.collect { |line| line[/^\s*/].length }.min || 0

      description.each { |line| line.slice!(0..(fewest_spaces - 1)) } if fewest_spaces.positive?
    end

    def trim_trailing_spaces(description)
      description.map!(&:rstrip)
    end

  end
end
