import 'package:flutter/material.dart';

class ProfileField extends StatelessWidget {
  const ProfileField({
    super.key,
    required this.label,
    required this.value,
    required this.enabled,
  });

  final String label;
  final String value;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: enabled ? Colors.grey[100] : Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          const SizedBox(height: 5),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
