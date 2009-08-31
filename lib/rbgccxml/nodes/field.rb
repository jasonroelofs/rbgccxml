module RbGCCXML
  # Field is a class's Ivar
  class Field < Node

    # Get the C++ type of this argument.
    def cpp_type
      XMLParsing.find_type_of(node, "type")
    end

    # See Node#to_cpp, prints out the C++ code for this field.
    def to_cpp(qualified = false)
      "#{self.cpp_type.to_cpp(qualified)} #{self.name}"
    end

  end
end
