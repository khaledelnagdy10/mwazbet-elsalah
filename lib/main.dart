import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mwazbet_elsalah/core/services/notification_service.dart';
import 'package:mwazbet_elsalah/core/view/animated_splash_view.dart';
import 'package:mwazbet_elsalah/core/view/splash_view.dart';
import 'package:mwazbet_elsalah/features/auth/data/data_sources/auth_remote_data_source_imp.dart';
import 'package:mwazbet_elsalah/features/auth/data/repos/auth_repo_imp.dart';
import 'package:mwazbet_elsalah/features/auth/domain/use_cases/get_current_user.dart';
import 'package:mwazbet_elsalah/features/auth/domain/use_cases/log_in.dart';
import 'package:mwazbet_elsalah/features/auth/domain/use_cases/save_city_use_case.dart';
import 'package:mwazbet_elsalah/features/auth/domain/use_cases/sign_in_with_facebook_use_case.dart';
import 'package:mwazbet_elsalah/features/auth/domain/use_cases/sign_in_with_google_use_case.dart';
import 'package:mwazbet_elsalah/features/auth/domain/use_cases/sign_out.dart';
import 'package:mwazbet_elsalah/features/auth/domain/use_cases/sign_up.dart';
import 'package:mwazbet_elsalah/features/auth/domain/use_cases/reset_password_use_case.dart';
import 'package:mwazbet_elsalah/features/auth/presentation/controller/auth_cubit.dart';
import 'package:mwazbet_elsalah/features/auth/presentation/view/auth_view.dart';
import 'package:mwazbet_elsalah/features/family/data/data_sources/family_remote_data_source_imp.dart';
import 'package:mwazbet_elsalah/features/family/data/repo/family_repo_imp.dart';
import 'package:mwazbet_elsalah/features/family/domain/use_cases/accept_invite_use_case.dart';
import 'package:mwazbet_elsalah/features/family/domain/use_cases/send_invite_use_case.dart';
import 'package:mwazbet_elsalah/features/family/domain/use_cases/get_pending_invites_use_case.dart';
import 'package:mwazbet_elsalah/features/family/domain/use_cases/reject_invite_use_case.dart';
import 'package:mwazbet_elsalah/features/family/presentation/controller/family_cubit/family_cubit.dart';
import 'package:mwazbet_elsalah/features/home/data/api/api.dart';
import 'package:mwazbet_elsalah/features/home/data/data_source/prayer_tracking_remote_data_source_imp.dart';
import 'package:mwazbet_elsalah/features/home/data/repo/prayer_time_repo_imp.dart';
import 'package:mwazbet_elsalah/features/home/data/repo/prayer_tracking_repo_imp.dart';
import 'package:mwazbet_elsalah/features/home/domain/use_cases/get_next_prayer.dart';
import 'package:mwazbet_elsalah/features/home/domain/use_cases/get_prayer_time.dart';
import 'package:mwazbet_elsalah/features/home/domain/use_cases/get_prayer_use_case.dart';
import 'package:mwazbet_elsalah/features/home/domain/use_cases/get_remaining_time.dart';
import 'package:mwazbet_elsalah/features/home/domain/use_cases/save_prayer_use_case.dart';
import 'package:mwazbet_elsalah/features/home/presentation/controller/prayer_time_cubit/prayer_time_cubit.dart';
import 'package:mwazbet_elsalah/features/home/presentation/controller/prayer_tracking_cubit/prayer_tracking_cubit.dart';
import 'package:mwazbet_elsalah/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await EasyLocalization.ensureInitialized();
  await NotificationService.init();
  await NotificationService.schedulePrayer(
    id: 999,
    prayerName: 'اختبار',
    prayerTime: DateTime.now().add(const Duration(seconds: 30)),
  );

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PrayerTimeCubit(
            getPrayerTime: GetPrayerTime(
              prayerTimeRepo: PrayerTimeRepoImp(api: Api(dio: Dio())),
            ),
            getNextPrayer: GetNextPrayer(),
            getRemainingTime: GetRemainingTimeUseCase(),
          ),
        ),
        BlocProvider(
          create: (_) {
            final remote = AuthRemoteDataSourceImp();
            final repo = AuthRepoImp(authRemoteDataSource: remote);

            return AuthCubit(
              signUpUseCase: SignUpUseCase(authRepo: repo),
              logInUseCase: LogInUseCase(authRepo: repo),
              signOutUseCase: SignOutUseCase(authRepo: repo),
              getCurrentUserUseCase: GetCurrentUser(authRepo: repo),
              saveCityUseCase: SaveCityUseCase(authRepo: repo),
              updatePasswordUseCase: ResetPasswordUseCase(authRepo: repo),
              signInWithGoogleUseCase: SignInWithGoogleUseCase(authRepo: repo),
              signInWithFacebookUseCase: SignInWithFacebookUseCase(
                authRepo: repo,
              ),
              resetPasswordUseCase: ResetPasswordUseCase(authRepo: repo),
            );
          },
        ),

        BlocProvider(
          create: (_) => PrayerTrackingCubit(
            savePrayerStatusUseCase: SavePrayerStatusUseCase(
              repo: PrayerTrackingRepoImp(
                remoteDataSource: PrayerTrackingRemoteDataSourceImp(),
              ),
            ),
            getPrayerStatusUseCase: GetPrayerStatusUseCase(
              repo: PrayerTrackingRepoImp(
                remoteDataSource: PrayerTrackingRemoteDataSourceImp(),
              ),
            ),
          ),
        ),
        BlocProvider(
          create: (_) {
            final familyRemote = FamilyRemoteDataSourceImp();
            final familyRepo = FamilyRepoImp(remoteDataSource: familyRemote);
            return FamilyCubit(
              sendRequestUseCase: SendRequestUseCase(familyRepo: familyRepo),
              getPendingRequestsUseCase: GetPendingRequestsUseCase(
                familyRepo: familyRepo,
              ),
              acceptRequestUseCase: AcceptRequestUseCase(
                familyRepo: familyRepo,
              ),
              rejectRequestUseCase: RejectRequestUseCase(
                familyRepo: familyRepo,
              ),
            );
          },
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        theme: FlexThemeData.light(
          useMaterial3: true,
          colors: const FlexSchemeColor(
            primary: Colors.green,
            primaryContainer: Color(0xFFDCE9E2),
            secondary: Color(0xFFD4A373),
            secondaryContainer: Color(0xFFF4E6D7),
            tertiary: Color(0xFF6B705C),
            tertiaryContainer: Color(0xFFEAE7DC),
            appBarColor: Color(0xFFF8F4EE),
            error: Color(0xFFB3261E),
          ),
          scaffoldBackground: const Color(0xFFF8F4EE),
          surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
          blendLevel: 8,
          appBarStyle: FlexAppBarStyle.background,
          subThemesData: const FlexSubThemesData(
            defaultRadius: 16,
            inputDecoratorRadius: 14,
            inputDecoratorBorderType: FlexInputBorderType.outline,
            elevatedButtonRadius: 16,
            cardRadius: 20,
            dialogRadius: 20,
            bottomNavigationBarElevation: 0,
          ),
        ),
        darkTheme: FlexThemeData.dark(
          useMaterial3: true,
          colors: const FlexSchemeColor(
            primary: Color(0xFFB7D6C5),
            primaryContainer: Color(0xFF1B4332),
            secondary: Color(0xFFD4A373),
            secondaryContainer: Color(0xFF6B4F3A),
            tertiary: Color(0xFFDAD7CD),
            tertiaryContainer: Color(0xFF344E41),
            appBarColor: Color(0xFF0F1E18),
            error: Color(0xFFF2B8B5),
          ),
          scaffoldBackground: const Color(0xFF0F1E18),
          surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
          blendLevel: 10,
          appBarStyle: FlexAppBarStyle.background,
          subThemesData: const FlexSubThemesData(
            defaultRadius: 16,
            inputDecoratorRadius: 14,
            inputDecoratorBorderType: FlexInputBorderType.outline,
            elevatedButtonRadius: 16,
            cardRadius: 20,
            dialogRadius: 20,
            bottomNavigationBarElevation: 0,
          ),
        ),
        themeMode: ThemeMode.system,

        home: const SplashView(),
      ),
    );
  }
}
