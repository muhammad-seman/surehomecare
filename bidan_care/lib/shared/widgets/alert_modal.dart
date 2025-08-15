import 'package:flutter/material.dart';

class AlertModal extends StatelessWidget {
  const AlertModal({
    super.key,
    required this.title,
    required this.confirmText,
  });

  final String title;
  final String confirmText;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text(
        title,
        textAlign: TextAlign.center,
      ),
      contentPadding: const EdgeInsets.all(20),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: ButtonStyle(
            overlayColor: WidgetStatePropertyAll(Colors.grey.shade200),
            foregroundColor: const WidgetStatePropertyAll(Colors.grey),
          ),
          child: const Text("Batal"),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          style: ButtonStyle(
            overlayColor: WidgetStatePropertyAll(Colors.green.shade100),
            foregroundColor: const WidgetStatePropertyAll(Colors.red),
          ),
          child: Text(confirmText),
        ),
      ],
    );
  }
}
