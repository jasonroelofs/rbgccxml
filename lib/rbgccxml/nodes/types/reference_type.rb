module RbGCCXML
  # This deals with C++ Reference nodes (&)
  class ReferenceType < Type

    def ==(val)
      check_sub_type_without(val, /\&/)
    end

    def to_cpp(qualified = true)
      type = XMLParsing.find_type_of(self.node, "type")
      "#{type.to_cpp(qualified)}&"
    end
  end
end
