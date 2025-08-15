import 'package:bidan_care/shared/models/profile_action.dart';
import 'package:bidan_care/shared/styles/app_colors.dart';
import 'package:bidan_care/shared/styles/app_shadows.dart';
import 'package:bidan_care/shared/styles/app_text_styles.dart';
import 'package:flutter/material.dart';

class ProfileActionsContainer extends StatelessWidget {
  const ProfileActionsContainer({
    super.key,
    required this.listActions,
    this.margin = const EdgeInsets.symmetric(
      horizontal: 27,
      vertical: 21,
    ),
  });

  final List<ProfileAction> listActions;
  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: AppShadows.medium,
      ),
      clipBehavior: Clip.hardEdge,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: listActions.length,
        itemBuilder: (context, index) {
          final action = listActions[index];
          return Material(
            color: Colors.transparent,
            child: ListTile(
              minTileHeight: 48,
              onTap: action.onPressed,
              leading: Icon(
                action.icon,
                color: AppColors.dividerColor,
              ),
              title: Text(
                action.title,
                style: AppTextStyles.bodyMedium,
              ),
              trailing: const Icon(
                Icons.keyboard_arrow_right,
                color: AppColors.dividerColor,
                size: 16,
              ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return const Divider(
            height: 1,
            thickness: 1,
            indent: 36,
            endIndent: 36,
          );
        },
      ),
    );
  }
}
