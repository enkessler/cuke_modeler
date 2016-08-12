module CukeModeler

  # A mix-in module containing methods used by models that represent an element that can be tagged.

  module Taggable

    # The tags which are directly assigned to the element
    attr_accessor :tags


    # Returns the tags which are indirectly assigned to the element (i.e. they
    # have been inherited from a parent element).
    def applied_tags
      parent_model.respond_to?(:all_tags) ? parent_model.all_tags : []
    end

    # Returns all of the tags which are applicable to the element.
    def all_tags
      applied_tags + @tags
    end


    private


    def tag_output_string
      tags.collect { |tag| tag.name }.join(' ')
    end

  end
end
