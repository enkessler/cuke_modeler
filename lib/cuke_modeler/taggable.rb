module CukeModeler

  # A mix-in module containing methods used by elements that can be tagged.

  module Taggable

    # The tags which are directly assigned to the element
    attr_accessor :tags


    # Returns the tags which are indirectly assigned to the element (i.e. they
    # have been inherited from a parent model).
    def applied_tags
      parent_model.respond_to?(:all_tags) ? parent_model.all_tags : []
    end

    # Returns all of the tags which are applicable to the element.
    def all_tags
      applied_tags + @tags
    end


    private


    def populate_tags(parsed_element)
      if parsed_element['tags']
        parsed_element['tags'].each do |tag|
          @tags << build_child_element(Tag, tag)
        end
      end
    end

    def tag_output_string
      tags.collect { |tag| tag.name }.join(' ')
    end

  end
end
