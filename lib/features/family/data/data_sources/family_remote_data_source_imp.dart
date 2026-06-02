import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mwazbet_elsalah/features/family/data/data_sources/family_remote_data_source.dart';
import 'package:mwazbet_elsalah/features/family/data/models/family_request_model.dart';

class FamilyRemoteDataSourceImp implements FamilyRemoteDataSource {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Future<void> sendRequest({required String receiverEmail}) async {
    final currentUser = auth.currentUser;

    if (currentUser == null) {
      throw Exception('No user logged in');
    }

    final senderDoc = await firestore
        .collection('users')
        .doc(currentUser.uid)
        .get();

    if (!senderDoc.exists || senderDoc.data() == null) {
      throw Exception('Sender data not found');
    }

    final cleanReceiverEmail = receiverEmail.trim().toLowerCase();

    final receiverQuery = await firestore
        .collection('users')
        .where('email', isEqualTo: cleanReceiverEmail)
        .limit(1)
        .get();

    if (receiverQuery.docs.isEmpty) {
      throw Exception('User not found');
    }

    final receiverDoc = receiverQuery.docs.first;
    final receiverData = receiverDoc.data();

    if (receiverDoc.id == currentUser.uid) {
      throw Exception('You cannot send request to yourself');
    }

    final existingRequest = await firestore
        .collection('family_requests')
        .where('senderId', isEqualTo: currentUser.uid)
        .where('receiverId', isEqualTo: receiverDoc.id)
        .where('status', isEqualTo: 'pending')
        .limit(1)
        .get();

    if (existingRequest.docs.isNotEmpty) {
      throw Exception('Request already sent');
    }

    final senderData = senderDoc.data()!;
    final requestRef = firestore.collection('family_requests').doc();

    final request = FamilyRequestModel(
      id: requestRef.id,
      senderId: currentUser.uid,
      senderName: senderData['fullName'] ?? '',
      senderEmail: senderData['email'] ?? '',
      receiverId: receiverDoc.id,
      receiverName: receiverData['fullName'] ?? '',
      receiverEmail: receiverData['email'] ?? cleanReceiverEmail,
      status: 'pending',
    );

    await requestRef.set(request.toJson());
  }

  @override
  Future<List<FamilyRequestModel>> getPendingRequests() async {
    final currentUser = auth.currentUser;

    if (currentUser == null) {
      throw Exception('No user logged in');
    }

    final snapshot = await firestore
        .collection('family_requests')
        .where('receiverId', isEqualTo: currentUser.uid)
        .where('status', isEqualTo: 'pending')
        .get();

    return snapshot.docs
        .map((doc) => FamilyRequestModel.fromJson(doc.id, doc.data()))
        .toList();
  }

  @override
  Future<void> acceptRequest({required String requestId}) async {
    final currentUser = auth.currentUser;

    if (currentUser == null) {
      throw Exception('No user logged in');
    }

    final requestRef = firestore.collection('family_requests').doc(requestId);
    final requestDoc = await requestRef.get();

    if (!requestDoc.exists || requestDoc.data() == null) {
      throw Exception('Request not found');
    }

    final data = requestDoc.data()!;

    if (data['receiverId'] != currentUser.uid) {
      throw Exception('You cannot accept this request');
    }

    if (data['status'] != 'pending') {
      throw Exception('Request is not pending');
    }

    final senderId = data['senderId'];
    final receiverId = data['receiverId'];

    final batch = firestore.batch();

    batch.update(requestRef, {
      'status': 'accepted',
      'acceptedAt': FieldValue.serverTimestamp(),
    });

    batch.set(
      firestore
          .collection('users')
          .doc(senderId)
          .collection('children')
          .doc(receiverId),
      {
        'childId': receiverId,
        'childName': data['receiverName'] ?? '',
        'childEmail': data['receiverEmail'] ?? '',
        'requestId': requestId,
        'createdAt': FieldValue.serverTimestamp(),
      },
    );

    batch.set(
      firestore
          .collection('users')
          .doc(receiverId)
          .collection('parents')
          .doc(senderId),
      {
        'parentId': senderId,
        'parentName': data['senderName'] ?? '',
        'parentEmail': data['senderEmail'] ?? '',
        'requestId': requestId,
        'createdAt': FieldValue.serverTimestamp(),
      },
    );

    await batch.commit();
  }

  @override
  Future<void> rejectRequest({required String requestId}) async {
    final currentUser = auth.currentUser;

    if (currentUser == null) {
      throw Exception('No user logged in');
    }

    final requestRef = firestore.collection('family_requests').doc(requestId);
    final requestDoc = await requestRef.get();

    if (!requestDoc.exists || requestDoc.data() == null) {
      throw Exception('Request not found');
    }

    final data = requestDoc.data()!;

    if (data['receiverId'] != currentUser.uid) {
      throw Exception('You cannot reject this request');
    }

    await requestRef.update({
      'status': 'rejected',
      'rejectedAt': FieldValue.serverTimestamp(),
    });
  }
}
