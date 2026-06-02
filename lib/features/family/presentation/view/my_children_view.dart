import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mwazbet_elsalah/features/family/presentation/view/child_prayer_tracking_view.dart';

class MyChildrenView extends StatelessWidget {
  const MyChildrenView({super.key});

  Stream<QuerySnapshot<Map<String, dynamic>>> getChildrenStream() {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('No user logged in');
    }

    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('children')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Children'.tr())),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: getChildrenStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final children = snapshot.data?.docs ?? [];

          if (children.isEmpty) {
            return Center(child: Text('No children linked yet'.tr()));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: children.length,
            itemBuilder: (context, index) {
              final child = children[index].data();

              final childId = child['childId'] ?? children[index].id;
              final childName = child['childName'] ?? 'Unknown';
              final childEmail = child['childEmail'] ?? '';

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(
                    childName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(childEmail),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChildPrayerTrackingView(
                          childId: childId,
                          childName: childName,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
