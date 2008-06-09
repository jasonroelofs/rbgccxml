module RbGCCXML

  class NotQueryableException < RuntimeError; end

  # A Node is part of the C++ code as dictated by GCC-XML. This class 
  # defines all of the starting points into the querying system, along 
  # with helper methods to access data from the C++ code itself.
  #
  # Any Node further down the heirarchy chain can and should define which 
  # finder methods are and are not avaiable at that level. For example, the 
  # Class Node cannot search for other Namespaces within that class.
  class Node 
    attr_reader :node

    # Initialize this node according to the XML element passed in
    # Only to be used internally.
    def initialize(node)
      @node = node
    end
    
    # Get the C++ name of this node
    def name
      @node.attributes['name']
    end

    # Nodes are not const by default
    def const?
      if @node.attributes["const"]
        @node.attributes["const"] == "1"
      else 
        false
      end
    end

    # Is this node public access?
    # All nodes default to public access unless otherwise specified
    def public?
     @node.attributes["access"] ? @node.attributes["access"] == "public" : true
    end

    # Is this node protected access?
    def protected?
     @node.attributes["access"] ? @node.attributes["access"] == "protected" : false
    end

    # Is this node private access?
    def private?
     @node.attributes["access"] ? @node.attributes["access"] == "private" : false
    end

    # Get the fully qualified (demangled) C++ name of this node.
    # The 'demangled' attribute of the node for methods / functions is the 
    # full signature, so cut that out.
    def qualified_name
      if @node.attributes["demangled"]
        @node.attributes["demangled"].split(/\(/)[0]
      else
        parent ? "#{parent.qualified_name}::#{name}" : name
      end
    end

    # Forward up attribute array for easy access to the
    # underlying XML node
    def attributes
      @node.attributes
    end

    # Get the file name of the file this node is found in. 
    def file_name(basename = true)
      file_id = @node.attributes["file"]
      file_node = XMLParsing.find(:type => "File", :id => file_id)
      name = file_node.attributes["name"]
      basename ? ::File.basename(name) : name
    end

    # Get the parent node of this node. e.g. function.parent will get the class
    # the function is contained in.
    def parent
      return nil if @node.attributes["context"].nil? || @node.attributes["context"] == "_1"
      XMLParsing.find(:id => @node.attributes["context"])
    end

    # Find all namespaces. There are two ways of calling this method:
    #   #namespaces  => Get all namespaces in this scope
    #   #namespaces(name) => Shortcut for namespaces.find(:name => name)
    def namespaces(name = nil)
      if name
        namespaces.find(:name => name)
      else
        XMLParsing.find_nested_nodes_of_type(@node, "Namespace")
      end
    end

    # Find all classes in this scope. Like #namespaces, there are
    # two ways of calling this method.
    def classes(name = nil)
      if name
        classes.find(:name => name)
      else
        XMLParsing.find_nested_nodes_of_type(@node, "Class")
      end
    end

    # Find all structs in this scope. Like #namespaces, there are
    # two ways of calling this method.
    def structs(name = nil)
      if name
        structs.find(:name => name)
      else
        XMLParsing.find_nested_nodes_of_type(@node, "Struct")
      end
    end

    # Find all functions in this scope. Functions are free non-class
    # functions. To search for class methods, use #methods.
    # 
    # Like #namespaces, there are two ways of calling this method.
    def functions(name = nil)
      if name
        functions.find(:name => name)
      else
        XMLParsing.find_nested_nodes_of_type(@node, "Function")
      end
    end

    # Find all enumerations in this scope. 
    #
    # This method functions like the others
    def enumerations(name = nil)
      if name
        enumerations.find(:name => name)
      else
        XMLParsing.find_nested_nodes_of_type(@node, "Enumeration")
      end
    end

    # Special equality testing. A given node can be tested against
    # a String to test against the name of the node. For example
    #
    #   source.classes("MyClass") == "MyClass"                                #=> true
    #   source.classes("MyClass") == source.classes.find(:name => "MyClass")  #=> true
    #
    def ==(val)
      if val.is_a?(String)
        return true if self.name == val
        # Need to take care of '*' which is a regex character, and any leading ::,
        # which are redundant in our case.
        return true if self.qualified_name =~ /#{val.gsub("*", "\\*").gsub(/^::/, "")}/
        false
      else
        super
      end
    end

    # Make it easy to print out the name of this node
    def to_s(full = false)
      full ? self.qualified_name : self.name
    end
  end

end
