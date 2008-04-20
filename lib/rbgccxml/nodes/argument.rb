module RbGCCXML
  # Class representing a single <Argument ...> node.
  class Argument < Node

    # Get the C++ type of this argument.
    def cpp_type
      XMLParsing.find_type_of(node, "type")
    end

  end
end
