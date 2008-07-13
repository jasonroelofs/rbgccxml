module RbGCCXML
  # Represents the <Function> node. Functions are the end point of the tree.
  # They have arguments and return types.
  class Function < Node
    
    # First of all, no more querying once you're this far in
    %w(classes namespaces functions).each do |f|
      define_method(f) do
        raise NotQueryableException.new("Cannot query for #{f} while in a Function")
      end
    end
    
    # Get the list of arguments for this Function.
    def arguments
      XMLParsing.find_arguments_for(node)
    end

    # Find the return type of this function
    def return_type
      XMLParsing.find_type_of(node, "returns")
    end
  end
end
