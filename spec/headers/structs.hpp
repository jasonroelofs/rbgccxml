namespace structs {
  struct Test1 {
    Test1() {  }

    static void staticMethod() {  }

    struct Inner1 {
      struct Inner2 {
      };

      void innerFunc() {  }
    };
  };

  struct Test2 {
    Test2() {  }
    Test2(int a) { }

    void func1() {}
    int func2(int a, float b) { return 1; }
  };

  struct Test3 {

  };
}
