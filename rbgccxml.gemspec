Gem::Specification.new do |s|
  s.name = "rbgccxml"
  s.version = "1.1.0"
  s.summary = 'Ruby interface to GCCXML'
  s.homepage = 'http://rbplusplus.rubyforge.org/rbgccxml'
  s.rubyforge_project = "rbplusplus"
  s.author = 'Jason Roelofs'
  s.email = 'jasongroelofs@gmail.com'

  s.add_dependency "nokogiri", ">= 1.5.0"

  s.description = <<-END
Rbgccxml is a library that parses out GCCXML (http://www.gccxml.org) output
and provides a simple but very powerful querying API for finding exactly
what you want out of C++ source code.
  END

  patterns = [
    'TODO',
    'Rakefile',
    'lib/**/*.rb',
  ]

  s.files = patterns.map {|p| Dir.glob(p) }.flatten

  s.test_files = Dir.glob('spec/**/*.rb')

  s.require_paths = ['lib']
end
