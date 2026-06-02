import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mwazbet_elsalah/core/utils/format_date.dart';
import 'package:mwazbet_elsalah/features/family/data/models/child_prayer_status_model.dart';

class ChildPrayerTrackingView extends StatefulWidget {
  const ChildPrayerTrackingView({
    super.key,
    required this.childId,
    required this.childName,
  });

  final String childId;
  final String childName;

  @override
  State<ChildPrayerTrackingView> createState() =>
      _ChildPrayerTrackingViewState();
}

class _ChildPrayerTrackingViewState extends State<ChildPrayerTrackingView> {
  DateTime selectedDate = DateTime.now();

  Future<ChildPrayerStatusModel> getChildPrayerStatus() async {
    final date = formatDate(selectedDate);

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.childId)
        .collection('prayer_tracking')
        .doc(date)
        .get();

    if (!doc.exists || doc.data() == null) {
      return ChildPrayerStatusModel.empty(date);
    }

    return ChildPrayerStatusModel.fromJson(doc.data()!);
  }

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      initialDate: selectedDate,
    );

    if (picked == null) return;

    setState(() {
      selectedDate = picked;
    });
  }

  @override
  Widget build(BuildContext context) {
    final date = formatDate(selectedDate);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.childName),
        actions: [
          IconButton(
            onPressed: pickDate,
            icon: const Icon(Icons.calendar_month),
          ),
        ],
      ),
      body: FutureBuilder<ChildPrayerStatusModel>(
        future: getChildPrayerStatus(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final tracking = snapshot.data ?? ChildPrayerStatusModel.empty(date);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.green.withOpacity(0.08),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.childName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(date),
                    const SizedBox(height: 12),
                    Text(
                      'Prayed ${tracking.prayedCount} / 5',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _PrayerStatusTile(name: 'Fajr', value: tracking.fajr),
              _PrayerStatusTile(name: 'Dhuhr', value: tracking.dhuhr),
              _PrayerStatusTile(name: 'Asr', value: tracking.asr),
              _PrayerStatusTile(name: 'Maghrib', value: tracking.maghrib),
              _PrayerStatusTile(name: 'Isha', value: tracking.isha),
            ],
          );
        },
      ),
    );
  }
}

class _PrayerStatusTile extends StatelessWidget {
  const _PrayerStatusTile({required this.name, required this.value});

  final String name;
  final bool value;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(value ? 'Prayed'.tr() : 'Not prayed'.tr()),
        trailing: Icon(
          value ? Icons.check_circle : Icons.cancel,
          color: value ? Colors.green : Colors.red,
        ),
      ),
    );
  }
}
