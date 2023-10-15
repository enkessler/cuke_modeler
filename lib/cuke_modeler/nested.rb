module CukeModeler

  # @api private
  #
  # A mix-in module containing methods used by models that are nested inside
  # of other models. Internal helper class.
  module Nested

    # @api
    #
    # The parent model that contains this model
    attr_accessor :parent_model

    # TODO: Use an Enum type instead of symbols as arguments?

    # @api
    #
    # Returns the ancestor model of this model that matches the given type. Available
    # types are simply snake_case versions of the model Class names. Additionally, a
    # special type *:test* will return either a Scenario or an Outline model.
    #
    # @example
    #   model.get_ancestor(:directory)
    #
    # @param ancestor_type [Symbol] The ancestor type to get
    # @raise [ArgumentError] If the passed type is not a valid model type
    # @return [Model, nil] The ancestor model, if one is found
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
        rule: [Rule],
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
