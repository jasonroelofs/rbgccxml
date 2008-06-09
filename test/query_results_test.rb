require File.dirname(__FILE__) + '/test_helper'

context "Managing Query results" do

  class MyObj
    attr_accessor :call_me_called, :other_thingy_called

    def call_me
      @call_me_called = true
    end

    def other_thingy
      @other_thingy_called = true
    end
  end

  specify "should forward off unknown methods to the results" do
    obj1 = MyObj.new
    obj2 = MyObj.new

    q = RbGCCXML::QueryResult.new  
    q << obj1 << obj2

    should.not.raise NoMethodError do
      q.call_me
      q.other_thingy
    end

    assert obj1.call_me_called
    assert obj1.other_thingy_called

    assert obj2.call_me_called
    assert obj2.other_thingy_called

    should.raise NoMethodError do
      q.not_here
    end
  end

  specify "should throw appropriately with an empty result set" do
    should.raise NoMethodError do
      RbGCCXML::QueryResult.new.some_method
    end
  end

  specify "should error out with unknown keys" do
    should.raise do
      RbGCCXML::QueryResult.new.find(:key_bad => :hi_mom)
    end
  end

end

context "QueryResult#find :name" do

  setup do
    @@query_source ||= RbGCCXML.parse(full_dir("headers/queryable.h")).namespaces("query")
  end

  specify "can find by regular name" do
    func = @@query_source.functions.find(:name => "test4")
    func.should.be.a.kind_of RbGCCXML::Function
    func.name.should == "test4"
  end

  specify "can find names by regex" do
    bool = @@query_source.functions.find(:name => /bool/)
    bool.should.be.a.kind_of RbGCCXML::Function
    bool.name.should == "bool_method"
  end

end

context "QueryResult#find :arguments" do

  setup do
    @@query_source ||= RbGCCXML.parse(full_dir("headers/queryable.h")).namespaces("query")
  end

  specify "no arguments" do
    funcs = @@query_source.functions.find(:arguments => [])
    assert funcs.detect {|f| f.name == "test1" }
    assert funcs.detect {|f| f.name == "bool_method" }
  end

  specify "multiple arguments" do
    # If we find just one result, we get it back
    func = @@query_source.functions.find(:arguments => [:int])
    assert func.is_a?(RbGCCXML::Function)
    func.name.should == "test2"

    func = @@query_source.functions.find(:arguments => [:int, :float])
    assert func.is_a?(RbGCCXML::Function)
    func.name.should == "test3"
  end

  specify "when searching arguments, can specify catch-all" do
    funcs = @@query_source.functions.find(:arguments => [:int, nil])
    funcs.size.should == 2
    assert funcs.detect {|f| f.name == "test3" }
    assert funcs.detect {|f| f.name == "test4" }
  end

  specify "works when using custom defined types" do
    func = @@query_source.functions.find(:arguments => ["MyType"])
    func.name.should == "testMyTypeArgs"
  end

  specify "works with pointers and references" do
    func = @@query_source.functions.find(:arguments => ["MyType *"])
    func.name.should == "testMyTypeArgsPtr"

    func = @@query_source.functions.find(:arguments => ["MyType &"])
    func.name.should == "testMyTypeArgsRef"
  end

  specify "works with qualified names" do
    func = @@query_source.functions.find(:arguments => ["query::MyType"])
    func.name.should == "testMyTypeArgs"

    func = @@query_source.functions.find(:arguments => ["::query::MyType"])
    func.name.should == "testMyTypeArgs"
  end

  specify "works with qualifiers like const" do
    func = @@query_source.functions.find(:arguments => ["const MyType*"])
    func.name.should == "testMyTypeArgsConstPtr"
  end
end

context "QueryResult#find :returns" do

  setup do
    @@query_source ||= RbGCCXML.parse(full_dir("headers/queryable.h")).namespaces("query")
  end

  specify "by return type" do
    funcs = @@query_source.functions.find(:returns => :void)
    assert funcs.detect {|f| f.name == "test1" }
    assert funcs.detect {|f| f.name == "test2" }
    assert funcs.detect {|f| f.name == "test3" }
  end

  specify "works with custom defined types" do
    func = @@query_source.functions.find(:returns => "MyType")
    func.name.should == "testMyType"
  end

  specify "work with qualified names" do
    func = @@query_source.functions.find(:returns => "query::MyType")
    func.name.should == "testMyType"

    func = @@query_source.functions.find(:returns => "::query::MyType")
    func.name.should == "testMyType"
  end

  specify "works with pointers and references" do
    func = @@query_source.functions.find(:returns => "MyType *")
    func.name.should == "testMyTypePtr"

    func = @@query_source.functions.find(:returns => "MyType&")
    func.name.should == "testMyTypeRef"
  end

  specify "works with type modifiers (const)" do
    func = @@query_source.functions.find(:returns => "const MyType")
    func.name.should == "testMyTypeConst"
  end
end

context "QueryResult#find access type" do

  setup do
    @@query_source ||= RbGCCXML.parse(full_dir("headers/queryable.h")).namespaces("query")
  end

  specify "can find according to public / private / protected" do
    klass = @@query_source.classes("AccessTester")
    m = klass.methods.find(:access => :public)
    m.name.should == "publicMethod"

    m = klass.methods.find(:access => :protected)
    m.name.should == "protectedMethod"

    m = klass.methods.find(:access => :private)
    m.name.should == "privateMethod"
  end

end

context "QueryResult#find multiple options" do

  setup do
    @@query_source ||= RbGCCXML.parse(full_dir("headers/queryable.h")).namespaces("query")
  end

  specify "by both return type and arguments (AND form, not OR)" do
    func = @@query_source.functions.find(:returns => :int, :arguments => [nil, nil])
    assert func.is_a?(RbGCCXML::Function)
    func.name.should == "test4"
  end

end

context "QueryResult#find :all - Flag full source search" do

  setup do
    @@query_source ||= RbGCCXML.parse(full_dir("headers/queryable.h")).namespaces("query")
  end

  specify "can find all :names regardless of nesting" do
    func = @@query_source.functions.find(:all, :name => "nestedFunction")
    func.name.should == "nestedFunction"
  end

  specify "can find according to :arguments" do
    func = @@query_source.functions.find(:all, :arguments => ["MyType", "MyType"])
    func.name.should == "nestedMyTypeArg"
  end
  
  specify "can find according to :returns " do
    funcs = @@query_source.functions.find(:all, :returns => ["MyType"])
    funcs.size.should == 2
    assert funcs.detect {|f| f.name == "nestedMyTypeReturns"}
    assert funcs.detect {|f| f.name == "testMyType"}
  end

end
