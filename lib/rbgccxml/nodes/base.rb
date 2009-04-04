module RbGCCXML
  # Node type represending <Base> nodes.
  # These nodes are children to <Class> and define superclass
  # definitions
  class Base < Node

    # Get the C++ Class type of this definition
    def cpp_type
      XMLParsing.find_type_of(node, "type")
    end

  end
end
