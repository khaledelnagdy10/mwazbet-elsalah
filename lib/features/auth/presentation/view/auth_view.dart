import 'package:country_state_city_pro/country_state_city_pro.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mwazbet_elsalah/constants.dart';
import 'package:mwazbet_elsalah/core/view/my_main_navigator.dart';
import 'package:mwazbet_elsalah/features/auth/presentation/controller/auth_cubit.dart';
import 'package:mwazbet_elsalah/features/auth/presentation/widgets/auth_type.dart';
import 'package:mwazbet_elsalah/core/utils/widgets/custom_form_field.dart';
import 'package:mwazbet_elsalah/features/auth/presentation/widgets/main_auth_button.dart';
import 'package:mwazbet_elsalah/features/auth/presentation/widgets/section_lable.dart';
import 'package:mwazbet_elsalah/features/auth/presentation/widgets/social_auth_button.dart';

class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  final loginFormKey = GlobalKey<FormState>();
  final signupFormKey = GlobalKey<FormState>();

  final loginEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();

  final signUpEmailController = TextEditingController();
  final signUpFirstNameController = TextEditingController();
  final signUpLastNameController = TextEditingController();
  final signUpPasswordController = TextEditingController();
  final signUpConfirmPasswordController = TextEditingController();
  final signUpCountryController = TextEditingController();
  final signUpCityController = TextEditingController();

  bool isLogin = true;
  bool rememberMe = false;
  bool obscureLoginPassword = true;
  bool obscureSignUpPassword = true;
  bool obscureConfirmPassword = true;

  static const Color lightGrey = Color(0xFFF3F3F3);

  @override
  void dispose() {
    loginEmailController.dispose();
    loginPasswordController.dispose();

    signUpEmailController.dispose();
    signUpFirstNameController.dispose();
    signUpLastNameController.dispose();
    signUpPasswordController.dispose();
    signUpConfirmPasswordController.dispose();
    signUpCountryController.dispose();
    signUpCityController.dispose();

    super.dispose();
  }

  void _submit() {
    final valid = isLogin
        ? loginFormKey.currentState!.validate()
        : signupFormKey.currentState!.validate();

    if (!valid) return;

    if (isLogin) {
      context.read<AuthCubit>().logIn(
        email: loginEmailController.text.trim(),
        password: loginPasswordController.text.trim(),
      );
    } else {
      context.read<AuthCubit>().signUp(
        email: signUpEmailController.text.trim(),
        password: signUpPasswordController.text.trim(),
        country: signUpCountryController.text.trim(),
        city: signUpCityController.text.trim(),
        firstName: signUpFirstNameController.text.trim(),
        lastName: signUpLastNameController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const MainNavigationView()),
          );
        } else if (state is AuthPasswordResetSent) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password reset email sent')),
          );
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errMess)));
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              children: [
                const SizedBox(height: 10),
                SizedBox(
                  height: 170,
                  child: Image.asset(
                    'assets/images/prayer_auth.jpeg',
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isLogin ? 'Welcome Back'.tr() : 'Create Account'.tr(),
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.w700,
                    color: kTextDarkColor,
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    isLogin
                        ? 'Fill out the information below in order to access your account.'
                              .tr()
                        : 'Create your account today and start a blessed Quran journey.'
                              .tr(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12.5,
                      height: 1.5,
                      color: Colors.black54,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: lightGrey,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final width = constraints.maxWidth / 2;

                      return Stack(
                        children: [
                          AnimatedPositioned(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOutCubic,
                            left: isLogin ? 4 : width,
                            top: 4,
                            child: Container(
                              width: width - 8,
                              height: 36,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(13),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: AuthType(
                                  text: 'Log In'.tr(),
                                  selected: isLogin,
                                  onTap: () {
                                    setState(() {
                                      isLogin = true;
                                    });
                                  },
                                ),
                              ),
                              Expanded(
                                child: AuthType(
                                  text: 'Sign Up'.tr(),
                                  selected: !isLogin,
                                  onTap: () {
                                    setState(() {
                                      isLogin = false;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 18),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  child: isLogin ? _buildLoginForm() : _buildSignupForm(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: loginFormKey,
      child: Column(
        key: const ValueKey('login_form'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionLabel('Email'.tr()),
          const SizedBox(height: 8),
          CustomTextFormField(
            controller: loginEmailController,
            hintText: 'Enter your email'.tr(),
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Enter your email'.tr();
              }
              if (!value.contains('@')) {
                return 'Enter a valid email'.tr();
              }
              return null;
            },
          ),
          const SizedBox(height: 14),
          SectionLabel('Password'.tr()),
          const SizedBox(height: 8),
          CustomTextFormField(
            controller: loginPasswordController,
            hintText: 'Enter your Password'.tr(),
            prefixIcon: Icons.lock_outline,
            obscureText: obscureLoginPassword,
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  obscureLoginPassword = !obscureLoginPassword;
                });
              },
              icon: Icon(
                obscureLoginPassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                size: 20,
                color: Colors.black45,
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Enter your password'.tr();
              }
              if (value.trim().length < 6) {
                return 'Password must be at least 6 characters'.tr();
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              SizedBox(
                width: 18,
                height: 18,
                child: Checkbox(
                  value: rememberMe,
                  activeColor: kPrimaryColor,
                  side: const BorderSide(color: Colors.black38),
                  onChanged: (value) {
                    setState(() {
                      rememberMe = value ?? false;
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Remember me'.tr(),
                style: TextStyle(fontSize: 12, color: Colors.black87),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () async {
                  final email = loginEmailController.text.trim();

                  if (email.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Enter your email first'.tr())),
                    );
                    return;
                  }

                  await context.read<AuthCubit>().resetPassword(email: email);
                },
                child: Text(
                  'Forgot Password'.tr(),
                  style: TextStyle(
                    fontSize: 12,
                    color: blueLink,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          AuthButton(text: 'Login'.tr(), onTap: _submit),
          const SizedBox(height: 16),
          Center(
            child: Text(
              'Or continue with'.tr(),
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: SocialAuthButton(
                  text: 'Google'.tr(),
                  iconText: 'G',
                  onTap: () async {
                    await GoogleSignIn.instance.initialize();

                    await context.read<AuthCubit>().signInWithGoogle();
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Center(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isLogin = false;
                });
              },
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(fontSize: 12, color: Colors.black87),
                  children: [
                    TextSpan(text: "Don't have an account".tr()),
                    TextSpan(
                      text: 'Create an account'.tr(),
                      style: TextStyle(
                        color: blueLink,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignupForm() {
    return Form(
      key: signupFormKey,
      child: Column(
        key: const ValueKey('signup_form'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionLabel('First Name'.tr()),
          const SizedBox(height: 8),
          CustomTextFormField(
            controller: signUpFirstNameController,
            hintText: 'Enter your first name'.tr(),
            prefixIcon: Icons.person_outline,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Enter your first name'.tr();
              }
              return null;
            },
          ),
          const SizedBox(height: 14),
          SectionLabel('Last Name'.tr()),
          const SizedBox(height: 8),
          CustomTextFormField(
            controller: signUpLastNameController,
            hintText: 'Enter your last name'.tr(),
            prefixIcon: Icons.person_outline,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Enter your last name'.tr();
              }
              return null;
            },
          ),
          const SizedBox(height: 14),
          SectionLabel('Email'.tr()),
          const SizedBox(height: 8),
          CustomTextFormField(
            controller: signUpEmailController,
            hintText: 'Enter your email'.tr(),
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Enter your email'.tr();
              }
              if (!value.contains('@')) {
                return 'Enter a valid email'.tr();
              }
              return null;
            },
          ),
          const SizedBox(height: 14),
          SectionLabel('Password'.tr()),
          const SizedBox(height: 8),
          CustomTextFormField(
            controller: signUpPasswordController,
            hintText: 'Enter your Password'.tr(),
            prefixIcon: Icons.lock_outline,
            obscureText: obscureSignUpPassword,
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  obscureSignUpPassword = !obscureSignUpPassword;
                });
              },
              icon: Icon(
                obscureSignUpPassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                size: 20,
                color: Colors.black45,
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Enter your password'.tr();
              }
              if (value.trim().length < 6) {
                return 'Password must be at least 6 characters'.tr();
              }
              return null;
            },
          ),
          const SizedBox(height: 14),
          SectionLabel('Confirm Password'.tr()),
          const SizedBox(height: 8),
          CustomTextFormField(
            controller: signUpConfirmPasswordController,
            hintText: 'Confirm your Password'.tr(),
            prefixIcon: Icons.lock_outline,
            obscureText: obscureConfirmPassword,
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  obscureConfirmPassword = !obscureConfirmPassword;
                });
              },
              icon: Icon(
                obscureConfirmPassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                size: 20,
                color: Colors.black45,
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Confirm your password'.tr();
              }
              if (value != signUpPasswordController.text) {
                return 'Passwords do not match'.tr();
              }
              return null;
            },
          ),
          const SizedBox(height: 18),
          SectionLabel('Location'.tr()),
          CountryStateCityPicker(
            country: signUpCountryController,
            state: signUpCityController,
          ),
          const SizedBox(height: 14),
          AuthButton(text: 'Register'.tr(), onTap: _submit),
          const SizedBox(height: 16),
          Center(
            child: Text(
              'Or continue with'.tr(),
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: SocialAuthButton(
                  text: 'Google'.tr(),
                  iconText: 'G',
                  onTap: () async {
                    await context.read<AuthCubit>().signInWithGoogle();
                  },
                ),
              ),
              // const SizedBox(width: 12),
              // Expanded(
              //   child: SocialAuthButton(
              //     text: 'Facebook',
              //     icon: Icons.facebook,
              //     onTap: () async {
              //       await context.read<AuthCubit>().signInWithFacebook();
              //     },
              //   ),
              // ),
            ],
          ),
          const SizedBox(height: 18),
          Center(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isLogin = true;
                });
              },
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(fontSize: 12, color: Colors.black87),
                  children: [
                    TextSpan(text: 'Already have an account'.tr()),
                    TextSpan(
                      text: 'Log In'.tr(),
                      style: TextStyle(
                        color: blueLink,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
