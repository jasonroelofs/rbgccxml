require "test_helper"

describe "Qualified name generation" do

  specify "for namespaces" do
    source = RbGCCXML.parse(full_dir("headers/namespaces.hpp"))

    upper = source.namespaces.find(:name => "upper")
    upper.qualified_name.should == "::upper"

    inner2 = upper.namespaces("inner2")
    inner2.qualified_name.should == "::upper::inner2"
  end

  specify "for classes" do
    source = RbGCCXML.parse(full_dir("headers/classes.hpp")).namespaces("classes")

    test1 = source.classes.find(:name => "Test1")
    test1.qualified_name.should == "::classes::Test1"
    
    inner1 = test1.classes("Inner1")
    inner1.qualified_name.should == "::classes::Test1::Inner1"
    
    inner2 = inner1.classes("Inner2")
    inner2.qualified_name.should == "::classes::Test1::Inner1::Inner2"
  end

  specify "for functions" do
    source = RbGCCXML.parse(full_dir("headers/functions.hpp")).namespaces("functions")
    test1 = source.functions("test1")
    test1.qualified_name.should == "::functions::test1"
  end

  specify "for methods in classes" do
    source = RbGCCXML.parse(full_dir("headers/classes.hpp")).namespaces("classes")
    inner = source.classes("Test1").classes("Inner1")
    func = inner.methods("innerFunc")

    func.qualified_name.should == "::classes::Test1::Inner1::innerFunc"
  end

end

describe "Misc access methods" do

  specify "can tell if something is public, protected, and private" do
    source = RbGCCXML.parse(full_dir("headers/misc.hpp"))
    access = source.namespaces("misc").classes("AccessSettings")

    access.methods("privateMethod").should be_private
    access.methods("protectedMethod").should be_protected
    access.methods("publicMethod").should be_public
  end

  specify "can get the full file path of a node" do
    source = RbGCCXML.parse(full_dir("headers/enums.hpp")).namespaces("enums")
    source.enumerations("TestEnum").file.should match(%r{enums.hpp})
  end

  specify "returns nil if no file node is found" do
    source = RbGCCXML.parse(full_dir("headers/enums.hpp")).namespaces("enums")
    source.file.should be_nil
  end

end
