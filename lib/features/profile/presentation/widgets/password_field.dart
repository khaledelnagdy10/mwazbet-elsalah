import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class PasswordField extends StatelessWidget {
  const PasswordField({
    super.key,
    required this.controller,
    required this.hint,
  });

  final TextEditingController controller;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Required'.tr();
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
