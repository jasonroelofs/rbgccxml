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

    class NamespacedClass {
    };
  }
}

// Namespace Aliases
namespace superInner = upper::inner2;

void takes_class(superInner::NamespacedClass obj) {
}

/* Include the ability to look into the default namespace */
int not_in_namespace() {
  return -1;
}
