module RbGCCXML
  class CvQualifiedType < Type
    
    def ==(val)
      check_sub_type_without(val, /const/)
    end

    def to_s(full = false)
      type = XMLParsing.find_type_of(self.node, "type")
      "const #{type.to_s(full)}"
    end

    # Yes, we are a constant type
    def const?
      self.node.attributes["const"].to_i == 1
    end
  end
end
