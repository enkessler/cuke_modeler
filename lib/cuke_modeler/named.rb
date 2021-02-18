module CukeModeler

  # NOT A PART OF THE PUBLIC API
  # A mix-in module containing methods used by models that represent an element that has a name.
  module Named

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
