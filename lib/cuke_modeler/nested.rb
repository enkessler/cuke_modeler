module CukeModeler

  # NOT A PART OF THE PUBLIC API
  # A mix-in module containing methods used by models that are nested inside
  # of other models.
  module Nested

    # The parent model that contains this model
    attr_accessor :parent_model


    # Returns the ancestor model of this model that matches the given type.
    def get_ancestor(ancestor_type)
      target_classes = classes_for_type(ancestor_type)

      raise(ArgumentError, "Unknown ancestor type '#{ancestor_type}'.") if target_classes.nil?

      ancestor = parent_model
      ancestor = ancestor.parent_model until target_classes.include?(ancestor.class) || ancestor.nil?

      ancestor
    end


    private


    def classes_for_type(type)
      {
        directory: [Directory],
        feature_file: [FeatureFile],
        feature: [Feature],
        test: [Scenario, Outline, Background],
        background: [Background],
        scenario: [Scenario],
        outline: [Outline],
        step: [Step],
        table: [Table],
        example: [Example],
        row: [Row]
      }[type]
    end

  end
end
