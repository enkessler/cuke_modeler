require 'digest/md5'

module CukeModeler

  # NOT A PART OF THE PUBLIC API
  # A mix-in module containing methods used by models that represent an element that has a name.

  module Fingerprint
    # NOTE: create a fingerprint for the given model using Digest::MD5
    def fingerprint()
      if children.empty?
        # NOTE: yield the result value of the block as the argument to .hexdigest
        return Digest::MD5.hexdigest(yield self) if block_given?

        # NOTE: no block given, .hexdigest the to_s of the model
        return Digest::MD5.hexdigest(to_s)
      end

      # NOTE: aggregate the fingerprints of all it's children
      children_fingerprints = children.map do |child|
        if block_given?
          # NOTE: this child has children of its own traverse those
          child.fingerprint { |nested_child| yield nested_child }
        else
          # NOTE: this child is a leaf node, return the fingerprint
          child.fingerprint
        end
      end

      # NOTE: create a .hexdigest of the combined fingerprint of all children
      Digest::MD5.hexdigest(children_fingerprints.join)
    end
  end
end
