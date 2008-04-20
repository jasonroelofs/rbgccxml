/**
 * File for testing the ability to find namespaces
 */

namespace upper {

  void method1() { }

  namespace inner1 {
    void method2() { }
  }

  namespace inner2 {
    void method3() { }
    
    namespace nested {
      void method4() { }
    }

  }

}
