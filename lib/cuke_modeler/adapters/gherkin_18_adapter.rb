require_relative 'gherkin_9_adapter'


module CukeModeler

  # @api private
  #
  # An adapter that can convert the output of version 18.x of the *cucumber-gherkin* gem into input that is consumable
  # by this gem. Internal helper class.
  class Gherkin18Adapter < Gherkin9Adapter

    # Adapts the AST sub-tree that is rooted at the given rule node.
    def adapt_rule(rule_ast)
      adapted_rule = super

      clear_child_elements(adapted_rule, [[:rule, :tags]])

      # Tagging of Rules was added in Gherkin 18
      adapted_rule['tags'] = adapt_tags(rule_ast[:rule])

      adapted_rule
    end

  end

  private_constant :Gherkin18Adapter
end
