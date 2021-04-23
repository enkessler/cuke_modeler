require_relative 'gherkin_9_adapter'


module CukeModeler

  # NOT A PART OF THE PUBLIC API
  # An adapter that can convert the output of version 18.x of the *cucumber-gherkin* gem into input that is consumable
  # by this gem.

  class Gherkin18Adapter < Gherkin9Adapter

    # Adapts the AST sub-tree that is rooted at the given rule node.
    def adapt_rule(rule_ast)
      adapted_rule = super(rule_ast)

      # Tagging of Rules was added in Gherkin 18
      adapted_rule['tags'] = adapt_tags(rule_ast[:rule])

      adapted_rule
    end

  end
end
