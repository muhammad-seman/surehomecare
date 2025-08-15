import 'package:flutter/material.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.hint,
    required this.controller,
    this.keyboardType,
    this.icon,
    this.validator,
    this.isPassword = false,
    this.isMultiline = false,
    this.margin = const EdgeInsets.only(bottom: 12),
    this.emptyErrorLabel,
    this.onChanged,
  });

  final String hint;
  final TextEditingController controller;
  final bool isPassword;
  final TextInputType? keyboardType;
  final IconData? icon;
  final bool isMultiline;
  final String? Function(String? value)? validator;
  final EdgeInsetsGeometry margin;
  final String? emptyErrorLabel;
  final Function(String value)? onChanged;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _isVisible = false;

  String? _defaultValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "${widget.emptyErrorLabel ?? widget.hint} tidak boleh kosong";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.margin,
      child: Stack(
        children: [
          TextFormField(
            controller: widget.controller,
            onChanged: widget.onChanged,
            keyboardType: widget.isMultiline
                ? TextInputType.multiline
                : widget.keyboardType,
            style: const TextStyle(fontSize: 14),
            maxLines: widget.isMultiline ? null : 1,
            minLines: widget.isMultiline ? 3 : null,
            validator: widget.validator ?? _defaultValidator,
            obscureText: widget.isPassword && !_isVisible,
            decoration: InputDecoration(
              labelText: widget.hint,
              prefixIcon: widget.icon == null ? null : Icon(widget.icon),
            ),
          ),
          _buildVisibilityButton(),
        ],
      ),
    );
  }

  Widget _buildVisibilityButton() {
    if (!widget.isPassword) return const SizedBox();

    return Align(
      alignment: Alignment.centerRight,
      child: IconButton(
        onPressed: () => setState(() => _isVisible = !_isVisible),
        icon: Icon(
          _isVisible
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          color: Colors.black26,
        ),
      ),
    );
  }
}
