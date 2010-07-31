module RbGCCXML

  # Represents a <CvQualifiedType> node. This node keeps track of
  # the const nature of a Node.
  class CvQualifiedType < Type

    def ==(val)
      check_sub_type_without(val, /const/)
    end

    # See Node#to_cpp
    def to_cpp(qualified = true)
      type = NodeCache.find(attributes["type"])

      post_const = container ? " const" : ""
      pre_const = container ? "" : "const "

      "#{pre_const}#{type.to_cpp(qualified)}#{post_const}"
    end
    once :to_cpp

    # Have to redefine this as Type#const? looks up the 
    # tree for const, and in our case we are the const knower
    def const? #:nodoc:
      attributes["const"] == "1"
    end

  end

end
