module RbGCCXML

  # Node type represending <Base> nodes.
  # These nodes are children to <Class> nodes and define superclass
  # definitions
  class Base < Node

    # Get the Class node representing the type of this Base
    def cpp_type
      NodeCache.find(attributes["type"])
    end

  end
end
