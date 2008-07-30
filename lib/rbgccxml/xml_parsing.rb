module RbGCCXML

  # A module of methods used to parse out the flat GCC-XML file into
  # a proper heirarchy. These methods are used internally and not intended
  # for outside use.
  module XMLParsing

    # I'm not sure if Hpricot is unable to jump back out to the document
    # root or if I just can't find how, but we give this module the 
    # Hpricot document to do proper searching.
    def self.doc_root=(root)
      @@doc_root = root
    end

    # Generic finding of nodes according to attributes.
    # Special options:
    #
    # <tt>:type</tt>:: Specify a certain node type to search by
    #
    # Any other options is directly mapped to attributes on the node. For example, to find
    # a Function node that have the name "functor":
    #
    #   XMLParsing.find(:type => "Function", :name => "functor")
    #
    # Returns the first found node
    def self.find(options = {})
      return nil if options.empty?
      type = options.delete(:type)
      
      attrs = options.map {|key, value| "[@#{key}='#{value}']"}.join
      xpath = "//#{type || '*'}#{attrs}"
      
      got = @@doc_root.find(xpath).first

      if got
        RbGCCXML.const_get(type || got.name).new(got) 
      else
        nil
      end
    end
    
    # Generic finding of nodes according to attributes.
    # Special options:
    #
    # <tt>:type</tt>:: Specify a certain node type to search by
    #
    # Any other options is directly mapped to attributes on the node. For example, to find all
    # Function nodes:
    #
    #   XMLParsing.find_all(:type => "Function")
    #
    # Returns all matching nodes
    def self.find_all(options = {})
      results = QueryResult.new
      return results if options.empty?

      type = options.delete(:type)
      attrs = options.map {|key, value| "[@#{key}='#{value}']"}.join

      xpath = "//#{type}#{attrs}"
      
      found = @@doc_root.find(xpath)
      
      if found
        found.each do |got|
          results << RbGCCXML.const_get(type || got.name).new(got) 
        end
      end
      results
    end

    # Look through the DOM under +node+ for +node_type+ nodes.
    # +node_type+ must be the string name of an existing Node subclass.
    #
    # Returns a QueryResult with the findings.
    def self.find_nested_nodes_of_type(node, node_type)
      self.find_all(:type => node_type, :context => node.attributes["id"])
    end

    # Arguments are a special case in gccxml as they are actual children of
    # the functions / methods they are a part of. 
    def self.find_arguments_for(node)
      get_children_nodes_of_type(node, "Argument")
    end

    # Enumeration values are children of the Enumeration element
    def self.get_values_of(enum)
      get_children_nodes_of_type(enum.node, "EnumValue")
    end

    # Generic lookup method for nodes that are XML children of the passed in node.
    # See find_arguments_for and get_values_of for example usage
    def self.get_children_nodes_of_type(node, type)
      results = QueryResult.new

      node.children.each do |found|
        next unless found.element?
        results << RbGCCXML.const_get(type).new(found) 
      end
      
      results.flatten
    end

    # Entrance into the type management. Given a GCCXML node and an attribute
    # to reference, find the C++ type related. For example, finding the return
    # type of a function:
    #
    #   +find_type_of(func_node, "returns")+ could return "std::string" node, "int" node, etc
    def self.find_type_of(node, attribute)
      id = node.attributes[attribute]

      self.find(:id => id)
    end
  end
end
