require 'tempfile'
require 'libxml'

module RbGCCXML

  # This class manages the parsing of the C++ code.
  # Please use RbGCCXML.parse and not this class directly
  class Parser

    def initialize(config = {}) 
      @gccxml = GCCXML.new

      if includes = config.delete(:includes)
        @gccxml.add_include includes
      end

      if flags = config.delete(:cxxflags)
        @gccxml.add_cxxflags flags
      end

      validate_glob(config[:files])
    end

    # Start the parsing process. This includes
    # 1. Creating a temp file for the resulting xml
    # 2. Finding all the files to run through gccxml
    # 3. If applicable, build another temp file and #include 
    #    the header files to ensure one pass into gccxml
    # 4. Build up our :: Namespace node and pass that back
    #    to the user for querying
    def parse
      @results_file = Tempfile.new("rbgccxml")
      parse_file = nil

      if @files.length == 1
        parse_file = @files[0]
      else
        # Otherwise we need to build up a single header file
        # that #include's all of the files in the list, and
        # parse that out instead
        parse_file = build_header_for(@files)
      end

      @gccxml.parse(parse_file, @results_file.path)

      # Everything starts at the :: Namespace
#      document = Hpricot.XML(@results_file)
      document = LibXML::XML::Document.file(@results_file.path)
      root = document.root
      global_ns = root.find("//Namespace[@name='::']")[0]

      XMLParsing.doc_root = document

      Namespace.new global_ns
    end

    private

    def build_header_for(files)
      header = Tempfile.new("header_wrapper")
      header.open

      @files.each do |file|
        header.write "#include \"#{file}\"\n"
      end

      header.close

      header.path
    end

    def validate_glob(files)
      found = []

      if files.is_a?(Array)
        files.each {|f| found << Dir[f] }
      elsif ::File.directory?(files)
        found = Dir[files + "/*"]
      else
        found = Dir[files]
      end

      found.flatten!

      if found.empty?
        raise SourceNotFoundError.new(
          "Cannot find files matching #{files.inspect}. " +
          "You might need to specify a full path.") 
      end

      @files = found.select {|f| !::File.directory?(f) }
    end
  end
end
