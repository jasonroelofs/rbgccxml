module RbGCCXML

  class NotQueryableException < RuntimeError; end

  # A Node is part of the C++ code as dictated by GCC-XML. This class 
  # defines all of the starting points into the querying system, along 
  # with helper methods to access data from the C++ code itself.
  #
  # Any Node further down the heirarchy chain can and should define which 
  # finder methods are and are not avaiable at that level. For example, the 
  # Class node cannot search for other Namespaces within that class.
  class Node 
    attr_reader :node

    # Initialize this node according to the XML element passed in
    # Only to be used internally.
    def initialize(node)
      @node = node
    end
    protected :initialize

    # Get the C++ name of this node
    def name
      @node.attributes['name']
    end
    
    # Get the fully qualified (demangled) C++ name of this node.
    def qualified_name
      if @node.attributes["demangled"]
        # The 'demangled' attribute of the node for methods / functions is the 
        # full signature, so cut that part out.
        @node.attributes["demangled"].split(/\(/)[0]
      else
        parent ? "#{parent.qualified_name}::#{name}" : name
      end
    end

    # Is this node const qualified?
    def const?
      @node.attributes["const"] ? @node.attributes["const"] == "1" : false
    end

    # Does this node have public access?
    def public?
     @node.attributes["access"] ? @node.attributes["access"] == "public" : true
    end

    # Does this node have protected access?
    def protected?
     @node.attributes["access"] ? @node.attributes["access"] == "protected" : false
    end

    # Does this node have private access?
    def private?
     @node.attributes["access"] ? @node.attributes["access"] == "private" : false
    end

    # Forward up attribute array for easy access to the
    # underlying XML node
    def attributes
      @node.attributes
    end

    # Some C++ nodes are actually wrappers around other nodes. For example, 
    #   
    #   typedef int ThisType;
    #
    # You'll get the TypeDef node "ThisType". Use this method if you want the base type for this
    # typedef, e.g. the "int".
    def base_type
      self
    end

    # Returns the full file name of the file this node is found in. 
    def file_name(basename = true)
      file_id = @node.attributes["file"]
      file_node = XMLParsing.find(:node_type => "File", :id => file_id)
      name = file_node.attributes["name"]
      basename ? ::File.basename(name) : name
    end

    # Returns the parent node of this node. e.g. function.parent will get the class
    # the function is contained in.
    def parent
      return nil if @node.attributes["context"].nil? || @node.attributes["context"] == "_1"
      XMLParsing.find(:id => @node.attributes["context"])
    end

    # Find all namespaces. There are two ways of calling this method:
    #   #namespaces  => Get all namespaces in this scope
    #   #namespaces(name) => Shortcut for namespaces.find(:name => name)
    #
    # Returns a QueryResult unless only one node was found
    def namespaces(name = nil)
      if name
        namespaces.find(:name => name)
      else
        XMLParsing.find_nested_nodes_of_type(@node, "Namespace")
      end
    end

    # Find all classes in this scope. 
    # See Node.namespaces
    def classes(name = nil)
      if name
        classes.find(:name => name)
      else
        XMLParsing.find_nested_nodes_of_type(@node, "Class")
      end
    end

    # Find all structs in this scope. 
    # See Node.namespaces
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
    # See Node.namespaces
    def functions(name = nil)
      if name
        functions.find(:name => name)
      else
        XMLParsing.find_nested_nodes_of_type(@node, "Function")
      end
    end

    # Find all enumerations in this scope. 
    # See Node.namespaces
    def enumerations(name = nil)
      if name
        enumerations.find(:name => name)
      else
        XMLParsing.find_nested_nodes_of_type(@node, "Enumeration")
      end
    end
    
    # Find all variables in this scope
    def variables(name = nil)
      if name
        variables.find(:name => name)
      else
        XMLParsing::find_nested_nodes_of_type(@node, "Variable")
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
        if val =~ /::/
          return true if self.qualified_name =~ /#{val.gsub("*", "\\*").gsub(/^::/, "")}/
        end

        false
      elsif val.is_a?(Regexp)
        self =~ val
      else
        super
      end
    end

    # Regexp comparison operator for consistency. See Node.==
    def =~(val)
      if val.is_a?(Regexp)
        self.name =~ val || self.qualified_name =~ val
      else
        super
      end
    end

    # Print out the name of this node. If passed in <tt>true</tt> then will
    # print out the fully qualified name of this node.
    def to_s(full = false)
      full ? self.qualified_name : self.name
    end
  end

end
