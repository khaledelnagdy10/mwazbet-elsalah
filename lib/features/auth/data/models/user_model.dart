import 'package:mwazbet_elsalah/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.uid,
    required super.email,
    required super.country,
    required super.city,
    required super.firstName,
    required super.lastName,
    required super.emailVerified,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] ?? '',
      email: json['email'] ?? '',
      country: json['country'] ?? '',
      city: json['city'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      emailVerified: json['emailVerified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email.toLowerCase().trim(),
      'country': country,
      'city': city,
      'firstName': firstName,
      'lastName': lastName,
      'fullName': fullName,
      'emailVerified': emailVerified,
    };
  }
}
