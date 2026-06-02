import 'package:flutter/material.dart';

void customBottomSheet({
  required BuildContext context,
  required String title,
  required GlobalKey<FormState> formKey,
  required List<Widget> fields,
  required Future<void> Function(BuildContext bottomContext) onSave,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (bottomContext) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 15),
              ...fields,
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      await onSave(bottomContext);
                    }
                  },
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
