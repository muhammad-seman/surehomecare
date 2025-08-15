import 'package:bidan_care/core/viewmodels/auth_view_model.dart';
import 'package:bidan_care/routes.dart';
import 'package:bidan_care/shared/widgets/app_text_field.dart';
import 'package:bidan_care/shared/widgets/flat_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RequestUbahPasswordPage extends StatefulWidget {
  const RequestUbahPasswordPage({super.key});

  @override
  State<RequestUbahPasswordPage> createState() =>
      _RequestUbahPasswordPageState();
}

class _RequestUbahPasswordPageState extends State<RequestUbahPasswordPage> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String _error = "";
  bool _isLoading = false;

  void _requestUbahPassword() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isLoading = true);
    final email = _emailController.text.trim();
    context
        .read<AuthViewModel>()
        .requestUbahPassword(email)
        .then(_postRequestUbahPassword);
  }

  _postRequestUbahPassword(String error) {
    setState(() => _isLoading = false);
    if (error.isEmpty) {
      Navigator.pushReplacementNamed(context, Routes.checkOtp);
    } else {
      setState(() => _error = error);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lupa Kata Sandi")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
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
                const Text("Masukkan email Anda:"),
                const SizedBox(height: 8),
                AppTextField(
                  hint: "Email Anda",
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                FlatButton(
                  text: "Submit",
                  onPressed: _requestUbahPassword,
                  enabled: !_isLoading,
                  width: double.infinity,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
