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
    IGNORE_NODES = %w(GCC_XML Ellipsis)

    def start_element(name, attributes = [])
      attr_hash = Hash[*attributes]

      if !IGNORE_NODES.include?(name)
        node = RbGCCXML.const_get(name).new(attr_hash)

        # Save node to node cache
        NodeCache << node
      end
    end

    # Once the document is done parsing we process our node tree
    def end_document
      NodeCache.process_tree
    end

  end

end
