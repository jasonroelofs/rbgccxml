require 'rake/rdoctask'
require 'rake/contrib/sshpublisher'
require 'rake/gempackagetask'

require 'rspec/core/rake_task'

PROJECT_NAME = "rbgccxml"
RBGCCXML_VERSION = "1.0.1"

task :default => :spec

desc "Run all specs"
RSpec::Core::RakeTask.new do |t|
  t.pattern = "spec/**/*_test.rb"
end

Rake::RDocTask.new do |rd|
  rd.main = "README"
  rd.rdoc_files.include("README", "lib/**/*.rb")
  rd.rdoc_files.exclude("**/jamis.rb")
  rd.template = File.expand_path(File.dirname(__FILE__) + "/lib/jamis.rb")
  rd.options << '--line-numbers' << '--inline-source'
end

RUBYFORGE_USERNAME = "jameskilton"
PROJECT_WEB_PATH = "/var/www/gforge-projects/rbplusplus/rbgccxml"

namespace :web do
  desc "Put the website together"
  task :build => :rdoc do
    unless File.directory?("publish")
      mkdir "publish"
    end
    sh "cp -r html/* publish/"
  end

  # As part of the rbplusplus project, this just goes in a subfolder
  desc "Update the website" 
  task :upload => "web:build"  do |t|
    Rake::SshDirPublisher.new("#{RUBYFORGE_USERNAME}@rubyforge.org", PROJECT_WEB_PATH, "publish").upload
  end

  desc "Clean up generated web files"
  task :clean => ["clobber_rdoc"] do
    rm_rf "publish"
  end
end

spec = Gem::Specification.new do |s|
  s.name = PROJECT_NAME
  s.version = RBGCCXML_VERSION
  s.summary = 'Ruby interface to GCCXML'
  s.homepage = 'http://rbplusplus.rubyforge.org/rbgccxml'
  s.rubyforge_project = "rbplusplus"
  s.author = 'Jason Roelofs'
  s.email = 'jameskilton@gmail.com'
  
  s.add_dependency "nokogiri", "~> 1.4.0"
  s.add_dependency "gccxml_gem", "~> 0.9"

  s.description = <<-END
Rbgccxml is a library that parses out GCCXML (http://www.gccxml.org) output
and provides a simple but very powerful querying API for finding exactly
what you want out of the C++ source code
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

Rake::GemPackageTask.new(spec) do |pkg|
end
