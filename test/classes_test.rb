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
    
    inner1 = test1.classes("Inner1")
    inner1.should.not.be.nil
    
    inner2 = inner1.classes("Inner1")
    inner2.should.not.be.nil
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

