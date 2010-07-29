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
    end
  end

  # Our SAX Events handler class
  class ParserEventHandler < Nokogiri::XML::SAX::Document

    def start_element(name, attributes = [])
      attr_hash = Hash[*attributes]
      puts "We got element #{name} with attributes: #{attr_hash.inspect}"
    end

  end

end
