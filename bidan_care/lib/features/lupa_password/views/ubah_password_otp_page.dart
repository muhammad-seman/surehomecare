import 'package:bidan_care/core/viewmodels/auth_view_model.dart';
import 'package:bidan_care/shared/styles/app_colors.dart';
import 'package:bidan_care/shared/widgets/app_text_field.dart';
import 'package:bidan_care/shared/widgets/flat_button.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class UbahPasswordOtpPage extends StatefulWidget {
  const UbahPasswordOtpPage({super.key});

  @override
  State<UbahPasswordOtpPage> createState() => _UbahPasswordOtpPageState();
}

class _UbahPasswordOtpPageState extends State<UbahPasswordOtpPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _kPasswordController = TextEditingController();

  String _error = "";
  bool _isLoading = false;

  void _ubahPassword() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isLoading = true);
    final password = _passwordController.text;

    context
        .read<AuthViewModel>()
        .ubahPasswordOTP(password)
        .then(_postUbahPassword);
  }

  _postUbahPassword(String error) {
    setState(() => _isLoading = false);
    if (error.isEmpty) {
      Navigator.pop(context);
      Fluttertoast.showToast(
        msg: "Kata sandi berhasil diubah",
        backgroundColor: AppColors.toastBgColor,
        textColor: AppColors.toastTextColor,
      );
    } else {
      setState(() => _error = error);
    }
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    if (value.length < 8) {
      return 'Password minimal 8 karakter';
    }
    if (_passwordController.text != _kPasswordController.text) {
      return "Kedua password tidak sama";
    }
    return null;
  }

  @override
  void dispose() {
    super.dispose();
    _passwordController.dispose();
    _kPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ubah Kata Sandi")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    _error,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
                AppTextField(
                  hint: "Kata Sandi Baru",
                  controller: _passwordController,
                  isPassword: true,
                  validator: _passwordValidator,
                ),
                AppTextField(
                  hint: "Ulangi Kata Sandi Baru",
                  controller: _kPasswordController,
                  isPassword: true,
                  validator: _passwordValidator,
                ),
                const SizedBox(height: 16),
                FlatButton(
                  text: "Submit",
                  onPressed: _ubahPassword,
                  enabled: !_isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
