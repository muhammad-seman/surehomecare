import 'package:flutter/material.dart';

class ProfilSwitchItem extends StatefulWidget {
  const ProfilSwitchItem({
    super.key,
    required this.title,
    required this.initialValue,
    required this.onChanged,
  });

  final String title;
  final bool initialValue;
  final Future<bool?> Function(bool value) onChanged;

  @override
  State<ProfilSwitchItem> createState() => _ProfilSwitchItemState();
}

class _ProfilSwitchItemState extends State<ProfilSwitchItem> {
  late bool _value;
  bool _isLoading = false;

  void _onChanged(bool value) async {
    if (_isLoading) return;
    _isLoading = true;
    final newValue = await widget.onChanged(value);
    _isLoading = false;
    if (newValue != null) setState(() => _value = newValue);
  }

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(widget.title, style: const TextStyle(fontSize: 14)),
        Switch(
          value: _value,
          onChanged: _onChanged,
        ),
      ],
    );
  }
}
