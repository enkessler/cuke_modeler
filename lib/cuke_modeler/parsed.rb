module CukeModeler

  # A mix-in module containing methods used by models that are parsed from source text.

  module Parsed

    # The raw representation of the element (i.e. the output of the gherkin gem)
    attr_accessor :parsing_data

  end
end
