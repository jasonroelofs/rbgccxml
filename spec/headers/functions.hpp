/**
 * This header file is for testing free (top) level function
 * parsing and querying
 */

namespace functions {

  void test1(int x, double y = 3.0) { }

  bool bool_method() { return false;  }

  namespace nested1 {
    namespace nested2 {
      void nestedFunction();
    }
  }

  int test();

  int rockin(int x, int y = test());
}
