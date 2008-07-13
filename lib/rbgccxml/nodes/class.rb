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
    def methods(name = nil)
      if name
        methods.find(:name => name)
      else
        XMLParsing::find_nested_nodes_of_type(@node, "Method")
      end
    end
  end
end
