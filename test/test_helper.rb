$LOAD_PATH.unshift File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rubygems'

begin
  # 1.9 needs this for test/spec to work
  gem 'test-unit'
rescue LoadError
  # Probably 1.8.x, we're ok
end

require 'test/spec'
require 'rbgccxml'

class Test::Unit::TestCase

  def full_dir(path)
    File.expand_path(File.join(File.dirname(__FILE__), path))
  end
  
  def teardown
    RbGCCXML::XMLParsing.clear_cache
  end
  
end

