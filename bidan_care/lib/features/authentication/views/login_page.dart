import 'package:bidan_care/core/viewmodels/auth_view_model.dart';
import 'package:bidan_care/routes.dart';
import 'package:bidan_care/shared/styles/app_colors.dart';
import 'package:bidan_care/shared/styles/app_text_styles.dart';
import 'package:bidan_care/shared/widgets/app_text_field.dart';
import 'package:bidan_care/shared/widgets/flat_button.dart';
import 'package:bidan_care/shared/widgets/global_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlobalAppBar.hidden(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 27, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle(),
              _buildHeading(),
              const _LoginForm(),
              _buildDaftarOption(context),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildDaftarOption(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Belum punya akun?"),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, Routes.daftar);
          },
          child: const Text(
            "Daftar",
            style: TextStyle(
              color: AppColors.primaryColor,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  Padding _buildHeading() {
    return const Padding(
      padding: EdgeInsets.only(top: 127),
      child: Text(
        "Welcome Back!",
        style: AppTextStyles.headlineMedium,
      ),
    );
  }

  Center _buildTitle() {
    return Center(
      child: Text(
        "iCare",
        style: AppTextStyles.titleLarge.apply(color: AppColors.primaryColor),
      ),
    );
  }
}

class _LoginForm extends StatefulWidget {
  const _LoginForm();

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String _error = "";

  Future _submitLogin() async {
    setState(() => _error = "");
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final error =
        await context.read<AuthViewModel>().login(email, password) ?? _error;
    setState(() => _error = error);
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 45, bottom: 64),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Text(_error, style: const TextStyle(color: Colors.red)),
            AppTextField(
              hint: "Email",
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
            ),
            AppTextField(
              hint: "Kata Sandi",
              icon: Icons.lock_outline,
              controller: _passwordController,
              isPassword: true,
              margin: EdgeInsets.zero,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, Routes.requestUbahPassword);
                },
                child: const Text("Lupa Kata Sandi?"),
              ),
            ),
            const SizedBox(height: 12),
            _SubmitButton(onSubmit: _submitLogin)
          ],
        ),
      ),
    );
  }
}

class _SubmitButton extends StatefulWidget {
  const _SubmitButton({required this.onSubmit});
  final Future Function() onSubmit;

  @override
  State<_SubmitButton> createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<_SubmitButton> {
  bool _isLoading = false;

  void _login() {
    setState(() => _isLoading = true);
    widget.onSubmit().then((error) {
      setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: FlatButton(
            text: "Masuk",
            onPressed: _login,
            enabled: !_isLoading,
          ),
        ),
      ],
    );
  }
}
