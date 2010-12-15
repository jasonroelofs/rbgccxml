/**
 * This header file is for testing pointers to member functions and member
 * variables.
 */
namespace pointer_to_member {

// Based on
// http://www.language-binding.net/pygccxml/upgrade_issues.html
struct xyz_t {
  int do_something( double );
  int m_some_member;
};

typedef int (xyz_t::*mfun_ptr_t)( double );

typedef int (xyz_t::*mvar_ptr_t);

}
