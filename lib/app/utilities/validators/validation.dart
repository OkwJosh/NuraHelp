class AppValidator {

  static String? validateTextField(String? fieldName,String? value){
    if(value==null || value.isEmpty){
      return '$fieldName is required';
    }
    return null;
  }

  static String? validateDropdown(String? value){
    if(value == null || value.isEmpty){
      return 'Select an option';
    }
    return null;
  }




  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegExp.hasMatch(value)) {
      return 'Invalid email address';
    }

    return null;
  }



  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }

    final passwordRegExp = RegExp(
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&.])[A-Za-z\d@$!%*?&.]{8,}$');

    if (!passwordRegExp.hasMatch(value)) {
      return 'Password must contain at least one uppercase letter,one number, and one special character';
    }

    return null; // Password is valid
  }

  static String? validateConfirmPassword(String? passwordValue, String? confirmValue) {
    if (confirmValue == null || confirmValue.isEmpty) {
      return 'Confirm password is required';
    }

    if (passwordValue == null || passwordValue.isEmpty) {
      return 'Password must be entered first';
    }

    if (confirmValue != passwordValue) {
      return 'Passwords do not match';
    }

    return null; // Passwords match
  }


  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    // Allows 10 to 15 digits (for international numbers)
    final phoneRegExp = RegExp(r'^\d{10,15}$');

    if (!phoneRegExp.hasMatch(value)) {
      return 'Invalid phone number. Must be 10 to 15 digits with no spaces or special characters.';
    }

    return null; // Valid phone number
  }

}
