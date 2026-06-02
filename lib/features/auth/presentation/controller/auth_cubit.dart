import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:mwazbet_elsalah/features/auth/domain/entities/user_entity.dart';
import 'package:mwazbet_elsalah/features/auth/domain/use_cases/get_current_user.dart';
import 'package:mwazbet_elsalah/features/auth/domain/use_cases/log_in.dart';
import 'package:mwazbet_elsalah/features/auth/domain/use_cases/reset_password_use_case.dart';
import 'package:mwazbet_elsalah/features/auth/domain/use_cases/save_city_use_case.dart';
import 'package:mwazbet_elsalah/features/auth/domain/use_cases/sign_in_with_facebook_use_case.dart';
import 'package:mwazbet_elsalah/features/auth/domain/use_cases/sign_in_with_google_use_case.dart';
import 'package:mwazbet_elsalah/features/auth/domain/use_cases/sign_out.dart';
import 'package:mwazbet_elsalah/features/auth/domain/use_cases/sign_up.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required this.signUpUseCase,
    required this.logInUseCase,
    required this.signOutUseCase,
    required this.getCurrentUserUseCase,
    required this.saveCityUseCase,
    required this.updatePasswordUseCase,
    required this.signInWithGoogleUseCase,
    required this.signInWithFacebookUseCase,
    required this.resetPasswordUseCase,
  }) : super(AuthInitial());

  final SignUpUseCase signUpUseCase;
  final LogInUseCase logInUseCase;
  final SignOutUseCase signOutUseCase;
  final GetCurrentUser getCurrentUserUseCase;
  final SaveCityUseCase saveCityUseCase;
  final ResetPasswordUseCase updatePasswordUseCase;
  final SignInWithGoogleUseCase signInWithGoogleUseCase;
  final SignInWithFacebookUseCase signInWithFacebookUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;

  Future<void> signUp({
    required String email,
    required String password,
    required String country,
    required String city,
    required String firstName,
    required String lastName,
  }) async {
    emit(AuthLoading());
    try {
      final user = await signUpUseCase.call(
        email: email,
        password: password,
        country: country,
        city: city,
        firstName: firstName,
        lastName: lastName,
      );
      emit(AuthSuccess(user: user));
    } catch (e) {
      emit(AuthFailure(errMess: e.toString()));
    }
  }

  Future<void> logIn({required String email, required String password}) async {
    emit(AuthLoading());
    try {
      final user = await logInUseCase.call(email: email, password: password);
      emit(AuthSuccess(user: user));
    } catch (e) {
      emit(AuthFailure(errMess: e.toString()));
    }
  }

  Future<void> signInWithGoogle() async {
    emit(AuthLoading());
    try {
      final user = await signInWithGoogleUseCase.call();
      emit(AuthSuccess(user: user));
    } catch (e) {
      emit(AuthFailure(errMess: e.toString()));
    }
  }

  Future<void> signInWithFacebook() async {
    emit(AuthLoading());
    try {
      final user = await signInWithFacebookUseCase.call();
      emit(AuthSuccess(user: user));
    } catch (e) {
      emit(AuthFailure(errMess: e.toString()));
    }
  }

  Future<void> resetPassword({required String email}) async {
    emit(AuthLoading());
    try {
      await resetPasswordUseCase.call(email: email);
      emit(AuthPasswordResetSent());
    } catch (e) {
      emit(AuthFailure(errMess: e.toString()));
    }
  }

  Future<void> signOut() async {
    emit(AuthLoading());

    try {
      await signOutUseCase();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthFailure(errMess: e.toString()));
    }
  }

  Future<void> getCurrentUser() async {
    emit(AuthLoading());

    try {
      final user = await getCurrentUserUseCase.call();
      if (user != null) {
        emit(AuthSuccess(user: user));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> saveCity({required String city}) async {
    try {
      await saveCityUseCase(city: city);
    } catch (e) {
      emit(AuthFailure(errMess: e.toString()));
    }
  }

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    final user = FirebaseAuth.instance.currentUser;

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

  Future<void> changeName({
    required String firstName,
    required String lastName,
  }) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) throw Exception('No user');

    final fullName = '$firstName $lastName'.trim();

    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'firstName': firstName.trim(),
      'lastName': lastName.trim(),
      'fullName': fullName,
    });
  }

  Future<void> changeAddress({
    required String country,
    required String city,
  }) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) throw Exception('No user');

    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'country': country,
      'city': city,
    });
  }
}
