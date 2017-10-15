class GCCXML

  def initialize()
    @includes = []
    @flags = []

    @castxml_path = nil
    @clangpp_path = nil
  end

  # Add an include path for parsing
  def add_include(path)
    @includes << path
  end

  # Add extra CXXFLAGS to the command line
  def add_cxxflags(flags)
    @flags << flags
  end

  # Set the full path to the `castxml` binary
  def set_castxml_path(path)
    @castxml_path = path
  end

  # Set the full path to the `clang++` binary
  def set_clangpp_path(path)
    @clangpp_path = path
  end

  # Run gccxml on the header file(s), sending the output to the passed in
  # file.
  def parse(header_file, to_file)
    includes = @includes.flatten.uniq.map {|i| "-I#{i.chomp}"}.join(" ").chomp
    flags = @flags.flatten.join(" ").chomp
    flags += " -Wno-unused-command-line-argument --castxml-cc-gnu #{find_clang} --castxml-gccxml"

    exe = find_exe.strip.chomp
    cmd = "#{exe} #{includes} #{flags} -o #{to_file} #{header_file}"
    raise "Error executing castxml command line: #{cmd}" unless system(cmd)
  end

  private

  def find_exe
    ext = windows? ? ".exe" : ""
    binary = @castxml_path || "castxml#{ext}"

    if `#{binary} --version 2>&1` =~ /CastXML/
      binary
    else
      path_msg =
        if @castxml_path
          "at #{@castxml_path}"
        else
          "on your PATH"
        end

      error_msg = "Unable to find a castxml executable #{path_msg}."
      error_msg += "\nYou can set an explicit path with the `castxml_path` option to RbGCCXML.parse"

      raise error_msg
    end
  end

  def find_clang
    if @clangpp_path
      @clangpp_path
    else
      `which clang++`.strip
    end
  end

  def windows?
    RUBY_PLATFORM =~ /(mswin|cygwin)/
  end

end
