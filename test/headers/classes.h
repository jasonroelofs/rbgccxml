namespace classes {
  class Test1 {
    public: 
      Test1() {  }

      static void staticMethod() {  }

      class Inner1 {
        public:
          class Inner2 {
          };

          void innerFunc() {  }
      };
  };

  class Test2 {
    public:
      Test2() {  }
      Test2(int a) { }

      void func1() {}
      int func2(int a, float b) { return 1; }
  };

  class Test3 {

  };
  
  class Test4 {
    public:
      virtual int func1() = 0;
      virtual Test1 func2() = 0;
  };
}
