require 'rbconfig'

module RbGCCXML

  # This class takes care of finding and actually calling the gccxml executable, 
  # setting up certain use flags according to what was specified.
  class GCCXML

    class << self
      @@exe_path = nil
      @@includes = []

      # Manually set the path to the gccxml executable
      def path=(path)
        @@exe_path = path
      end

      # Add an include path for parsing
      def add_include(path)
        @@includes << path
      end
    end

    def initialize()
      @exe = find_exe.strip.chomp
    end

    # Run gccxml on the header file(s), sending the output to the passed in
    # file.
    def parse(header_file, to_file)
      includes = @@includes.flatten.uniq.map {|i| "-I#{i}"}.join(" ").chomp
      cmd = "#{@exe} #{includes} #{header_file} -fxml=#{to_file}"
      system(cmd)
    end

    private

    def find_exe
      path = @@exe_path if @@exe_path

      path ||= if PLATFORM =~ /win32/
                  "gccxml.exe" 
                else # *nix / Mac OS
                  `which gccxml`   
                end

      path.chomp!

      if `#{path} --version 2>&1` !~ /GCC-XML/
        raise ConfigurationError.new("Unable to find gccxml executable")
      end

      path
    end

  end

end
