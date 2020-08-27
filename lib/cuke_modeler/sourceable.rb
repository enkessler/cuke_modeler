module CukeModeler

  # NOT A PART OF THE PUBLIC API
  # A mix-in module containing methods used by models that know from which line of
  # source code they originate.

  module Sourceable

    # The line number where the element began in the source code
    attr_accessor :source_line


    private


    def populate_source_line(model, parsed_model_data)
      model.source_line = parsed_model_data['line']
    end

  end
end
