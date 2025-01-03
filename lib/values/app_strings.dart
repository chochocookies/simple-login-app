class AppStrings {
  const AppStrings._();

  static const String loginAndRegister = 'Login and Register UI';
  static const String uhOhPageNotFound = 'uh-oh!\nPage not found';
  static const String register = 'Register';
  static const String login = 'Login';
  static const String logout = 'Logout';
  static const String createYourAccount = 'Create your account';
  static const String doNotHaveAnAccount = "Don't have an account?";
  static const String facebook = 'Facebook';
  static const String google = 'Google';
  static const String signInToYourNAccount = 'Sign in to your\nAccount';
  static const String signInToYourAccount = 'Sign in to your Account';
  static const String iHaveAnAccount = 'I have an account?';

  static const String forgotPassword = 'Forgot Password?';
  static const String resetPassword = 'Reset Password?';
  static const String sendResetLink =
      'Input your email and we will send you a link to reset your password';
  static const String sendResetLinkButton = 'Send email';
  static const String updatePassword = 'Update Password?';
  static const String enterNewPassword = 'Please Enter New Password?';
  static const String newPassword = 'Confirm Your Password?';
  static const String updatePasswordButton = 'Update Password';
  static const String confirmPasswordButton = 'Confirm Your Password?';

  static const String passwordLengthCriteria =
      'Password must be at least 8 characters long.';
  static const String passwordLengthCriteriaSuccess =
      'Password length is sufficient.';

  static const String passwordUppercaseCriteria =
      'Password must contain at least one uppercase letter.';
  static const String passwordUppercaseCriteriaSuccess =
      'Password contains an uppercase letter.';

  static const String passwordSpecialCharCriteria =
      'Password must include at least one special character (@, #, -, etc.).';
  static const String passwordSpecialCharCriteriaSuccess =
      'Password contains a special character.';

  static const String rememberMe = 'Remember Me';
  static const String orLoginWith = 'or Login with';

  static const String loggedIn = 'Logged In!';
  static const String registrationComplete = 'Registration Complete!';

  static const String name = 'Name';
  static const String pleaseEnterName = 'Please, Enter Name';
  static const String invalidName = 'Invalid Name';

  static const String email = 'Email';
  static const String pleaseEnterEmailAddress = 'Please, Enter Email Address';
  static const String invalidEmailAddress = 'Invalid Email Address';

  static const String password = 'Password';
  static const String pleaseEnterPassword = 'Please, Enter Password';
  static const String invalidPassword = 'Invalid Password';

  static const String confirmPassword = 'Confirm Password';
  static const String pleaseReEnterPassword = 'Please, Re-Enter Password';
  static const String passwordNotMatched = 'Password not matched!';

  static var errorOccurred;

  static String? passwordResetEmailSent;
}
