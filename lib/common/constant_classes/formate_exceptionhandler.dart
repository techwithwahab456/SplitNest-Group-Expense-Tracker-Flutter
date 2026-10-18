// lib/common/services/format_exception_handler.dart
class FormatExceptionHandler {
  static String handle(FormatException e) {
    return "Data format error: ${e.message}. Please check your input and try again.";
  }

  static String handleJson(String source) {
    return "Invalid data format received. Expected valid JSON from: $source";
  }

  static String handleDateTime(String value) {
    return "Invalid date/time format: $value. Expected format: YYYY-MM-DD HH:MM:SS";
  }
}
