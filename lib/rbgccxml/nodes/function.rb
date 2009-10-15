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
      XMLParsing.find_arguments_for(node)
    end

    # Get the Node representing this Function's return type
    def return_type
      XMLParsing.find_type_of(node, "returns")
    end
  end

end
