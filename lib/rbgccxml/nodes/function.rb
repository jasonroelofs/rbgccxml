module RbGCCXML

  # Represents a <Function> node, a global or namespaced function
  # or static class functions.
  class Function < Node
    
    # First of all, no more querying once you're this far in
    %w(classes namespaces functions).each do |f|
      define_method(f) do
        raise NotQueryableException.new("Cannot query for #{f} while in a Function")
      end
    end
    
    # Get the list of Arguments for this Function.
    def arguments
      children
    end

    # Get the Node representing this Function's return type
    def return_type
      NodeCache.find(attributes["returns"])
    end
  end

end
