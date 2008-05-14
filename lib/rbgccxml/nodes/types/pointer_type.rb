module RbGCCXML

  # This represents a Pointer of any other kind of type
  class PointerType < Type

    # Does this type match the given name string? 
    def ==(val)
      check_sub_type_without(val, /\*/)
    end

    def to_s(full = false)
      type = XMLParsing.find_type_of(self.node, "type")
      "#{type.to_s(full)}*"
    end
  end

end
