module RbGCCXML
  class CvQualifiedType < Type
    
    def ==(val)
      check_sub_type_without(val, /const/)
    end

    def to_s
      type = XMLParsing.find_type_of(self.node, "type")
      "const #{type}"
    end

  end
end
