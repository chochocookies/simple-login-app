import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/helpers/snackbar_helper.dart';
import '../components/app_text_form_field.dart';
import '../values/app_strings.dart';
import '../values/app_theme.dart';
import 'update_password_screen.dart'; // Pastikan halaman ubah password diimpor

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _sendPasswordResetEmail() async {
    try {
      if (emailController.text.isEmpty) {
        SnackbarHelper.showSnackBar("Masukkan email Anda.");
        return;
      }

      await _auth.sendPasswordResetEmail(email: emailController.text.trim());
      SnackbarHelper.showSnackBar(
          "Email reset password telah dikirim ke ${emailController.text.trim()}.");

      // Navigasi ke halaman ubah password setelah email terkirim
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              const UpdatePasswordScreen(), // Halaman ubah password
        ),
      );
    } catch (e) {
      SnackbarHelper.showSnackBar("Gagal mengirim email reset password: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.forgotPassword)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              AppStrings.resetPassword,
              style: AppTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            AppTextFormField(
              controller: emailController,
              labelText: AppStrings.email,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendPasswordResetEmail,
              child: const Text(AppStrings.sendResetLinkButton),
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
