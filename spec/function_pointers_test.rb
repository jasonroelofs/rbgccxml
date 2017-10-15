require "test_helper"

describe "Function pointers" do
  before(:all) do
    @fp_source = RbGCCXML.parse(full_dir("headers/types.hpp")).namespaces("types")
  end

  specify "have arguments" do
    fp = @fp_source.functions("takesCallback").arguments[0].cpp_type.base_type
    fp.arguments.length.should == 1
    fp.arguments[0].cpp_type.name.should == "int"
  end

  specify "have return value" do
    fp = @fp_source.functions("takesCallbackWithReturn").arguments[0].cpp_type.base_type
    fp.return_type.name.should == "int"
  end
end
