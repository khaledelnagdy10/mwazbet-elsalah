import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mwazbet_elsalah/features/family/presentation/controller/family_cubit/family_cubit.dart';
import 'package:mwazbet_elsalah/features/family/presentation/view/send_request_view.dart';
import 'package:mwazbet_elsalah/features/family/presentation/view/pending_invites_view.dart';

class FamilyBottomSheet extends StatelessWidget {
  const FamilyBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Family',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),

          const SizedBox(height: 20),

          ListTile(
            leading: const Icon(Icons.qr_code),
            title: const Text('Create Invite'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SendRequestView()),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.mail),
            title: const Text('Pending Invites'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PendingRequestsView()),
              );
            },
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
