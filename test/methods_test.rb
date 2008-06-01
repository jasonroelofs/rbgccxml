require File.dirname(__FILE__) + '/test_helper'

context "Querying for class methods" do
  setup do
    @@adder_source ||= RbGCCXML.parse(full_dir("headers/Adder.h")).namespaces("classes")
  end

  specify "should be able to get the methods on a class" do
    adder = @@adder_source.classes.find(:name => "Adder")
    methods = adder.methods

    methods.size.should == 4
    methods[0].name.should == "addIntegers"
    methods[1].name.should == "addFloats"
    methods[2].name.should == "addStrings"
    methods[3].name.should == "getClassName"
  end

  # The following are simplistic. functions_test tests the
  # finder options much more completely. This is just to test
  # that it works on Method objects fine
  specify "should be able to get methods by name" do
    adder = @@adder_source.classes("Adder")
    adder.methods("addIntegers").name.should == "addIntegers"
    adder.methods.find(:name => "addStrings").name.should == "addStrings"
  end

  specify "can search methods via arguments" do
    adder = @@adder_source.classes("Adder")
    adder.methods.find(:arguments => [:int, :int]).name.should == "addIntegers"
  end

  specify "can search methods via return type" do
    adder = @@adder_source.classes("Adder")
    adder.methods.find(:returns => [:float]).name.should == "addFloats"
  end

  specify "can search via all options (AND)" do
    adder = @@adder_source.classes("Adder")
    got = adder.methods.find(:returns => [:int], :arguments => [nil, nil])
    got.name.should == "addIntegers"
  end

end

context "Properties on Methods" do
  setup do
    @@classes_source ||= RbGCCXML.parse(full_dir("headers/classes.h")).namespaces("classes")
  end

  specify "should be able to tell if a given method is static or not" do
    test1 = @@classes_source.classes("Test1")
    assert test1.methods("staticMethod").static?

    test2 = @@classes_source.classes.find(:name => "Test2")
    assert !test2.methods("func1").static?
  end

  specify "should be able to tell if a given method is virtual or not" do
    test4 = @@classes_source.classes("Test4")
    assert test4.methods("func1").virtual?
    assert !test4.methods("func1").purely_virtual?
    
    assert test4.methods("func2").virtual?
    assert !test4.methods("func2").purely_virtual?
    
    assert test4.methods("func3").virtual?
    assert test4.methods("func3").purely_virtual?
  end
end
