module RbGCCXML

  # Use SAX to parse the generated xml file.
  # This will end up building the full tree of RbGCCXML::Nodes
  # that fit the parsed C++ code.
  class SAXParser
    def initialize(xml_file)
      @file = xml_file
      @parser = Nokogiri::XML::SAX::Parser.new(ParserEventHandler.new)
    end

    # Kick off the process. When the parsing finishes, we take
    # the root node of the tree and return it
    def parse
      @parser.parse(::File.open(@file))
      NodeCache.root
    end
  end

  # Our SAX Events handler class
  class ParserEventHandler < Nokogiri::XML::SAX::Document

    # Ignore types we don't handle yet
    IGNORE_NODES = %w(GCC_XML Ellipsis OperatorMethod)

    # Some nodes are actually stored in XML as nested structures
    NESTED_NODES = %w(Argument Base)

    def start_element(name, attributes = [])
      attr_hash = Hash[*attributes]

      if !IGNORE_NODES.include?(name)
        node = RbGCCXML.const_get(name).new(attr_hash)

        if NESTED_NODES.include?(name)
          # Don't save node to cache. These nodes don't have
          # ids on which we can index off of
          @context_node.children << node
          node.parent = @context_node
        else
          # Save node to node cache
          NodeCache << node

          # Save node for any XML children it might have later
          @context_node = node
        end
      end
    end

    # Once the document is done parsing we process our node tree
    def end_document
      NodeCache.process_tree
    end

  end

end
