import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SaveProfileButton extends StatelessWidget {
  const SaveProfileButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(onPressed: onTap, child: Text('Save Changes'.tr())),
    );
  }
}
