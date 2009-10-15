module RbGCCXML

  # Represents a <CvQualifiedType> node. This node keeps track of
  # the const nature of a Node.
  class CvQualifiedType < Type
    
    def ==(val)
      check_sub_type_without(val, /const/)
    end

    # See Node#to_cpp
    def to_cpp(qualified = true)
      type = XMLParsing.find_type_of(self.node, "type")
      "const #{type.to_cpp(qualified)}"
    end

    # Is this node const?
    def const?
      self.node.attributes["const"].to_i == 1
    end

  end

end
