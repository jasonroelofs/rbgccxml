# RbGCCXML, the library to parse and query C++ header code.
module RbGCCXML

  class << self

    # Specify where the GCC-XML executable is located.
    # This is only needed when the executable is not in the
    # system's path. Should be a full directory path.
    def gccxml_path=(path)
      GCCXML.path = path
    end

    # Add include paths for GCC-XML's parsing. (-I parameter).
    # This can be a single path or an array of paths
    def add_include_paths(path)
      GCCXML.add_include(path)
    end
    alias_method :add_include_path, :add_include_paths

    # This is where it all happens. This method must be after any calls
    # to RbGCCXML.gccxml_path= or RbGCCXML.add_include_paths. 
    # Files can be one of many formats (and should always be full directory paths):
    #
    # <tt>"/path/to/file.h"</tt>
    #
    # <tt>"/dir/glob/**/*.h"</tt>
    #
    # An array of either of the above.
    #
    # Returns the Namespace Node linked to the global namespace "::".
    #
    def parse(files, options = {})
      # Steps here:
      # 1. Find gccxml
      # 2. Find all files expected to be parsed
      # 3. If multiple files:
      #     Build up a temp file with #includes to each file to be parsed
      # 4. If multiple files:
      #     Run gccxml on this generated file
      #    else
      #     Run gccxml on the expected file
      # 5. Parse out XML into class tree

      @parser = Parser.new :files => files
      @parser.parse
    end

  end

  class SourceNotFoundError < RuntimeError; end
  class ConfigurationError < RuntimeError; end
end
