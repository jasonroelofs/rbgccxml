require "test_helper"

describe "Default parsing configuration" do

  specify "can be given a raw XML file" do
    lambda do
      RbGCCXML.parse_xml(full_dir("parsed/Adder.xml"))
    end.should_not raise_error
  end

  specify "can parse a single header file" do
    lambda do
      RbGCCXML.parse(full_dir("headers/Adder.h"))
    end.should_not raise_error
  end

  specify "can parse a glob" do
    lambda do
      RbGCCXML.parse(full_dir("headers/*.hpp"))
    end.should_not raise_error
  end

  specify "can parse all files in a directory" do
    lambda do
      RbGCCXML.parse(full_dir("headers"),
                    :includes => full_dir("headers/include"),
                    :cxxflags => "-DMUST_BE_DEFINED")
    end.should_not raise_error
  end

  specify "can take an array of files" do
    files = [full_dir("headers/Adder.h"),
              full_dir("headers/Subtracter.hpp")]
    lambda do
      RbGCCXML.parse(files)
    end.should_not raise_error
  end

  specify "can take an array of globs" do
    files = [full_dir("headers/*.h"),
              full_dir("headers/*.hpp")]
    lambda do
      RbGCCXML.parse(files, :includes => full_dir("headers/include"))
    end.should_not raise_error
  end

  specify "should throw an error if files aren't found" do
    lambda do
      RbGCCXML.parse(full_dir("headers/Broken.hcc"))
    end.should raise_error(RbGCCXML::SourceNotFoundError)

    lambda do
      RbGCCXML.parse(full_dir("hockers"))
    end.should raise_error(RbGCCXML::SourceNotFoundError)

    lambda do
      RbGCCXML.parse(full_dir("something/*"))
    end.should raise_error(RbGCCXML::SourceNotFoundError)

    lambda do
      RbGCCXML.parse([full_dir("something/*"), full_dir("anotherthing/*")])
    end.should raise_error(RbGCCXML::SourceNotFoundError)
  end
end

describe "Configurable parsing configuration" do
  specify "can give extra include directories for parsing" do
    found = RbGCCXML.parse full_dir("headers/with_includes.h"),
      :includes => full_dir("headers/include")
    found.namespaces("code").should_not be_nil
  end

  specify "can be given extra cxxflags for parsing" do
    lambda do
      RbGCCXML.parse full_dir("headers/requires_define.hxx"),
        :cxxflags => "-DMUST_BE_DEFINED"
    end.should_not raise_error
  end
end
