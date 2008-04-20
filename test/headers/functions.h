/**
 * This header file is for testing free (top) level function
 * parsing and querying
 */

namespace functions {

  void test1() { }

  void test2(int arg1) {  }

  void test3(int arg1, float arg2) { }

  int test4(int arg1, int arg2) { }

  bool bool_method() {  }

  int bigArgs(int arg1, float arg2, char* arg3, bool arg4) {  return 0; }

  namespace nested1 {
    namespace nested2 {
      void nestedFunction();
    }
  }
}
