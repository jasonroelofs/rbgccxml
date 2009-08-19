require File.join(File.dirname(__FILE__), 'test_helper')

context "Querying for classes" do
  setup do
    @source ||= RbGCCXML.parse(full_dir("headers/classes.h")).namespaces("classes")
  end

  specify "can find all classes in a given namespace" do
    classes = @source.classes
    classes.size.should == 4

    %w(Test1 Test2 Test3).each do |t|
      assert classes.detect {|c| c.node == @source.classes(t).node }, 
        "unable to find node for #{t}"
    end
  end

  specify "can find classes within classes" do
    test1 = @source.classes.find(:name => "Test1")
    test1.should.not.be.nil
    test1.should.be.kind_of RbGCCXML::Class
    test1.name.should == "Test1"
    
    inner1 = test1.classes("Inner1")
    inner1.should.not.be.nil
    inner1.should.be.kind_of RbGCCXML::Class
    inner1.name.should == "Inner1"
    
    inner2 = inner1.classes("Inner1")
    inner2.should.not.be.nil
    inner2.should.be.kind_of Array
    inner2.should.be.empty

    inner2 = inner1.classes("Inner2")
    inner2.should.not.be.nil
    inner2.should.be.kind_of RbGCCXML::Class
    inner2.name.should == "Inner2"
  end

  specify "can find classes within classes by regex" do
    test1 = @source.classes(/t1/)
    test1.should.not.be.nil
    test1.should.be.kind_of RbGCCXML::Class
    test1.name.should == "Test1"
    
    inner1 = test1.classes(/In.*1/)
    inner1.should.not.be.nil
    inner1.should.be.kind_of RbGCCXML::Class
    inner1.name.should == "Inner1"
    
    inner2 = inner1.classes(/1/)
    inner2.should.not.be.nil
    inner2.should.be.kind_of Array
    inner2.should.be.empty

    inner2 = inner1.classes(/2/)
    inner2.should.not.be.nil
    inner2.should.be.kind_of RbGCCXML::Class
    inner2.name.should == "Inner2"
  end

  specify "can find classes within classes by block" do
    # We're looking for any class that has virtual methods.
    test4 = @source.classes { |c| c.methods.any? { |m| m.virtual? } }
    test4.should.not.be.nil
    test4.should.be.kind_of RbGCCXML::Class
    test4.name.should == "Test4"

    # Fail case -- there's no methods that return double.
    test0 = @source.classes { |c| c.methods.any? { |m| m.return_type == "double" }}
    test0.should.not.be.nil
    test0.should.be.kind_of Array
    test0.should.be.empty
  end

  specify "can't find classes by number" do
    should.raise RbGCCXML::UnsupportedMatcherException do
      test4 = @source.classes(4)
    end
  end
end

context "Querying for class constructors" do
  setup do
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
    copy.attributes[:artificial].should == "1"

    default = test2.constructors[1]
    default.arguments.size.should == 0

    specific = test2.constructors[2]
    specific.arguments.size.should == 1
    assert(specific.arguments[0].cpp_type == "int")
  end
end

context "Querying for the class's deconstructor" do
  setup do
    @source ||= RbGCCXML.parse(full_dir("headers/classes.h")).namespaces("classes")
  end

  specify "can tell if a class has an explicit destructor" do
    test1 = @source.classes("Test1")
    test1.destructor.should.not.be.nil
    test1.destructor.attributes[:artificial].should.be.nil

    test2 = @source.classes("Test2")
    test2.destructor.should.not.be.nil
    test2.destructor.attributes[:artificial].should.not.be.nil
  end

end

context "Query for class variables" do
  setup do
    @source ||= RbGCCXML.parse(full_dir("headers/classes.h")).namespaces("classes")
  end

  specify "find all i-vars" do
    test1 = @source.classes("Test1")
    test1.variables.length.should.equal 4
  end

  specify "can find by access level" do
    test1 = @source.classes("Test1")
    test1.variables.find(:access => "public").length.should.equal 2
    test1.variables.find(:access => "protected").name.should.equal "protVariable"
    test1.variables.find(:access => "private").name.should.equal "privateVariable"
  end
end

context "Query inheritance heirarchy" do
  setup do
    @source ||= RbGCCXML.parse(full_dir("headers/inheritance.h")).namespaces("inheritance")
  end

  specify "can find a class's superclass" do
    pc = @source.classes("ParentClass")
    pc.superclass.should.be.nil

    base1 = @source.classes("Base1")
    base1.superclass.should.not.be.nil
    base1.superclass.name.should.equal "ParentClass"
  end

  specify "can query for multiple inheritance" do
    multi = @source.classes("MultiBase")
    multi.superclasses.length.should.equal 2
    assert multi.superclasses.select {|sp| sp.name == "ParentClass"}
    assert multi.superclasses.select {|sp| sp.name == "Parent2"}
  end

  specify "calling #superclasses always returns an array" do
    pc = @source.classes("ParentClass")
    pc.superclasses.should.be.empty

    base1 = @source.classes("Base1")
    base1.superclasses.length.should.equal 1
    base1.superclasses[0].name.should.equal "ParentClass"
  end

  specify "can infinitely climb the inheritance heirarchy" do
    low = @source.classes("VeryLow")
    low.superclass.superclass.superclass.name.should.equal "ParentClass"
  end

  specify "can query for types of inheritance" do
    pvb1 = @source.classes("PrivateBase1")
    pvb1.superclass(:public).should.be.nil
    pvb1.superclass(:protected).should.be.nil
    pvb1.superclass(:private).should.not.be.nil

    pvb1.superclass(:private).name.should.equal "ParentClass"

    pvb1.superclasses(:public).length.should.equal 0
    pvb1.superclasses(:protected).length.should.equal 0
    pvb1.superclasses(:private).length.should.equal 1
  end

end

