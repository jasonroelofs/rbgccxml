require File.join(File.dirname(__FILE__), 'test_helper')

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
      RbGCCXML.parse(full_dir("headers"),
                    :includes => full_dir("headers/include"),
                    :cxxflags => "-DMUST_BE_DEFINED")
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
      RbGCCXML.parse(files, :includes => full_dir("headers/include"))
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
  specify "can give extra include directories for parsing" do
    found = RbGCCXML.parse full_dir("headers/with_includes.h"),
      :includes => full_dir("headers/include")
    found.namespaces("code").should.not.be.nil
  end

  specify "can be given extra cxxflags for parsing" do
    should.not.raise do
      RbGCCXML.parse full_dir("headers/requires_define.hxx"),
        :cxxflags => "-DMUST_BE_DEFINED"
    end
  end
end
