module CukeModeler

  class Cell < ModelElement

    include Sourceable
    include Raw


    # The value of the cell
    attr_accessor :value


    # Creates a new Cell object and, if *source* is provided, populates
    # the object.
    def initialize(source = nil)
      parsed_cell = process_source(source)

      @value = ''

      build_cell(parsed_cell) if parsed_cell
    end

    # Returns a gherkin representation of the cell.
    def to_s
      # Vertical bars are special characters that need to be escaped
      @value.gsub('|', '\|')
    end


    private


    def parse_model(source_text)
      base_file_string = "Feature: Fake feature to parse\nScenario:\n* fake step\n"
      source_text = base_file_string + '|' + source_text + '|'

      parsed_file = Parsing::parse_text(source_text, 'cuke_modeler_stand_alone_cell.feature')

      parsed_file.first['elements'].first['steps'].first['table']['rows'].first['cells'].first
    end

    def build_cell(parsed_cell)
      populate_cell_value(parsed_cell)
      populate_source_line(parsed_cell)
      populate_raw_element(parsed_cell)
    end

    def populate_cell_value(parsed_cell)
      @value = parsed_cell['value']
    end

  end

end
