import 'package:bidan_care/core/viewmodels/auth_view_model.dart';
import 'package:bidan_care/routes.dart';
import 'package:bidan_care/shared/widgets/app_text_field.dart';
import 'package:bidan_care/shared/widgets/flat_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckOtpPage extends StatefulWidget {
  const CheckOtpPage({super.key});

  @override
  State<CheckOtpPage> createState() => _CheckOtpPageState();
}

class _CheckOtpPageState extends State<CheckOtpPage> {
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String _error = "";
  bool _isLoading = false;

  void _checkOTP() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isLoading = true);
    final otp = int.parse(_otpController.text);
    context.read<AuthViewModel>().checkOTP(otp).then(_postCheckOTP);
  }

  _postCheckOTP(String error) {
    setState(() => _isLoading = false);
    if (error.isEmpty) {
      Navigator.pushReplacementNamed(context, Routes.ubahPasswordOtp);
    } else {
      setState(() => _error = error);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _otpController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verifikasi OTP")),
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
                const Text(
                  "Masukkan kode OTP yang telah dikirim ke email Anda:",
                ),
                const SizedBox(height: 8),
                AppTextField(
                  hint: "Kode OTP",
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                FlatButton(
                  text: "Submit",
                  onPressed: _checkOTP,
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
