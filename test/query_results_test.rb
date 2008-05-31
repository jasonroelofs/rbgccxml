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

end
