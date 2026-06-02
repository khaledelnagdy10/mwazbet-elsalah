class UserEntity {
  final String uid;
  final String email;
  final String country;
  final String city;
  final String firstName;
  final String lastName;
  final bool emailVerified;

  UserEntity({
    required this.uid,
    required this.email,
    required this.country,
    required this.city,
    required this.firstName,
    required this.lastName,
    required this.emailVerified,
  });

  String get fullName => '$firstName $lastName'.trim();
}
