module CukeModeler

  # @api private
  #
  # A mix-in module containing methods used by models that are parsed from
  # source text. Internal helper class.
  module Parsed

    # @api
    #
    # The parsing data for this element that was generated by
    # the parsing engine (i.e. the *cucumber-gherkin* gem)
    attr_accessor :parsing_data


    private


    def populate_parsing_data(parsed_model_data)
      @parsing_data = parsed_model_data['cuke_modeler_parsing_data']
    end

  end
end
