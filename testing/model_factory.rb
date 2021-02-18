module CukeModeler

  # A helper module that generates models for use in testing
  module ModelFactory

    module_function

    def generate_model(mixins: [], attributes: {})
      model = CukeModeler::Model.new

      mixins.each { |mixin| model.extend(mixin) }
      attributes.each_pair { |attribute, value| model.send("#{attribute}=", value) }

      model
    end

  end
end
