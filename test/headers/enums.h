/**
 * This header file is for testing wrapping and using enumerations
 */

#ifndef __ENUMS__H__
#define __ENUMS__H__

#include <string>

namespace enums {
  enum TestEnum {
    VALUE1,
    VALUE2,
    VALUE3
  };

  enum MyEnum {
    I_LIKE_MONEY = 3,
    YOU_LIKE_MONEY_TOO,
    I_LIKE_YOU = 7
  };

  class Inner {
    public:
      enum InnerEnum {
        INNER_1,
        INNER_2,
      };
  };
}

#endif
