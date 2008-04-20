require File.dirname(__FILE__) + '/test_helper'

context "Querying for namespaces" do

  setup do
    @source ||= RbGCCXML.parse(full_dir("headers/namespaces.h"))
  end

  specify "can find a namespace" do
    upper = @source.namespaces.find(:name => "upper")
    upper.should.be.a.kind_of RbGCCXML::Namespace

    inner1 = upper.namespaces("inner1")
    inner1.should.be.a.kind_of RbGCCXML::Namespace
    inner1.name.should == "inner1"

    inner2 = upper.namespaces("inner2")
    inner2.should.be.a.kind_of RbGCCXML::Namespace
    inner2.name.should == "inner2"

    nested = inner2.namespaces("nested")
    nested.should.be.a.kind_of RbGCCXML::Namespace
    nested.name.should == "nested"
  end
end
