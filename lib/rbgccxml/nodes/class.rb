module RbGCCXML
  # Node type represending <Class> nodes.
  class Class < Node
    
    # Disabled: Classes cannot have nested namespaces
    def namespaces(name = nil)
      raise NotQueryableException.new("Cannot query for Namespaces while in a Class")
    end

    # Find all the constructors for this class. 
    def constructors
      XMLParsing::find_nested_nodes_of_type(@node, "Constructor")
    end

    # Find all methods for this class. See Node.namespaces
    def methods(name = nil, &block)
      find_nested_nodes_of_type("Method", name, &block)
    end

    # A class has public, private, and protected variables.
    def variables(name = nil, &block)
      find_nested_nodes_of_type("Field", name, &block)
    end

    # A class also has constants, unchangeable values
    def constants(name = nil, &block)
      find_nested_nodes_of_type("Variable", name, &block)
    end
  end
end
