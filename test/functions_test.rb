require File.dirname(__FILE__) + '/test_helper'

context "Querying for functions" do

  setup do
    @@functions_source ||= RbGCCXML.parse(full_dir("headers/functions.h")).namespaces("functions")
  end

  specify "should be able to find all functions" do
    @@functions_source.functions.length.should == 6
  end

  specify "can find functions by name" do
    # Short-hand finding does #find(:name => "")
    test1 = @@functions_source.functions("test1")
    test1.should.be.a.kind_of RbGCCXML::Function
    test1.name.should == "test1"

    bool = @@functions_source.functions.find(:name => "bool_method")
    bool.should.be.a.kind_of RbGCCXML::Function
    bool.name.should == "bool_method"
  end

  specify "can find names by regex" do
    bool = @@functions_source.functions.find(:name => /bool/)
    bool.should.be.a.kind_of RbGCCXML::Function
    bool.name.should == "bool_method"
  end

  xspecify "can find names by fully qualified name" do
    nested = @@functions_source.functions.find(:name => "nested1::nested2::nestedFunction")
    nested.should.be.a.kind_of RbGCCXML::Function
    nested.name.should == "nestedFunction"
  end

  specify "should not have a classes finder" do
    test1 = @@functions_source.functions("test1")
    should.raise RbGCCXML::NotQueryableException do
      test1.classes  
    end
  end

  specify "should not have a namespaces finder" do
    test1 = @@functions_source.functions("test1")
    should.raise RbGCCXML::NotQueryableException do
      test1.namespaces
    end
  end

  specify "should not have a functions finder" do
    test1 = @@functions_source.functions("test1")
    should.raise RbGCCXML::NotQueryableException do
      test1.functions  
    end
  end
end

context "Finding functions via arguments and return type" do

  setup do
    @@functions_source ||= RbGCCXML.parse(full_dir("headers/functions.h")).namespaces("functions")
  end

  specify "by return type" do
    funcs = @@functions_source.functions.find(:returns => :void)
    funcs.size.should == 3
    assert funcs.find {|f| f.name == "test1" }
    assert funcs.find {|f| f.name == "test2" }
    assert funcs.find {|f| f.name == "test3" }
  end

  specify "no arguments" do
    funcs = @@functions_source.functions.find(:arguments => [])
    funcs.size.should == 2
    assert funcs.find {|f| f.name == "test1" }
    assert funcs.find {|f| f.name == "bool_method" }
  end

  specify "multiple arguments" do
    # If we find just one result, we get it back
    func = @@functions_source.functions.find(:arguments => [:int])
    assert func.is_a?(RbGCCXML::Function)
    func.name.should == "test2"

    func = @@functions_source.functions.find(:arguments => [:int, :float])
    assert func.is_a?(RbGCCXML::Function)
    func.name.should == "test3"
  end

  specify "when searching arguments, can specify catch-all" do
    funcs = @@functions_source.functions.find(:arguments => [:int, nil])
    funcs.size.should == 2
    assert funcs.find {|f| f.name == "test3" }
    assert funcs.find {|f| f.name == "test4" }
  end

  specify "by both return type and arguments (AND form, not OR)" do
    func = @@functions_source.functions.find(:returns => :int, :arguments => [nil, nil])
    assert func.is_a?(RbGCCXML::Function)
    func.name.should == "test4"
  end
end
