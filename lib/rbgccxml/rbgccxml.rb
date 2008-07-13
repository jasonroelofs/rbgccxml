# RbGCCXML, the library to parse and query C++ header code.
module RbGCCXML

  class << self

    # This is where it all happens. This method must be called after any calls
    # to RbGCCXML.gccxml_path= or RbGCCXML.add_include_paths. 
    # Files can be one of many formats (and should always be full directory paths):
    #
    # <tt>"/path/to/file.h"</tt>
    #
    # <tt>"/dir/glob/**/*.h"</tt>
    #
    # An array of either of the above.
    #
    # +options+ can be any of:
    #
    #   includes: A single string, or an array of strings of directory includes (-I directives)
    #   cxxflags: A single string, or an array of strings of other command line flags
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

      options.merge!(:files => files)
      @parser = Parser.new options
      @parser.parse
    end

  end

  class SourceNotFoundError < RuntimeError; end
  class ConfigurationError < RuntimeError; end
end
