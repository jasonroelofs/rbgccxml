require "test_helper"

context "Qualified name generation" do

  specify "for namespaces" do
    source = RbGCCXML.parse(full_dir("headers/namespaces.h"))

    upper = source.namespaces.find(:name => "upper")
    upper.qualified_name.should == "upper"

    inner2 = upper.namespaces("inner2")
    inner2.qualified_name.should == "upper::inner2"
  end

  specify "for classes" do
    source = RbGCCXML.parse(full_dir("headers/classes.h")).namespaces("classes")

    test1 = source.classes.find(:name => "Test1")
    test1.qualified_name.should == "classes::Test1"
    
    inner1 = test1.classes("Inner1")
    inner1.qualified_name.should == "classes::Test1::Inner1"
    
    inner2 = inner1.classes("Inner2")
    inner2.qualified_name.should == "classes::Test1::Inner1::Inner2"
  end

  specify "for functions" do
    source = RbGCCXML.parse(full_dir("headers/functions.h")).namespaces("functions")
    test1 = source.functions("test1")
    test1.qualified_name.should == "functions::test1"
  end

  specify "for methods in classes" do
    source = RbGCCXML.parse(full_dir("headers/classes.h")).namespaces("classes")
    inner = source.classes("Test1").classes("Inner1")
    func = inner.methods("innerFunc")

    func.qualified_name.should == "classes::Test1::Inner1::innerFunc"
  end

end

context "Misc access methods" do

  specify "can tell if something is public, protected, and private" do
    source = RbGCCXML.parse(full_dir("headers/misc.h"))
    access = source.namespaces("misc").classes("AccessSettings")

    assert access.methods("privateMethod").private?
    assert access.methods("protectedMethod").protected?
    assert access.methods("publicMethod").public?
  end

  specify "can get the full file path of a node" do
    source = RbGCCXML.parse(full_dir("headers/enums.h")).namespaces("enums")
    source.enumerations("TestEnum").file.should =~ "enums.h"
  end

  specify "returns nil if no file node is found" do
    source = RbGCCXML.parse(full_dir("headers/enums.h")).namespaces("enums")
    source.file.should.be nil
  end

end
