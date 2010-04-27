module RbGCCXML

  class NotQueryableException < RuntimeError; end
  class UnsupportedMatcherException < RuntimeError; end

  # A Node is part of the C++ code as dictated by GCC-XML. This class 
  # defines all of the starting points into the querying system, along 
  # with helper methods to access data from the C++ code itself.
  #
  # Any Node further down the heirarchy chain can and should define which 
  # finder methods are and are not avaiable at that level. For example, the 
  # Class node cannot search for other Namespaces within that class, and any
  # attempt to will throw a NotQueryableException.
  class Node 

    # The underlying xml node for this Node.
    attr_reader :node

    # A linking ivar that lets types figure out where they sit,
    # for example an argument type can find the <Argument> it's
    # a part of.
    attr_accessor :container

    # Initialize this node according to the XML element passed in
    # Only to be used internally. Use query methods on the object
    # returned by RbGCCXML::parse
    def initialize(node)
      @node = node
    end
    protected :initialize

    # Get the C++ name of this node
    def name
      @node['name']
    end
    
    # Get the fully qualified (demangled) C++ name of this node.
    def qualified_name
      if @node["demangled"]
        # The 'demangled' attribute of the node for methods / functions is the 
        # full signature, so cut that part out.
        @node["demangled"].split(/\(/)[0]
      else
        parent ? "#{parent.qualified_name}::#{name}" : name
      end
    end

    # Is this node const qualified?
    def const?
      @node["const"] ? @node["const"] == "1" : false
    end

    # Does this node have public access?
    def public?
     @node["access"] ? @node["access"] == "public" : true
    end

    # Does this node have protected access?
    def protected?
     @node["access"] ? @node["access"] == "protected" : false
    end

    # Does this node have private access?
    def private?
     @node["access"] ? @node["access"] == "private" : false
    end

    # Access to the underlying xml node's attributes.
    def attributes
      @node
    end

    # Access indivitual attributes directly
    def [](val)
      @node[val]
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

    # Returns the full path to the file this node is found in.
    # Returns nil if no File node is found for this node
    def file
      file_id = @node["file"]
      file_node = XMLParsing.find(:node_type => "File", :id => file_id) if file_id
      file_node ? file_node.attributes["name"] : nil
    end

    # Returns the parent node of this node. e.g. function.parent will get the class
    # the function is contained in.
    def parent
      return nil if @node["context"].nil? || @node["context"] == "_1"
      XMLParsing.find(:id => @node["context"])
    end

    # This is a unified search routine for finding nested nodes. It
    # simplifies the search routines below significantly.
    def find_nested_nodes_of_type(type, matcher = nil, &block)
      res = XMLParsing.find_nested_nodes_of_type(@node, type)

      case matcher
      when String
        res = res.find(:name => matcher)
      when Regexp
        res = res.find_all { |t| t.name =~ matcher }
      when nil
        # Do nothing, since not specifying a matcher is okay.
      else
        message = "Can't handle a match condition of type #{matcher.class}."
        raise UnsupportedMatcherException.new(message)
      end

      res = res.find_all(&block) if block

      res
    end
    private :find_nested_nodes_of_type

    # Find all namespaces. There are two ways of calling this method:
    #   #namespaces  => Get all namespaces in this scope
    #   #namespaces(name) => Shortcut for namespaces.find(:name => name)
    #
    # Returns a QueryResult unless only one node was found
    def namespaces(name = nil, &block)
      find_nested_nodes_of_type("Namespace", name, &block)
    end

    # Find all classes in this scope. 
    #
    # See Node.namespaces
    def classes(name = nil, &block)
      find_nested_nodes_of_type("Class", name, &block)
    end

    # Find all structs in this scope. 
    #
    # See Node.namespaces
    def structs(name = nil, &block)
      find_nested_nodes_of_type("Struct", name, &block)
    end

    # Find all functions in this scope. 
    #
    # See Node.namespaces
    def functions(name = nil, &block)
      find_nested_nodes_of_type("Function", name, &block)
    end

    # Find all enumerations in this scope. 
    #
    # See Node.namespaces
    def enumerations(name = nil, &block)
      find_nested_nodes_of_type("Enumeration", name, &block)
    end
    
    # Find all variables in this scope
    #
    # See Node.namespaces
    def variables(name = nil, &block)
      find_nested_nodes_of_type("Variable", name, &block)
    end

    # Find all typedefs in this scope
    #
    # See Node.namespaces
    def typedefs(name = nil, &block)
      find_nested_nodes_of_type("Typedef", name, &block)
    end

    # Print out the full C++ valid code for this node.
    # By default, it will print out the fully qualified name of this node.
    # See various Type classes to see how else this method is used.
    def to_cpp(qualified = true)
      qualified ? self.qualified_name : self.name
    end
  end

end
