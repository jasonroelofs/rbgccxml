namespace misc {
  class AccessSettings {
    private:
      void privateMethod() {
      }
    protected:
      int protectedMethod() {
        return 1;
      }
    public:
      AccessSettings() {}
      int publicMethod() {
        return this->protectedMethod();
      }
  };
}
