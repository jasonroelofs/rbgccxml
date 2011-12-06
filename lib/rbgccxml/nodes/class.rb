module RbGCCXML
  # Represents a <Class> node.
  class Class < Node

    # Disabled: Classes cannot have nested namespaces
    def namespaces(name = nil)
      raise NotQueryableException.new("Cannot query for Namespaces while in a Class")
    end

    # Is this class pure virtual?
    def pure_virtual?
      attributes["abstract"] ? attributes["abstract"] == "1" : false
    end

    # Find all the constructors for this class.
    def constructors
      NodeCache.find_children_of_type(self, "Constructor")
    end

    # Find the destructor for this class.
    # To tell if a destructor is gcc-generated or not, check the
    # 'artificial' attribute:
    #
    #   class_node.destructor.artificial?
    #
    def destructor
      NodeCache.find_children_of_type(self, "Destructor")[0]
    end

    # Find the superclass for this class.
    # By default, this will find the superclass of any access type, pass in
    # the type of access you're looking for if you want specific types
    # (e.g. public, private, protected).
    #
    # If there is more than one superclass to this class, this method will only return
    # the first superclass.  # If you know or expect there to be multiple superclasses,
    # use #superclasses instead
    def superclass(access_type = nil)
      found = superclasses(access_type)
      found.empty? ? nil : found[0]
    end

    # Like #superclass above, this will find all superclasses for this class.
    # Functions the same as #superclass except this method always returns a QueryResult
    def superclasses(access_type = nil)
      QueryResult.new(
        [
          NodeCache.find_children_of_type(self, "Base").select do |base|
            access_type.nil? ? true : base.send("#{access_type}?")
          end
        ].flatten.map {|base| base.cpp_type }
      )
    end

    # Find all methods for this class. See Node#namespaces
    def methods(name = nil)
      NodeCache.find_children_of_type(self, "Method", name)
    end

    # Find all instance variables for this class. See Node#namespaces
    def variables(name = nil, &block)
      NodeCache.find_children_of_type(self, "Field", name)
    end

    # Find all constants under this class. See Node#namespaces
    def constants(name = nil, &block)
      NodeCache.find_children_of_type(self, "Variable", name)
    end

  end
end
