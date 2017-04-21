
namespace inheritance {

  class ParentClass {
  };

  class Parent2 {
  };
  

  /**
   * Test querying of types of inheritance
   */
  class Base1 : public ParentClass {
  };

  class PrivateBase1 : private ParentClass {
  };

  /**
   * Test querying for multiple inheritance
   */
  class MultiBase : public ParentClass, public Parent2 {
  };

  /**
   * Test querying up many levels
   */
  class Base2 : public Base1 {
  };

  class VeryLow : public Base2, protected Parent2 {
  };
}
