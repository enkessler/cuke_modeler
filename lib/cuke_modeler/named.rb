module CukeModeler

  # A mix-in module containing methods used by elements that have a name.

  module Named

    # The name of the element
    attr_accessor :name


    private


    def name_output_string
      name.empty? ? '' : " #{name}"
    end

  end
end
