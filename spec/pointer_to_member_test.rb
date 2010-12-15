require "test_helper"

describe "Pointer to member function or member variable" do
  before(:all) do
    @ptm_source = RbGCCXML.parse(
      full_dir("headers/pointer_to_member.h")).namespaces("pointer_to_member")
  end

  specify "finds the test struct" do
    xyz = @ptm_source.structs("xyz_t")
    xyz.should be_a_kind_of(RbGCCXML::Struct)
    xyz.methods('do_something').should be_a_kind_of(RbGCCXML::Method)
    xyz.variables('m_some_member').should be_a_kind_of(RbGCCXML::Field)
  end

  specify "finds pointer to member variable" do
    mvar_ptr = @ptm_source.children.find {|c| c.name == 'mvar_ptr_t'}
    mvar_ptr.should be_a_kind_of(RbGCCXML::Typedef)

    mvar_ptr_type = RbGCCXML::NodeCache.find(mvar_ptr.attributes["type"])
    mvar_ptr_type.should be_a_kind_of(RbGCCXML::Node) # OffsetType?
  end

  specify "finds pointer to member function" do
    mfun_ptr = @ptm_source.children.find {|c| c.name == 'mfun_ptr_t'}
    mfun_ptr.should be_a_kind_of(RbGCCXML::Typedef)

    mfun_ptr_type = RbGCCXML::NodeCache.find(mfun_ptr.attributes["type"])
    mfun_ptr_type.should be_a_kind_of(RbGCCXML::PointerType)

    type = RbGCCXML::NodeCache.find(mfun_ptr_type.attributes["type"])
    type.should be_a_kind_of(RbGCCXML::MethodType)
  end
end

