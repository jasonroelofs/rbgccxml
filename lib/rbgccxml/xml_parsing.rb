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

      xpath = "//#{type}#{attrs}"

      got = @@doc_root.search(xpath)[0]

      if got
        RbGCCXML.const_get(type || got.name).new(got) 
      else
        nil
      end
    end

    # Look through the DOM under +node+ for +node_type+ nodes.
    # +node_type+ must be the string name of an existing Node subclass.
    #
    # Returns a QueryResult with the findings.
    def self.find_nested_nodes_of_type(node, node_type)
      results = QueryResult.new

      # First of all limit which elements we're searching for, to ease processing.
      # In the GCCXML output, node heirarchy is designated by id, members, and context
      # attributes:
      # 
      #   id => Unique identifier of a given node
      #   members => Space-delimited array of node id's that are under this node
      #   context => The parent node id of this node
      #
      # We only want those nodes in node's context.
      xpath = "//#{node_type}[@context='#{node.attributes["id"]}']"

      @@doc_root.search(xpath).each do |found|
        results << RbGCCXML.const_get(node_type).new(found)
      end

      results.flatten
    end

    # Arguments are a special case in gccxml as they are actual children of
    # the functions / methods they are a part of. 
    def self.find_arguments_for(node)
      results = QueryResult.new

      node.get_elements_by_tag_name("Argument").each do |argument|
        results << Argument.new(argument)
      end
      
      results.flatten
    end

    # Entrance into the type management. Given a GCCXML node and an attribute
    # to reference, find the C++ type related. For example, finding the return
    # type of a function:
    #
    #   +find_type_of(func_node, "returns")+ could return "std::string" node, "int" node, etc
    def self.find_type_of(node, attribute)
      XMLParsing.find(:id => node.attributes[attribute])
    end
  end
end
