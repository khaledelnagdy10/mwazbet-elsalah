import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mwazbet_elsalah/features/home/data/data_source/prayer_tracking_remote_data_source.dart';
import 'package:mwazbet_elsalah/features/home/data/models/prayer_tracking_model.dart';

class PrayerTrackingRemoteDataSourceImp
    implements PrayerTrackingRemoteDataSource {
  @override
  Future<void> savePrayerStatus({
    required String prayerName,
    required bool isPrayed,
    required String date,
  }) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) throw Exception('No user logged in');

    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('prayer_tracking')
        .doc(date);

    final doc = await docRef.get();

    if (!doc.exists) {
      await docRef.set({
        'date': date,
        'fajr': false,
        'dhuhr': false,
        'asr': false,
        'maghrib': false,
        'isha': false,
      });
    }

    final key = prayerName.toLowerCase() == "juma'a"
        ? 'dhuhr'
        : prayerName.toLowerCase();

    await docRef.update({key: isPrayed});
  }

  @override
  Future<PrayerTrackingModel?> getPrayerStatus({required String date}) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) throw Exception('No user logged in');

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('prayer_tracking')
        .doc(date)
        .get();

    if (!doc.exists || doc.data() == null) return null;

    return PrayerTrackingModel.fromJson(doc.data()!);
  }
}
