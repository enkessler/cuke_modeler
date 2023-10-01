module CukeModeler

  # @api private
  #
  # A mix-in module containing methods used by models that know from which line of
  # source code they originate. Internal helper class.
  module Sourceable

    # @api
    #
    # The line number where the element began in the source code
    attr_accessor :source_line

    # @api
    #
    # The column number where the element began in the source code
    attr_accessor :source_column


    private


    def populate_source_location(model, parsed_model_data)
      model.source_line = parsed_model_data['line']
      model.source_column = parsed_model_data['column']
    end

  end
end
