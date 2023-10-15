module CukeModeler

  # @api private
  #
  # A mix-in module containing methods used by models that contain other models. Internal helper class.
  module Containing

    include Enumerable

    # TODO: Have this method return `self` so that method chaining can be done?

    # @api
    #
    # Executes the given code block with this model and every model that is a child of this model. Exact
    # order of model tree traversal is not guaranteed beyond the first model traversed, which will be the
    # model that called this method. If no block is provided, an `Enumerator` is returned instead.
    #
    # @example
    #   model.each
    #   model.each { |model| puts model.inspect }
    #
    # @yieldparam [Model] The current model being visited
    # @return [Enumerable] if no block is given
    def each(&block)
      if block
        block.call(self)
        children.each { |child| child.each(&block) }
      else
        to_enum(:each)
      end
    end

    # @api
    # @deprecated Use `Enumerable` module methods instead
    #
    # Executes the given code block with every model that is a child of this model.
    #
    # @example
    #   model.each_descendant { |model| puts model.inspect }
    #
    # @yieldparam [Model] The current model being visited
    def each_descendant(&block)
      children.each do |child_model|
        block.call(child_model)
        child_model.each_descendant(&block) if child_model.respond_to?(:each_descendant)
      end
    end

    # @api
    # @deprecated Use `Enumerable` module methods instead
    #
    # Executes the given code block with this model and every model that is a child of this model.
    #
    # @example
    #   model.each_model { |model| puts model.inspect }
    #
    # @yieldparam [Model] The current model being visited
    def each_model(&block)
      block.call(self)

      each_descendant(&block)
    end


    private


    def build_child_model(clazz, model_data)
      model = clazz.new
      # Send-ing to get around private scoping. Don't want the make the method public
      # and there is no way to get the already processed data to the child model that
      # wouldn't require something public.
      model.send('populate_model', model_data)
      model.parent_model = self

      model
    end

    # TODO: move to mix-in module
    def populate_keyword(parsed_model_data)
      @keyword = parsed_model_data['keyword'].strip
    end

    # TODO: move elsewhere?
    def populate_children(parsed_feature_data)
      return unless parsed_feature_data['elements']

      parsed_feature_data['elements'].each do |element|
        case element['type']
          when 'Scenario', 'scenario'
            @tests << build_child_model(Scenario, element)
          when 'ScenarioOutline', 'scenario_outline'
            @tests << build_child_model(Outline, element)
          when 'Background', 'background'
            @background = build_child_model(Background, element)
          when 'Rule'
            @rules << build_child_model(Rule, element)
          else
            raise(ArgumentError, "Unknown element type: #{element['type']}")
        end
      end
    end

  end
end
