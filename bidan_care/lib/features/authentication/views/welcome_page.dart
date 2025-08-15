import 'package:bidan_care/core/viewmodels/auth_view_model.dart';
import 'package:bidan_care/routes.dart';
import 'package:bidan_care/shared/styles/app_colors.dart';
import 'package:bidan_care/shared/styles/app_text_styles.dart';
import 'package:bidan_care/shared/widgets/app_text_field.dart';
import 'package:bidan_care/shared/widgets/global_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

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
              const _NameForm(),
              _buildLoginOption(context),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildLoginOption(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Sudah punya akun?"),
        TextButton(
          onPressed: context.read<AuthViewModel>().updateNewUser,
          child: const Text(
            "Masuk",
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
      padding: EdgeInsets.symmetric(vertical: 81),
      child: Text("Selamat Datang!", style: AppTextStyles.headlineMedium),
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

class _NameForm extends StatefulWidget {
  const _NameForm();

  @override
  State<_NameForm> createState() => _NameFormState();
}

class _NameFormState extends State<_NameForm> {
  final _namaController = TextEditingController();
  String get _nama => _namaController.text.trim();

  @override
  void dispose() {
    super.dispose();
    _namaController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Bolehkah kami tahu nama Ibu?"),
        AppTextField(
          hint: "Nama Anda",
          controller: _namaController,
          keyboardType: TextInputType.name,
          validator: (value) => (value?.isEmpty ?? true) ? "" : null,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              Navigator.pushNamed(context, Routes.daftar, arguments: _nama);
            },
            style: const ButtonStyle(
              foregroundColor: WidgetStatePropertyAll(AppColors.primaryColor),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Selanjutnya"),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward, size: 14),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
