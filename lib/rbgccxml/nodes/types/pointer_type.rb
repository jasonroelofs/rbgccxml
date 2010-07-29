module RbGCCXML

  # Represents a <PointerType>, a node designating a pointer type to another Type.
  class PointerType < Type

    def ==(val)
      check_sub_type_without(val, /\*/)
    end

    # See Node#to_cpp
    def to_cpp(qualified = true)
      type = XMLParsing.find_type_of(self.node, "type")
      "#{type.to_cpp(qualified)}*"
    end
    once :to_cpp

  end

end
