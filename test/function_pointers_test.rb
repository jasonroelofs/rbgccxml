require "test_helper"

context "Function pointers" do
  setup do
    @@fp_source ||= RbGCCXML.parse(full_dir("headers/types.h")).namespaces("types")
  end

  specify "have arguments" do
    fp = @@fp_source.functions("takesCallback").arguments[0].cpp_type.base_type
    fp.arguments.length.should == 1
    fp.arguments[0].cpp_type.name.should.equal "int"
  end

  specify "have return value" do
    fp = @@fp_source.functions("takesCallbackWithReturn").arguments[0].cpp_type.base_type
    fp.return_type.name.should.equal "int"
  end
end
