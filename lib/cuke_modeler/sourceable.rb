module CukeModeler

  # A mix-in module containing methods used by elements that know their
  # source code line.

  module Sourceable

    # The line number where the element began in the source code
    attr_reader :source_line


    private


    def populate_source_line(parsed_element)
      @source_line = parsed_element['line']
    end

  end
end
