import 'package:bidan_care/shared/styles/app_colors.dart';
import 'package:flutter/material.dart';

class GlobalAppBar {
  static AppBar hidden({Color? backgkroundColor}) {
    return AppBar(
      elevation: 0,
      toolbarHeight: 0,
      backgroundColor: backgkroundColor ?? AppColors.scaffoldBackground,
      shadowColor: Colors.transparent,
    );
  }

  static AppBar transparent({List<Widget>? actions, Color? backgkroundColor}) {
    return AppBar(
      elevation: 0,
      actions: actions,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      backgroundColor: backgkroundColor ?? AppColors.scaffoldBackground,
    );
  }
}
