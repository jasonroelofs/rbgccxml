module RbGCCXML

  # References a <ReferenceType> node, which is a reference to another Type.
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
