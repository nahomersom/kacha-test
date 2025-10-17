class AuthValidators {
  static bool isValidEmail(String input) {
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return emailRegex.hasMatch(input.trim());
  }

  static bool isStrongPassword(String input) {
    // At least 8 chars, one letter, one number
    final passRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d!@#\$%\^&\*]{8,}$');
    return passRegex.hasMatch(input);
  }
}


