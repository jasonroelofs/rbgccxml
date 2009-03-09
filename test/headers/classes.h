namespace classes {

  static double GLOBAL_CONST = 10.3;

  int namespaceVar = 1;

  class Test1 {
    public: 
      static int CONST;
      int publicVariable;
      float publicVariable2;

      Test1() {  }
      ~Test1() { }

      static void staticMethod() {  }

      class Inner1 {
        public:
          class Inner2 {
          };

          void innerFunc() {  }
      };

    protected:
      double protVariable;
      

    private:
      int privateVariable;
  };

  class Test2 {
    public:
      Test2() {  }
      Test2(int a) { }

      void func();
      void func1() {}
      int func2(int a, float b) { return 1; }
  };

  class Test3 {

  };
  
  class Test4 {
    public:
      virtual int func1() {
        return -1;
      }
      virtual Test1 func2() {
        return Test1();
      }
      virtual int func3() = 0;
  };
}
