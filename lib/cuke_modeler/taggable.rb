module CukeModeler

  # A mix-in module containing methods used by elements that can be tagged.

  module Taggable

    # The tags which are directly assigned to the element
    attr_accessor :tags


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
