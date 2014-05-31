module CukeModeler

  # A mix-in module containing methods used by elements that can be tagged.

  module Taggable

    # The tags which are directly assigned to the element
    attr_accessor :tags

    # The tag elements belonging to the element
    attr_accessor :tag_elements


    # Returns the tags which are indirectly assigned to the element (i.e. they
    # have been inherited from a parent element).
    def applied_tags
      @parent_element.respond_to?(:all_tags) ? @parent_element.all_tags : []
    end

    # Returns the tags elements which are indirectly assigned to the element
    # (i.e. they have been inherited from a parent element).
    def applied_tag_elements
      @parent_element.respond_to?(:all_tag_elements) ? @parent_element.all_tag_elements : []
    end

    # Returns all of the tags which are applicable to the element.
    def all_tags
      applied_tags + @tags
    end

    # Returns all of the tag elements which are applicable to the element.
    def all_tag_elements
      applied_tag_elements + @tag_elements
    end


    private


    def populate_element_tags(parsed_element)
      if parsed_element['tags']
        parsed_element['tags'].each do |tag|
          @tags << tag['name']
          @tag_elements << build_child_element(Tag, tag)
        end
      end
    end

    def tag_output_string
      tag_elements.collect { |tag| tag.name }.join(' ')
    end

  end
end
