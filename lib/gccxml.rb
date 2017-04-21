class GCCXML

  def initialize()
    @exe = find_exe.strip.chomp
    @includes = []
    @flags = []
  end

  # Add an include path for parsing
  def add_include(path)
    @includes << path
  end

  # Add extra CXXFLAGS to the command line
  def add_cxxflags(flags)
    @flags << flags
  end

  # Run gccxml on the header file(s), sending the output to the passed in
  # file.
  def parse(header_file, to_file)
    includes = @includes.flatten.uniq.map {|i| "-I#{i.chomp}"}.join(" ").chomp
    flags = @flags.flatten.join(" ").chomp
    flags += " -Wno-unused-command-line-argument --castxml-cc-gnu #{find_clang} --castxml-gccxml"

    cmd = "#{@exe} #{includes} #{flags} -o #{to_file} #{header_file}"
    raise "Error executing castxml command line: #{cmd}" unless system(cmd)
  end

  private

  def windows?
    RUBY_PLATFORM =~ /(mswin|cygwin)/
  end

  def find_exe
    ext = windows? ? ".exe" : ""
    binary = "castxml#{ext}"

    if `#{binary} --version 2>&1` =~ /CastXML/
      binary
    else
      raise "Unable to find the castxml executable on your PATH."
    end
  end

  def find_clang
    `which clang`.strip
  end

end
