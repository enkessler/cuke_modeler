module CukeModeler

  # @api private
  #
  # A mix-in module containing methods used by models that represent an element that has a name. Internal helper class.
  module Named

    # @api
    #
    # The name of the element
    attr_accessor :name


    private


    def name_output_string
      name.nil? || name.empty? ? '' : " #{name}"
    end

    def populate_name(model, parsed_model_data)
      model.name = parsed_model_data['name']
    end

  end
end
