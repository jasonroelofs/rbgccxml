require 'rubygems'
require 'rspec'
require 'rbgccxml'

module FileDirectoryHelpers
  def full_dir(path)
    File.expand_path(File.join(File.dirname(__FILE__), path))
  end
end

RSpec.configure do |config|
  config.include(FileDirectoryHelpers)
end
