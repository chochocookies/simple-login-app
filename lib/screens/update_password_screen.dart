import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/helpers/snackbar_helper.dart';
import '../components/app_text_form_field.dart';
import '../values/app_strings.dart';
import '../values/app_theme.dart';

class UpdatePasswordScreen extends StatefulWidget {
  const UpdatePasswordScreen({super.key});

  @override
  State<UpdatePasswordScreen> createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _updatePassword() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        SnackbarHelper.showSnackBar(
            "Pengguna tidak ditemukan. Silakan login kembali.");
        return;
      }

      final password = passwordController.text.trim();
      final confirmPassword = confirmPasswordController.text.trim();

      if (password.isEmpty || confirmPassword.isEmpty) {
        SnackbarHelper.showSnackBar("Kata sandi tidak boleh kosong.");
        return;
      }

      if (password != confirmPassword) {
        SnackbarHelper.showSnackBar("Kata sandi tidak cocok.");
        return;
      }

      await user.updatePassword(password);
      SnackbarHelper.showSnackBar("Kata sandi berhasil diperbarui.");

      Navigator.pop(context); // Kembali ke halaman sebelumnya setelah berhasil
    } catch (e) {
      SnackbarHelper.showSnackBar("Gagal memperbarui kata sandi: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.updatePassword)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              AppStrings.enterNewPassword,
              style: AppTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            AppTextFormField(
              controller: passwordController,
              labelText: AppStrings.newPassword,
              obscureText: true,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 10),
            AppTextFormField(
              controller: confirmPasswordController,
              labelText: AppStrings.confirmPassword,
              obscureText: true,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updatePassword,
              child: const Text(AppStrings.updatePasswordButton),
            ),
          ],
        ),
      ),
    );
  }
}
