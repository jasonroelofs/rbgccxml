# RbGCCXML, the library to parse and query C++ header code.
module RbGCCXML

  class << self

    # Starting point to any RbGCCXML parsing project. 
    #
    # This method must be called *after* any calls to RbGCCXML.gccxml_path= 
    # or RbGCCXML.add_include_paths.  Files can be one of many formats 
    # (and should always be full directory paths):
    #
    # <tt>"/path/to/file.h"</tt>
    #
    # <tt>"/dir/glob/**/*.h"</tt>
    #
    # or an array of either of the above.
    #
    # +options+ can be any of:
    #
    #   includes: A single string, or an array of strings of directory includes (-I directives)
    #   cxxflags: A single string, or an array of strings of other command line flags
    #
    # Returns the Namespace Node linked to the global namespace "::".
    def parse(files, options = {})
      options.merge!(:files => files)
      @parser = Parser.new options
      @parser.parse
    end

    # Use this call to parse a pregenerated gccxml file.
    #
    # Returns the Namespace Node linked to the global namespace "::".
    def parse_xml(filename)
      @parser = Parser.new :pregenerated => filename
      @parser.parse
    end
  end

  class SourceNotFoundError < RuntimeError; end
  class ConfigurationError < RuntimeError; end
end
