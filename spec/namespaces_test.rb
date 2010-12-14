require "test_helper"

describe "Querying for namespaces" do

  before do
    @source ||= RbGCCXML.parse(full_dir("headers/namespaces.h"))
  end

  specify "can find a namespace" do
    upper = @source.namespaces.find(:name => "upper")
    upper.should be_a_kind_of(RbGCCXML::Namespace)

    inner1 = upper.namespaces("inner1")
    inner1.should be_a_kind_of(RbGCCXML::Namespace)
    inner1.name.should == "inner1"

    inner2 = upper.namespaces("inner2")
    inner2.should be_a_kind_of(RbGCCXML::Namespace)
    inner2.name.should == "inner2"

    nested = inner2.namespaces("nested")
    nested.should be_a_kind_of(RbGCCXML::Namespace)
    nested.name.should == "nested"
  end
end
