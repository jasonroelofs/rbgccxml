/**
 * This header file is for testing the various ways and options
 * available to QueryResult#find
 */

namespace query {

  struct MyType {

  };

  // Access type querying
  class AccessTester {
    public: 
      AccessTester();
      void publicMethod();

    protected:
      void protectedMethod();

    private:
      void privateMethod();
  };

  // Various test methods for argument and return type querying
  void test1();

  void test2(int arg1);

  void test3(int arg1, float arg2);

  int test4(int arg1, int arg2);

  bool bool_method();

  int bigArgs(int arg1, float arg2, char* arg3, bool arg4);

  // Custom type teturn type testing
  MyType testMyType();
  MyType* testMyTypePtr();
  MyType& testMyTypeRef();
  const MyType testMyTypeConst();

  // Custom type argument testing
  void testMyTypeArgs(MyType arg1);
  void testMyTypeArgsPtr(MyType* arg1);
  void testMyTypeArgsRef(MyType& arg1);
  void testMyTypeArgsConstPtr(const MyType* arg1);
  void testConstMyTypeArgsConstPtr(const MyType* const arg1);

  // Can find methods via qualified names
  namespace nested1 {
    namespace nested2 {
      void nestedFunction();

      MyType nestedMyTypeReturns();
    }

    void nestedMyTypeArg(MyType arg1, MyType arg2);
  }
}
