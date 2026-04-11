import 'package:flutter/material.dart';
import 'package:mwazbet_elsalah/constants.dart';
import 'package:mwazbet_elsalah/features/auth/presentation/widgets/auth_type.dart';
import 'package:mwazbet_elsalah/features/auth/presentation/widgets/custom_form_field.dart';
import 'package:mwazbet_elsalah/features/auth/presentation/widgets/main_auth_button.dart';
import 'package:mwazbet_elsalah/features/auth/presentation/widgets/section_lable.dart';
import 'package:mwazbet_elsalah/features/auth/presentation/widgets/social_auth_button.dart';
import 'package:mwazbet_elsalah/features/home/presentation/view/home_view.dart';

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
  final signUpPasswordController = TextEditingController();
  final signUpConfirmPasswordController = TextEditingController();

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
    signUpPasswordController.dispose();
    signUpConfirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    final valid = isLogin
        ? loginFormKey.currentState!.validate()
        : signupFormKey.currentState!.validate();

    if (!valid) return;

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const HomeView()),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              isLogin ? 'Welcome Back' : 'Create Account',
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
                    : 'Create your account today and start a blessed Quran journey.',
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
                      /// 🔥 المربع المتحرك
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

                      /// 👇 الزرارين بتوعك
                      Row(
                        children: [
                          Expanded(
                            child: AuthType(
                              text: 'Log In',
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
                              text: 'Sign up',
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
  }

  Widget _buildLoginForm() {
    return Form(
      key: loginFormKey,
      child: Column(
        key: const ValueKey('login_form'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel('Email'),
          const SizedBox(height: 8),
          CustomTextFormField(
            controller: loginEmailController,
            hintText: 'Enter your email',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Enter your email';
              }
              if (!value.contains('@')) {
                return 'Enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 14),
          const SectionLabel('Password'),
          const SizedBox(height: 8),
          CustomTextFormField(
            controller: loginPasswordController,
            hintText: 'Enter your Password',
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
                return 'Enter your password';
              }
              if (value.trim().length < 6) {
                return 'Password must be at least 6 characters';
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
              const Text(
                'Remember me',
                style: TextStyle(fontSize: 12, color: Colors.black87),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'Forgot Password?',
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
          AuthButton(text: 'Login', onTap: _submit),
          const SizedBox(height: 16),
          const Center(
            child: Text(
              'Or continue with',
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: SocialAuthButton(
                  text: 'Google',
                  iconText: 'G',
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SocialAuthButton(
                  text: 'Apple',
                  icon: Icons.apple,
                  onTap: () {},
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
                    const TextSpan(text: "Don't have an account? "),
                    TextSpan(
                      text: 'Create an account',
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
          const SectionLabel('Email'),
          const SizedBox(height: 8),
          CustomTextFormField(
            controller: signUpEmailController,
            hintText: 'Enter your email',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Enter your email';
              }
              if (!value.contains('@')) {
                return 'Enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 14),
          const SectionLabel('Password'),
          const SizedBox(height: 8),
          CustomTextFormField(
            controller: signUpPasswordController,
            hintText: 'Enter your Password',
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
                return 'Enter your password';
              }
              if (value.trim().length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 14),
          const SectionLabel('Confirm Password'),
          const SizedBox(height: 8),
          CustomTextFormField(
            controller: signUpConfirmPasswordController,
            hintText: 'Confirm your Password',
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
                return 'Confirm your password';
              }
              if (value != signUpPasswordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          const SizedBox(height: 18),
          AuthButton(text: 'Register', onTap: _submit),
          const SizedBox(height: 16),
          const Center(
            child: Text(
              'Or continue with',
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: SocialAuthButton(
                  text: 'Google',
                  iconText: 'G',
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SocialAuthButton(
                  text: 'Apple',
                  icon: Icons.apple,
                  onTap: () {},
                ),
              ),
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
                    const TextSpan(text: 'Already have an account? '),
                    TextSpan(
                      text: 'Log In',
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
