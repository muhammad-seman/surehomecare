import 'package:bidan_care/core/layouts/bidan_main_layout.dart';
import 'package:bidan_care/core/layouts/main_layout.dart';
import 'package:bidan_care/core/models/user.dart';
import 'package:bidan_care/core/viewmodels/auth_view_model.dart';
import 'package:bidan_care/features/authentication/views/login_page.dart';
import 'package:bidan_care/features/authentication/views/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthLayout extends StatefulWidget {
  const AuthLayout({super.key});

  @override
  State<AuthLayout> createState() => _AuthLayoutState();
}

class _AuthLayoutState extends State<AuthLayout> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    context.read<AuthViewModel>().authCheck().then((_) {
      setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    // return const WelcomePage();
    if (_isLoading) return const Scaffold();

    final isNewUser =
        context.select<AuthViewModel, bool>((viewModel) => viewModel.isNewUser);
    if (isNewUser) return const WelcomePage();

    final currentUser = context
        .select<AuthViewModel, User?>((viewModel) => viewModel.currentUser);
    if (currentUser == null) return const LoginPage();

    if (currentUser.isBidan) return const BidanMainLayout();

    return const MainLayout();
  }
}
