require 'tempfile'

module RbGCCXML

  # This class starts the whole process.
  # Please use RbGCCXML.parse and not this class directly
  class Parser

    def initialize(config = {}) 
      begin
        @gccxml = GCCXML.new
      rescue
        puts "Because of a bug in Rubygems <= 1.1.1, certain executables are not set as such."
        puts "This needs to be manually set before rbgccxml can run."
        puts "Please `sudo chmod a+x -R /path/to/gccxml_gem` and then try this again."
      end

      if includes = config.delete(:includes)
        @gccxml.add_include includes
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
      document = Hpricot.XML(@results_file)
      global_ns = document.search("//Namespace[@name='::']")[0]

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
