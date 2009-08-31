module RbGCCXML
  # This represents a Pointer of any other kind of type
  class PointerType < Type

    def ==(val)
      check_sub_type_without(val, /\*/)
    end

    def to_cpp(qualified = true)
      type = XMLParsing.find_type_of(self.node, "type")
      "#{type.to_cpp(qualified)}*"
    end
  end

end
