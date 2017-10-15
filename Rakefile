require 'rdoc/task'

require 'rspec/core/rake_task'

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
