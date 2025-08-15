import 'package:bidan_care/features/messages/models/oppose_user.dart';
import 'package:bidan_care/routes.dart';
import 'package:bidan_care/shared/styles/app_colors.dart';
import 'package:bidan_care/shared/styles/app_text_styles.dart';
import 'package:bidan_care/shared/utils/app_helpers.dart';
import 'package:bidan_care/shared/widgets/flat_button.dart';
import 'package:flutter/material.dart';

class PesanBerhasilPage extends StatelessWidget {
  const PesanBerhasilPage({super.key});

  static late BuildContext _context;

  void _kembali() {
    Navigator.pushNamedAndRemoveUntil(
      _context,
      Routes.main,
      (route) => false,
      arguments: 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    final opposeUser = ModalRoute.of(context)!.settings.arguments as OpposeUser;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(27, 64, 27, 24),
        child: Column(
          children: [
            Text(
              "Pesanan dikirim!",
              style: AppTextStyles.headlineMedium.apply(
                color: AppColors.primaryColor,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(24),
              margin: const EdgeInsets.only(top: 12, bottom: 54),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primaryColor, width: 5),
              ),
              child: Transform.translate(
                offset: const Offset(6, -7),
                child: const RotationTransition(
                  turns: AlwaysStoppedAnimation(-30 / 360),
                  child: Icon(
                    Icons.send_rounded,
                    size: 69,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ),
            const Text(
              "Silahkan tunggu balasan dari pihak bidan dan dapat hubungi bidan jika ada kendala atau catatan tambahan",
              textAlign: TextAlign.center,
            ),
            const Expanded(child: SizedBox()),
            FlatButton(
              text: "Hubungi Bidan",
              onPressed: () => AppHelpers.pushChatroom(context, opposeUser),
              width: double.infinity,
              color: Colors.white,
              borderRadius: 10,
              border: Border.all(color: AppColors.primaryColor),
              textStyle: const TextStyle(color: AppColors.primaryColor),
            ),
            const SizedBox(height: 8),
            FlatButton(
              text: "Kembali",
              onPressed: _kembali,
              borderRadius: 10,
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }
}
