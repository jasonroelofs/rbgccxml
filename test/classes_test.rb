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

  specify "can find out which file said class is in" do
    test1 = @source.classes.find(:name => "Test1")
    should.not.raise { test1.file_name.should == "classes.h" }
    should.not.raise { test1.file_name(true).should == "classes.h" }
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
    test2.constructors.size.should == 2
  end

  specify "constructors should have arguments" do
    test2 = @source.classes.find(:name => "Test2")
    test2.constructors.size.should == 2

    default = test2.constructors[0]
    default.arguments.size.should == 0

    specific = test2.constructors[1]
    specific.arguments.size.should == 1
    assert(specific.arguments[0].cpp_type == "int")
  end
end

context "Query for class variables" do
  setup do
    @source ||= RbGCCXML.parse(full_dir("headers/classes.h")).namespaces("classes")
  end
end

