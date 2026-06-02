import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mwazbet_elsalah/core/utils/app_background.dart';
import 'package:mwazbet_elsalah/features/family/presentation/view/my_children_view.dart';
import 'package:mwazbet_elsalah/features/family/presentation/view/pending_invites_view.dart';
import 'package:mwazbet_elsalah/features/family/presentation/view/send_request_view.dart';

class FamilyView extends StatelessWidget {
  const FamilyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Family'.tr()),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          AppBackground(),
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  Expanded(
                    child: _ActionCard(
                      title: 'Send Request'.tr(),
                      icon: Icons.person_add_alt_1_outlined,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SendRequestView(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ActionCard(
                      title: 'Pending Requests'.tr(),
                      icon: Icons.mark_email_unread_outlined,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PendingRequestsView(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              _ActionCard(
                title: 'My Children'.tr(),
                icon: Icons.groups_2_outlined,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MyChildrenView()),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          height: 115,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.black.withOpacity(0.06)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 28),
              const Spacer(),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
