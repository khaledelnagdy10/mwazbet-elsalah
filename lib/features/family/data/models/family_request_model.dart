import 'package:cloud_firestore/cloud_firestore.dart';

class FamilyRequestModel {
  final String id;
  final String senderId;
  final String senderName;
  final String senderEmail;
  final String receiverId;
  final String receiverName;
  final String receiverEmail;
  final String status;

  FamilyRequestModel({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.senderEmail,
    required this.receiverId,
    required this.receiverName,
    required this.receiverEmail,
    required this.status,
  });

  factory FamilyRequestModel.fromJson(String id, Map<String, dynamic> json) {
    return FamilyRequestModel(
      id: id,
      senderId: json['senderId'] ?? '',
      senderName: json['senderName'] ?? '',
      senderEmail: json['senderEmail'] ?? '',
      receiverId: json['receiverId'] ?? '',
      receiverName: json['receiverName'] ?? '',
      receiverEmail: json['receiverEmail'] ?? '',
      status: json['status'] ?? 'pending',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'senderName': senderName,
      'senderEmail': senderEmail,
      'receiverId': receiverId,
      'receiverName': receiverName,
      'receiverEmail': receiverEmail,
      'status': status,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
