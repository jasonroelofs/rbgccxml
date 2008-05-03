#include <string>

namespace logger {

  class Logger {
    public:
      void debug(std::string message);
      void log(std::string message);
      int numLogsWritten();
  };
}
