module CukeModeler


  module Containing


    private


    def build_child_element(clazz, element_data)
      element = clazz.new(element_data)
      element.parent_model = self

      element
    end

  end
end
