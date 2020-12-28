module CukeModeler

  # A helper module that generates models for use in testing

  module ModelFactory

    def self.included(klass)
      klass.include(Methods)
    end

    def self.extended(klass)
      klass.extend(Methods)
    end

    module Methods

      def generate_model(mixins: [], attributes: {})
        model = CukeModeler::Model.new

        mixins.each { |mixin| model.extend(mixin) }
        attributes.each_pair { |attribute, value| model.send("#{attribute}=", value) }

        model
      end

    end

    extend Methods

  end
end
