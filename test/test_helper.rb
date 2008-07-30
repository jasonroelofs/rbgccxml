$: << File.expand_path(File.dirname(__FILE__) + "/../lib")

require 'rubygems'
require 'test/spec'
require 'rbgccxml'

class Test::Unit::TestCase

  def full_dir(path)
    File.expand_path(File.join(File.dirname(__FILE__), path))
  end
  
end

