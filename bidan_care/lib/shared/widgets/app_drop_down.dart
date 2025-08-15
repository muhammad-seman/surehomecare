import 'package:bidan_care/shared/styles/app_colors.dart';
import 'package:flutter/material.dart';

class AppDropDown<T> extends StatefulWidget {
  const AppDropDown({
    super.key,
    required this.initialValue,
    required this.label,
    required this.items,
    required this.onChanged,
    this.autoRebuild = true,
  });

  final T initialValue;
  final String label;
  final List<DropdownMenuItem<T>> items;
  final Function(T? value) onChanged;
  final bool autoRebuild;

  @override
  State<AppDropDown<T>> createState() => _AppDropDownState<T>();
}

class _AppDropDownState<T> extends State<AppDropDown<T>> {
  late T? _value;

  void _onChanged(T? value) {
    if (widget.autoRebuild) setState(() => _value = value);
    widget.onChanged(value);
  }

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label),
        Container(
          margin: const EdgeInsets.only(top: 4, bottom: 16),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: AppColors.primaryColor),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: _value,
              isExpanded: true,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              dropdownColor: Colors.white,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                color: Colors.black,
              ),
              items: widget.items,
              onChanged: _onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
