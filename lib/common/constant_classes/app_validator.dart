// Validator.dart
// Fixed & Aligned with your Signup Requirements (Full Name + PK Phone Format)

class Validator {
  // Email Regex (works correctly for normal emails)
  static final RegExp _emailReg = RegExp(
    r"^[a-zA-Z0-9.!#%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*\.[A-Za-z]{2,}$"
  );

  // Password: Min 8 chars, upper, lower, number, special char
  static final RegExp _passwordReg = RegExp(
    r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#\$&*~._-]).{8,}$'
  );

  // Full Name (letters + space allowed)
  static final RegExp _fullNameReg = RegExp(
    r"^[A-Za-z\u00C0-\u017F' -]{3,50}$"
  );

  // Pakistani Phone Number: 0300-XXXXXXX OR +92300XXXXXXX
  static final RegExp _phoneReg = RegExp(
    r'^(\+92|0)?3\d{9}$'
  );

  // ---------- Boolean Check Functions ----------
  static bool isEmail(String? value) =>
      value != null && _emailReg.hasMatch(value.trim());

  static bool isPassword(String? value) =>
      value != null && _passwordReg.hasMatch(value);

  static bool isFullName(String? value) =>
      value != null && _fullNameReg.hasMatch(value.trim());

  static bool isPhoneNumber(String? value) =>
      value != null && _phoneReg.hasMatch(value.trim());

  static bool isConfirmPassword(String? password, String? confirm) =>
      password == confirm;

  // ---------- Form Field Validators ----------
  static String? emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    if (!isEmail(value)) return 'Enter a valid email address';
    return null;
  }

  static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (!isPassword(value)) {
      return 'Password must be ≥8 chars & include upper, lower, number & special char';
    }
    return null;
  }

  // ✅ Full Name Validator (same name as you used: usernameValidator)
  static String? usernameValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'Full name is required';
    if (!isFullName(value)) return 'Enter a valid full name';
    return null;
  }

  static String? phoneValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'Phone number is required';
    if (!isPhoneNumber(value)) return 'Enter valid Pakistani phone number';
    return null;
  }

  static String? confirmPasswordValidator(String? confirm, String? password) {
    if (confirm == null || confirm.isEmpty) return 'Confirm password is required';
    if (password != confirm) return 'Passwords do not match';
    return null;
  }
}
