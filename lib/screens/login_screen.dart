import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '/utils/helpers/snackbar_helper.dart';
import '/values/app_regex.dart';
import '../components/app_text_form_field.dart';
// import '../resources/resources.dart';
import '../utils/common_widgets/gradient_background.dart';
import '../utils/helpers/navigation_helper.dart';
import '../values/app_constants.dart';
import '../values/app_routes.dart';
import '../values/app_strings.dart';
import '../values/app_theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final ValueNotifier<bool> passwordNotifier = ValueNotifier(true);
  final ValueNotifier<bool> fieldValidNotifier = ValueNotifier(false);
  final ValueNotifier<bool> rememberMeNotifier = ValueNotifier(false);

  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  void initializeControllers() {
    emailController = TextEditingController()..addListener(controllerListener);
    passwordController = TextEditingController()
      ..addListener(controllerListener);
  }

  void disposeControllers() {
    emailController.dispose();
    passwordController.dispose();
  }

  void controllerListener() {
    final email = emailController.text;
    final password = passwordController.text;

    if (email.isEmpty && password.isEmpty) return;

    if (AppRegex.emailRegex.hasMatch(email) &&
        AppRegex.passwordRegex.hasMatch(password)) {
      fieldValidNotifier.value = true;
    } else {
      fieldValidNotifier.value = false;
    }
  }

  Future<void> _loginUser() async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final String uid = userCredential.user?.uid ?? '';

      if (uid.isEmpty) {
        throw FirebaseAuthException(
            code: 'UID_NOT_FOUND', message: 'UID tidak ditemukan.');
      }

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'name': 'User Default',
        'email': emailController.text.trim(),
        'role': 'user',
      }, SetOptions(merge: true));

      SnackbarHelper.showSnackBar(AppStrings.loggedIn);

      NavigationHelper.pushReplacementNamed(
        AppRoutes.homepage,
        arguments: uid,
      );
    } on FirebaseAuthException catch (e) {
      SnackbarHelper.showSnackBar(e.message ?? AppStrings.errorOccurred);
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return null; // Jika pengguna membatalkan login
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      final User? user = userCredential.user;

      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': user.displayName ?? 'User Default',
          'email': user.email,
          'role': 'user',
        }, SetOptions(merge: true));
      }

      return user;
    } catch (e) {
      debugPrint('Google Sign-In error: $e');
      return null;
    }
  }

  void _handleGoogleSignIn() async {
    final user = await signInWithGoogle();
    if (user != null) {
      NavigationHelper.pushReplacementNamed(
        AppRoutes.homepage,
        arguments: user.uid,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Google Sign-In failed.')),
      );
    }
  }

  Widget _buildPasswordCriteria() {
    final password = passwordController.text;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          password.isNotEmpty && AppRegex.passwordLengthRegex.hasMatch(password)
              ? AppStrings.passwordLengthCriteriaSuccess
              : AppStrings.passwordLengthCriteria,
          style: TextStyle(
            color: AppRegex.passwordLengthRegex.hasMatch(password)
                ? Colors.green
                : Colors.red,
          ),
        ),
        Text(
          password.isNotEmpty &&
                  AppRegex.passwordUppercaseRegex.hasMatch(password)
              ? AppStrings.passwordUppercaseCriteriaSuccess
              : AppStrings.passwordUppercaseCriteria,
          style: TextStyle(
            color: AppRegex.passwordUppercaseRegex.hasMatch(password)
                ? Colors.green
                : Colors.red,
          ),
        ),
        Text(
          password.isNotEmpty &&
                  AppRegex.passwordSpecialCharRegex.hasMatch(password)
              ? AppStrings.passwordSpecialCharCriteriaSuccess
              : AppStrings.passwordSpecialCharCriteria,
          style: TextStyle(
            color: AppRegex.passwordSpecialCharRegex.hasMatch(password)
                ? Colors.green
                : Colors.red,
          ),
        ),
      ],
    );
  }

  Future<void> _resetPassword() async {
    if (emailController.text.isEmpty) {
      SnackbarHelper.showSnackBar(AppStrings.pleaseEnterEmailAddress);
      return;
    }

    try {
      await _auth.sendPasswordResetEmail(email: emailController.text.trim());
      SnackbarHelper.showSnackBar(AppStrings.passwordResetEmailSent);
    } catch (e) {
      SnackbarHelper.showSnackBar(AppStrings.errorOccurred);
    }
  }

  @override
  void initState() {
    initializeControllers();
    super.initState();
  }

  @override
  void dispose() {
    disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          const GradientBackground(
            children: [
              Text(
                AppStrings.signInToYourNAccount,
                style: AppTheme.titleLarge,
              ),
              SizedBox(height: 6),
              Text(AppStrings.signInToYourAccount, style: AppTheme.bodySmall),
            ],
          ),
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AppTextFormField(
                    controller: emailController,
                    labelText: AppStrings.email,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    onChanged: (_) => _formKey.currentState?.validate(),
                    validator: (value) {
                      return value!.isEmpty
                          ? AppStrings.pleaseEnterEmailAddress
                          : AppConstants.emailRegex.hasMatch(value)
                              ? null
                              : AppStrings.invalidEmailAddress;
                    },
                  ),
                  ValueListenableBuilder(
                    valueListenable: passwordNotifier,
                    builder: (_, passwordObscure, __) {
                      return AppTextFormField(
                        obscureText: passwordObscure,
                        controller: passwordController,
                        labelText: AppStrings.password,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.visiblePassword,
                        onChanged: (_) => _formKey.currentState?.validate(),
                        validator: (value) {
                          return value!.isEmpty
                              ? AppStrings.pleaseEnterPassword
                              : AppConstants.passwordRegex.hasMatch(value)
                                  ? null
                                  : AppStrings.invalidPassword;
                        },
                        suffixIcon: IconButton(
                          onPressed: () =>
                              passwordNotifier.value = !passwordObscure,
                          style: IconButton.styleFrom(
                            minimumSize: const Size.square(48),
                          ),
                          icon: Icon(
                            passwordObscure
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            size: 20,
                            color: Colors.black,
                          ),
                        ),
                      );
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          ValueListenableBuilder(
                            valueListenable: rememberMeNotifier,
                            builder: (_, rememberMe, __) {
                              return Checkbox(
                                value: rememberMe,
                                onChanged: (value) {
                                  rememberMeNotifier.value = value ?? false;
                                },
                              );
                            },
                          ),
                          const Text(AppStrings.rememberMe),
                        ],
                      ),
                      TextButton(
                        onPressed: () => NavigationHelper.pushReplacementNamed(
                          AppRoutes.forgotPassword,
                        ),
                        child: const Text(AppStrings.forgotPassword),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ValueListenableBuilder(
                    valueListenable: fieldValidNotifier,
                    builder: (_, isValid, __) {
                      return FilledButton(
                        onPressed: isValid ? _loginUser : null,
                        child: const Text(AppStrings.login),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(child: Divider(color: Colors.grey.shade200)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          AppStrings.orLoginWith,
                          style: AppTheme.bodySmall.copyWith(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: Colors.grey.shade200)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed:
                              _handleGoogleSignIn, // Memanggil fungsi sign-in Google
                          icon: SvgPicture.asset('assets/vectors/google.svg',
                              width: 14),
                          label: const Text(
                            AppStrings.google,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppStrings.doNotHaveAnAccount,
                style: AppTheme.bodySmall.copyWith(color: Colors.black),
              ),
              const SizedBox(width: 4),
              TextButton(
                onPressed: () => NavigationHelper.pushReplacementNamed(
                  AppRoutes.register,
                ),
                child: const Text(AppStrings.register),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
