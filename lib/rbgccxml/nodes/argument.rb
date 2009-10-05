module RbGCCXML
  # Class representing a single <Argument> node.
  class Argument < Node

    # Get the C++ type of this argument.
    def cpp_type
      XMLParsing.find_type_of(node, "type")
    end

    # Get any default value for this argument
    def value
      attributes["default"]
    end

    # See Node#to_cpp, prints out C++ code for this argument
    def to_cpp(qualified = true)
      "#{self.cpp_type.to_cpp(qualified)} #{self.name}"
    end

  end
end
