require "test_helper"

describe "Querying for classes" do
  before do
    @source ||= RbGCCXML.parse(full_dir("headers/classes.h")).namespaces("classes")
  end

  specify "can find all classes in a given namespace" do
    classes = @source.classes
    classes.size.should == 4

    classes.find(:name => "Test1").should_not be_nil
    classes.find(:name => "Test2").should_not be_nil
    classes.find(:name => "Test3").should_not be_nil
  end

  specify "can find classes within classes" do
    test1 = @source.classes.find(:name => "Test1")
    test1.should_not be_nil
    test1.should be_kind_of(RbGCCXML::Class)
    test1.name.should == "Test1"

    inner1 = test1.classes("Inner1")
    inner1.should_not be_nil
    inner1.should be_kind_of(RbGCCXML::Class)
    inner1.name.should == "Inner1"

    inner2 = inner1.classes("Inner1")
    inner2.should_not be_nil
    inner2.should be_kind_of(Array)
    inner2.should be_empty

    inner2 = inner1.classes("Inner2")
    inner2.should_not be_nil
    inner2.should be_kind_of(RbGCCXML::Class)
    inner2.name.should == "Inner2"
  end

  specify "can find classes within classes by regex" do
    test1 = @source.classes(/t1/)
    test1.should_not be_nil
    test1.should be_kind_of(RbGCCXML::Class)
    test1.name.should == "Test1"

    inner1 = test1.classes(/In.*1/)
    inner1.should_not be_nil
    inner1.should be_kind_of(RbGCCXML::Class)
    inner1.name.should == "Inner1"

    inner2 = inner1.classes(/1/)
    inner2.should_not be_nil
    inner2.should be_kind_of(Array)
    inner2.should be_empty

    inner2 = inner1.classes(/2/)
    inner2.should_not be_nil
    inner2.should be_kind_of(RbGCCXML::Class)
    inner2.name.should == "Inner2"
  end

  specify "can find classes within classes by block" do
    # We're looking for any class that has virtual methods.
    test4 = @source.classes.select { |c| c.methods.any? { |m| m.virtual? } }
    test4.should_not be_nil
    test4.should be_kind_of(RbGCCXML::Class)
    test4.name.should == "Test4"

    # Fail case -- there's no methods that return double.
    test0 = @source.classes.select { |c| c.methods.any? { |m| m.return_type == "double" }}
    test0.should_not be_nil
    test0.should be_kind_of(Array)
    test0.should be_empty
  end

  specify "can tell if a class is pure virtual" do
    test1 = @source.classes("Test1")
    test4 = @source.classes("Test4")

    test1.pure_virtual?.should be_false
    test4.pure_virtual?.should be_true
  end
end

describe "Querying for class constructors" do
  before do
    @source ||= RbGCCXML.parse(full_dir("headers/classes.h")).namespaces("classes")
  end

  specify "should have a list of constructors" do
    test1 = @source.classes.find(:name => "Test1")
    test1.constructors.size.should == 2

    test2 = @source.classes.find(:name => "Test2")
    test2.constructors.size.should == 3
  end

  specify "constructors should have arguments" do
    test2 = @source.classes.find(:name => "Test2")
    test2.constructors.size.should == 3

    # GCC generated copy constructors
    copy = test2.constructors[0]
    copy.artificial?.should be_true

    default = test2.constructors[1]
    default.arguments.size.should == 0

    specific = test2.constructors[2]
    specific.arguments.size.should == 1
    specific.arguments[0].cpp_type.name.should == "int"
  end
end

describe "Querying for the class's deconstructor" do
  before do
    @source ||= RbGCCXML.parse(full_dir("headers/classes.h")).namespaces("classes")
  end

  specify "can tell if a class has an explicit destructor" do
    test1 = @source.classes("Test1")
    test1.destructor.should_not be_nil
    test1.destructor.artificial?.should be_false

    test2 = @source.classes("Test2")
    test2.destructor.should_not be_nil
    test2.destructor.artificial?.should be_true
  end

end

describe "Query for class variables" do
  before do
    @source ||= RbGCCXML.parse(full_dir("headers/classes.h")).namespaces("classes")
  end

  specify "find all i-vars" do
    test1 = @source.classes("Test1")
    test1.variables.length.should == 4
  end

  specify "can find by access level" do
    test1 = @source.classes("Test1")
    test1.variables.find(:access => "public").length.should == 2
    test1.variables.find(:access => "protected").name.should == "protVariable"
    test1.variables.find(:access => "private").name.should == "privateVariable"
  end
end

describe "Query inheritance heirarchy" do
  before do
    @source ||= RbGCCXML.parse(full_dir("headers/inheritance.h")).namespaces("inheritance")
  end

  specify "can find a class's superclass" do
    pc = @source.classes("ParentClass")
    pc.superclass.should be_nil

    base1 = @source.classes("Base1")
    base1.superclass.should_not be_nil
    base1.superclass.name.should == "ParentClass"
  end

  specify "can query for multiple inheritance" do
    multi = @source.classes("MultiBase")
    multi.superclasses.length.should == 2
    multi.superclasses.should be_a_kind_of(RbGCCXML::QueryResult)
    multi.superclasses.select {|sp| sp.name == "ParentClass"}.should_not be_nil
    multi.superclasses.select {|sp| sp.name == "Parent2"}.should_not be_nil
  end

  specify "calling #superclasses always returns an array" do
    pc = @source.classes("ParentClass")
    pc.superclasses.should be_empty

    base1 = @source.classes("Base1")
    base1.superclasses.length.should == 1
    base1.superclasses[0].name.should == "ParentClass"
  end

  specify "can infinitely climb the inheritance heirarchy" do
    low = @source.classes("VeryLow")
    low.superclass.superclass.superclass.name.should == "ParentClass"
  end

  specify "can query for types of inheritance" do
    pvb1 = @source.classes("PrivateBase1")
    pvb1.superclass(:public).should be_nil
    pvb1.superclass(:protected).should be_nil
    pvb1.superclass(:private).should_not be_nil

    pvb1.superclass(:private).name.should == "ParentClass"

    pvb1.superclasses(:public).length.should == 0
    pvb1.superclasses(:protected).length.should == 0
    pvb1.superclasses(:private).length.should == 1

    vlow = @source.classes("VeryLow")
    vlow.superclasses(:public).length.should == 1
    vlow.superclasses(:private).length.should == 0
    vlow.superclasses(:protected).length.should == 1
  end

end

