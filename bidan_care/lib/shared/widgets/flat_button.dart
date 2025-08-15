import 'package:bidan_care/shared/styles/app_colors.dart';
import 'package:flutter/material.dart';

class FlatButton extends StatelessWidget {
  const FlatButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color = AppColors.primaryColor,
    this.borderRadius = 5,
    this.border,
    this.padding = const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
    this.textStyle,
    this.width,
    this.height,
    this.enabled = true,
    this.disabledColor,
    this.disabledBorder,
  });

  final String text;
  final Color color;
  final Color? disabledColor;
  final double borderRadius;
  final void Function() onPressed;
  final BoxBorder? border;
  final BoxBorder? disabledBorder;
  final EdgeInsetsGeometry padding;
  final TextStyle? textStyle;
  final double? width;
  final double? height;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    const TextStyle defaultTextStyle = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    );

    return Material(
      color: Colors.transparent,
      child: Ink(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: enabled ? color : disabledColor ?? color.withOpacity(0.6),
          borderRadius: BorderRadius.circular(borderRadius),
          border: enabled ? border : disabledBorder,
        ),
        child: InkWell(
          onTap: enabled ? onPressed : null,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Padding(
            padding: padding,
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: defaultTextStyle.merge(textStyle),
            ),
          ),
        ),
      ),
    );
  }
}
