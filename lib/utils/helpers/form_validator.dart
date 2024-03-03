
class FormValidator {

  static String? validateEmail(String? email) {
    if (email!.isEmpty) return "Please enter an email!";
    String pattern =
        r'^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$';
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(email)) {
      return "Please enter a valid email";
    }
    return null;
  }

  static String? validatePassword(String? password) {
    if (password!.isEmpty) return 'Please enter a password.';
    if (password.length < 8) return 'Password must contain at least 8 characters.';
    String  pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(password)) {
      return "Password must contains minimum 1 Upper case, 1 lowercase, 1 Numeric Number, 1 Special Character";
    }
    return null;
  }
}
