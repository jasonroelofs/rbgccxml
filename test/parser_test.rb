require File.dirname(__FILE__) + '/test_helper'

context "Default parsing configuration" do

  specify "can parse a single header file" do
    should.not.raise do
      RbGCCXML.parse(full_dir("headers/Adder.h"))
    end
  end

  specify "can parse a glob" do
    should.not.raise do
      RbGCCXML.parse(full_dir("headers/*.hpp"))
    end
  end

  specify "can parse all files in a directory" do
    should.not.raise do
      RbGCCXML.add_include_paths full_dir("headers/include")
      RbGCCXML.parse(full_dir("headers"))
    end
  end

  specify "can take an array of files" do
    files = [full_dir("headers/Adder.h"),
              full_dir("headers/Subtracter.hpp")]
    should.not.raise do
      RbGCCXML.parse(files)
    end
  end

  specify "can take an array of globs" do
    files = [full_dir("headers/*.h"),
              full_dir("headers/*.hpp")]
    should.not.raise do
      RbGCCXML.parse(files)
    end
  end

  specify "should throw an error if files aren't found" do
    should.raise RbGCCXML::SourceNotFoundError do
      RbGCCXML.parse(full_dir("headers/Broken.hcc"))
    end

    should.raise RbGCCXML::SourceNotFoundError do
      RbGCCXML.parse(full_dir("hockers"))
    end

    should.raise RbGCCXML::SourceNotFoundError do
      RbGCCXML.parse(full_dir("something/*"))
    end

    should.raise RbGCCXML::SourceNotFoundError do
      RbGCCXML.parse([full_dir("something/*"), full_dir("anotherthing/*")])
    end
  end
end

context "Configurable parsing configuration" do
  specify "can specify where gccxml is installed" do
    should.raise RbGCCXML::ConfigurationError do
      RbGCCXML.gccxml_path = "/some/other/place/gccxml"
      RbGCCXML.parse(full_dir("headers/Adder.h"))
    end

    should.not.raise RbGCCXML::ConfigurationError do
      RbGCCXML.gccxml_path = `which gccxml`
      RbGCCXML.parse(full_dir("headers/Adder.h"))
    end
  end

  specify "can give extra include directories for parsing" do
    RbGCCXML.add_include_path full_dir("headers/include")
    found = RbGCCXML.parse full_dir("headers/with_includes.h")
    found.namespaces("code").should.not.be.nil
  end
end
