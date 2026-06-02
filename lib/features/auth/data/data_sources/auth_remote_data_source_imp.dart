import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mwazbet_elsalah/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:mwazbet_elsalah/features/auth/data/models/user_model.dart';

class AuthRemoteDataSourceImp implements AuthRemoteDataSource {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<UserModel> _saveSocialUser(User firebaseUser) async {
    final docRef = firestore.collection('users').doc(firebaseUser.uid);
    final doc = await docRef.get();

    if (doc.exists && doc.data() != null) {
      await docRef.update({'emailVerified': firebaseUser.emailVerified});

      final updatedDoc = await docRef.get();
      return UserModel.fromJson(updatedDoc.data()!);
    }

    final nameParts = (firebaseUser.displayName ?? '').trim().split(' ');
    final firstName = nameParts.isNotEmpty ? nameParts.first : '';
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

    final user = UserModel(
      uid: firebaseUser.uid,
      email: firebaseUser.email?.toLowerCase().trim() ?? '',
      country: '',
      city: '',
      firstName: firstName,
      lastName: lastName,
      emailVerified: firebaseUser.emailVerified,
    );

    await docRef.set({
      ...user.toJson(),
      'createdAt': FieldValue.serverTimestamp(),
      'provider': firebaseUser.providerData.isNotEmpty
          ? firebaseUser.providerData.first.providerId
          : 'social',
    });

    return user;
  }

  @override
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String country,
    required String city,
    required String firstName,
    required String lastName,
  }) async {
    final cleanEmail = email.toLowerCase().trim();

    try {
      final credential = await auth.createUserWithEmailAndPassword(
        email: cleanEmail,
        password: password,
      );

      final firebaseUser = credential.user!;
      await firebaseUser.sendEmailVerification();

      final user = UserModel(
        uid: firebaseUser.uid,
        email: cleanEmail,
        country: country.trim(),
        city: city.trim(),
        firstName: firstName.trim(),
        lastName: lastName.trim(),
        emailVerified: firebaseUser.emailVerified,
      );

      await firestore.collection('users').doc(firebaseUser.uid).set({
        ...user.toJson(),
        'createdAt': FieldValue.serverTimestamp(),
        'provider': 'password',
      });

      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        throw Exception('Invalid email address');
      }
      if (e.code == 'weak-password') {
        throw Exception('The password provided is too weak');
      }
      if (e.code == 'email-already-in-use') {
        throw Exception('The account already exists for that email');
      }
      throw Exception(e.message ?? 'Sign up failed');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<UserModel> logIn({
    required String email,
    required String password,
  }) async {
    final cleanEmail = email.toLowerCase().trim();

    try {
      final credential = await auth.signInWithEmailAndPassword(
        email: cleanEmail,
        password: password,
      );

      final firebaseUser = credential.user!;
      await firebaseUser.reload();

      final refreshedUser = auth.currentUser!;

      if (!refreshedUser.emailVerified) {
        await refreshedUser.sendEmailVerification();
        throw Exception(
          'Please verify your email first. Verification email sent again',
        );
      }

      await firestore.collection('users').doc(refreshedUser.uid).update({
        'emailVerified': true,
      });

      final doc = await firestore
          .collection('users')
          .doc(refreshedUser.uid)
          .get();

      if (!doc.exists || doc.data() == null) {
        throw Exception('User data not found');
      }

      return UserModel.fromJson(doc.data()!);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        throw Exception('Invalid email or password');
      }
      if (e.code == 'invalid-email') {
        throw Exception('Invalid email address');
      }
      throw Exception(e.message ?? 'Login failed');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn.instance.authenticate();

      final googleAuth = googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final userCredential = await auth.signInWithCredential(credential);
      final firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        throw Exception('Google sign in failed');
      }

      return _saveSocialUser(firebaseUser);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<UserModel> signInWithFacebook() async {
    final result = await FacebookAuth.instance.login();

    if (result.status != LoginStatus.success) {
      throw Exception('Facebook sign in cancelled');
    }

    final accessToken = result.accessToken;

    if (accessToken == null) {
      throw Exception('Facebook access token not found');
    }

    final credential = FacebookAuthProvider.credential(accessToken.tokenString);

    final userCredential = await auth.signInWithCredential(credential);
    final firebaseUser = userCredential.user;

    if (firebaseUser == null) {
      throw Exception('Facebook sign in failed');
    }

    return _saveSocialUser(firebaseUser);
  }

  @override
  Future<void> resetPassword({required String email}) async {
    final cleanEmail = email.toLowerCase().trim();

    if (cleanEmail.isEmpty) {
      throw Exception('Enter your email');
    }

    await auth.sendPasswordResetEmail(email: cleanEmail);
  }

  @override
  Future<void> signOut() async {
    await GoogleSignIn.instance.signOut();
    await FacebookAuth.instance.logOut();
    await auth.signOut();
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final currentUser = auth.currentUser;

    if (currentUser == null) {
      return null;
    }

    final doc = await firestore.collection('users').doc(currentUser.uid).get();

    if (!doc.exists || doc.data() == null) {
      return null;
    }

    return UserModel.fromJson(doc.data()!);
  }

  @override
  Future<void> saveCity({required String city}) async {
    final user = auth.currentUser;

    if (user == null) throw Exception('No user');

    await firestore.collection('users').doc(user.uid).update({'city': city});
  }

  @override
  Future<void> updatePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    final user = auth.currentUser;

    if (user == null) throw Exception('No user');

    try {
      final cred = EmailAuthProvider.credential(
        email: user.email!,
        password: oldPassword,
      );

      await user.reauthenticateWithCredential(cred);
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        throw Exception('old-password-wrong');
      }

      throw Exception(e.code);
    }
  }

  @override
  Future<void> updateName({
    required String firstName,
    required String lastName,
  }) async {
    final user = auth.currentUser;

    if (user == null) throw Exception('No user');

    final fullName = '$firstName $lastName'.trim();

    await firestore.collection('users').doc(user.uid).update({
      'firstName': firstName.trim(),
      'lastName': lastName.trim(),
      'fullName': fullName,
    });

    await user.updateDisplayName(fullName);
  }

  @override
  Future<void> updateAddress({
    required String country,
    required String city,
  }) async {
    final user = auth.currentUser;

    if (user == null) throw Exception('No user');

    await firestore.collection('users').doc(user.uid).update({
      'country': country,
      'city': city,
    });
  }
}
