require "test_helper"

describe "Querying for namespaces" do

  before do
    @source ||= RbGCCXML.parse(full_dir("headers/namespaces.hpp"))
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

  specify "handles namespace aliases" do
    takes_class = @source.functions.find(:name => "takes_class")
    aliased_arg = takes_class.arguments.first
    aliased_arg.cpp_type.to_cpp.should == "::upper::inner2::NamespacedClass"
  end
end
