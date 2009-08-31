module RbGCCXML
  # Node that represents <CvQualifiedType>. This gccxml node handles
  # both const and volitile flags, but for our case we only use the
  # const flag.
  class CvQualifiedType < Type
    
    def ==(val)
      check_sub_type_without(val, /const/)
    end

    def to_cpp(qualified = true)
      type = XMLParsing.find_type_of(self.node, "type")
      "const #{type.to_cpp(qualified)}"
    end

    def const?
      self.node.attributes["const"].to_i == 1
    end
  end
end
