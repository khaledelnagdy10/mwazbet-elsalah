import 'package:flutter/material.dart';
import 'package:mwazbet_elsalah/constants.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
    this.onChanged,
    this.readyOnly = false,
    this.textColor,
  });

  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final void Function(String)? onChanged;
  final bool readyOnly;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readyOnly,
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      obscureText: obscureText,
      onChanged: onChanged,
      style: TextStyle(
        fontSize: 14,
        color: textColor ?? kTextDarkColor,
        fontWeight: FontWeight.w500,
      ),
      cursorColor: kPrimaryColor,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: textColor ?? Colors.grey.shade400,
          fontSize: 13,
          fontWeight: FontWeight.w400,
        ),
        prefixIcon: Icon(prefixIcon, size: 20, color: Colors.grey.shade500),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: const Color(0xFFFAFAFA),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFE7E7E7), width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: kPrimaryColor, width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.4),
        ),
      ),
    );
  }
}
