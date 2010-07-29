module RbGCCXML
  # Represents a <Class> node.
  class Class < Node
    
    # Disabled: Classes cannot have nested namespaces
    def namespaces(name = nil)
      raise NotQueryableException.new("Cannot query for Namespaces while in a Class")
    end

    # Is this class pure virtual?
    def pure_virtual?
      @node["abstract"] ? @node["abstract"] == "1" : false
    end

    # Find all the constructors for this class. 
    def constructors
      XMLParsing::find_nested_nodes_of_type(@node, "Constructor")
    end
    once :constructors

    # Find the destructor for this class.
    # To tell if a destructor is gcc-generated or not, check the
    # 'artificial' attribute:
    #
    #   class_node.destructor.attributes[:artificial]
    #
    def destructor
      XMLParsing::find_nested_nodes_of_type(@node, "Destructor")[0]
    end
    once :destructor

    # Find the superclass for this class. 
    # By default, this will find the superclass of any access type, pass in
    # the type of access you're looking for if you want specific types (e.g. public, private, protected).
    #
    # If there is more than one superclass to this class, this method will only return the first superclass.
    # If you know or expect there to be multiple superclasses, use #superclasses instead
    def superclass(access_type = nil)
      found = superclasses(access_type)
      found.empty? ? nil : found[0]
    end
    once :superclass

    # Like #superclass above, this will find all superclasses for this class.
    # Functions the same as #superclass except this method always returns a QueryResult
    def superclasses(access_type = nil)
      XMLParsing::find_bases_for(@node, access_type)
    end
    once :superclasses

    # Find all methods for this class. See Node#namespaces
    def methods(name = nil, &block)
      find_nested_nodes_of_type("Method", name, &block)
    end
    once :methods

    # Find all instance variables for this class. See Node#namespaces
    def variables(name = nil, &block)
      find_nested_nodes_of_type("Field", name, &block)
    end
    once :variables

    # Find all constants under this class. See Node#namespaces
    def constants(name = nil, &block)
      find_nested_nodes_of_type("Variable", name, &block)
    end
    once :constants
  end
end
