import 'package:country_state_city_pro/country_state_city_pro.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mwazbet_elsalah/core/utils/app_background.dart';
import 'package:mwazbet_elsalah/core/utils/widgets/custom_bottom_sheet.dart';
import 'package:mwazbet_elsalah/core/utils/widgets/custom_form_field.dart';
import 'package:mwazbet_elsalah/features/auth/presentation/controller/auth_cubit.dart';
import 'package:mwazbet_elsalah/features/auth/presentation/view/auth_view.dart';
import 'package:mwazbet_elsalah/features/auth/presentation/widgets/section_lable.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final currentNameController = TextEditingController();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  final currentLocationController = TextEditingController();
  final countryController = TextEditingController();
  final cityController = TextEditingController();

  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final hiddenPasswordController = TextEditingController();

  final nameFormKey = GlobalKey<FormState>();
  final locationFormKey = GlobalKey<FormState>();
  final passwordFormKey = GlobalKey<FormState>();

  String? oldPasswordError;

  @override
  void initState() {
    super.initState();
    context.read<AuthCubit>().getCurrentUser();
  }

  @override
  void dispose() {
    currentNameController.dispose();

    firstNameController.dispose();
    lastNameController.dispose();

    currentLocationController.dispose();
    countryController.dispose();
    cityController.dispose();

    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    hiddenPasswordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is! AuthSuccess) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              IconButton(
                onPressed: () async {
                  final currentLocale = context.locale;

                  if (currentLocale.languageCode == 'en') {
                    await context.setLocale(const Locale('ar'));
                  } else {
                    await context.setLocale(const Locale('en'));
                  }
                },
                icon: const Icon(Icons.language),
              ),

              IconButton(
                onPressed: () async {
                  await context.read<AuthCubit>().signOut();

                  if (!context.mounted) return;

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const AuthView()),
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.logout_rounded, color: Colors.red),
              ),
            ],
          ),
          body: Stack(
            children: [
              AppBackground(),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SectionLabel('Full Name'.tr()),

                        GestureDetector(
                          onTap: () {
                            currentNameController.text = state.user.fullName;

                            firstNameController.text = state.user.firstName;

                            lastNameController.text = state.user.lastName;

                            customBottomSheet(
                              context: context,
                              title: 'Change your Name'.tr(),
                              formKey: nameFormKey,
                              fields: [
                                CustomTextFormField(
                                  controller: currentNameController,
                                  hintText: '',
                                  prefixIcon: Icons.person,
                                  readyOnly: true,
                                ),

                                const SizedBox(height: 10),
                                Row(
                                  children: [SectionLabel('First name'.tr())],
                                ),
                                CustomTextFormField(
                                  controller: firstNameController,
                                  hintText: 'Enter first name'.tr(),
                                  prefixIcon: Icons.person_outline,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Enter first name'.tr();
                                    }

                                    return null;
                                  },
                                ),

                                const SizedBox(height: 10),
                                Row(children: [SectionLabel('Last name'.tr())]),
                                CustomTextFormField(
                                  controller: lastNameController,
                                  hintText: 'Enter last name'.tr(),
                                  prefixIcon: Icons.person_outline,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Enter last name'.tr();
                                    }

                                    return null;
                                  },
                                ),
                              ],
                              onSave: (bottomContext) async {
                                await context.read<AuthCubit>().changeName(
                                  firstName: firstNameController.text.trim(),
                                  lastName: lastNameController.text.trim(),
                                );

                                await context
                                    .read<AuthCubit>()
                                    .getCurrentUser();

                                Navigator.pop(bottomContext);
                              },
                            );
                          },
                          child: Text('Edit'.tr()),
                        ),
                      ],
                    ),

                    CustomTextFormField(
                      controller: TextEditingController(),
                      hintText: state.user.fullName,
                      prefixIcon: Icons.person,
                      readyOnly: true,
                      textColor: Colors.black,
                    ),

                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SectionLabel('Location'.tr()),

                        GestureDetector(
                          onTap: () {
                            currentLocationController.text =
                                '${state.user.country.tr()}, ${state.user.city.tr()}';

                            countryController.clear();
                            cityController.clear();

                            customBottomSheet(
                              context: context,
                              title: 'Change location'.tr(),
                              formKey: locationFormKey,
                              fields: [
                                CustomTextFormField(
                                  controller: TextEditingController(
                                    text:
                                        '${state.user.country.tr()}, ${state.user.city.tr()}',
                                  ),
                                  hintText: '',
                                  prefixIcon: Icons.location_on,
                                  readyOnly: true,
                                  textColor: Colors.black,
                                ),

                                const SizedBox(height: 15),

                                CountryStateCityPicker(
                                  country: countryController,
                                  state: cityController,
                                ),
                              ],
                              onSave: (bottomContext) async {
                                if (countryController.text.isEmpty ||
                                    cityController.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Select country and city'.tr(),
                                      ),
                                    ),
                                  );

                                  return;
                                }

                                await context.read<AuthCubit>().changeAddress(
                                  country: countryController.text.trim(),
                                  city: cityController.text.trim(),
                                );

                                await context
                                    .read<AuthCubit>()
                                    .getCurrentUser();

                                Navigator.pop(bottomContext);
                              },
                            );
                          },
                          child: Text('Edit'.tr()),
                        ),
                      ],
                    ),

                    CustomTextFormField(
                      controller: TextEditingController(),
                      hintText:
                          '${state.user.country.tr()}, ${state.user.city.tr()}',
                      prefixIcon: Icons.location_on,
                      readyOnly: true,
                      textColor: Colors.black,
                    ),

                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SectionLabel('password'.tr()),

                        GestureDetector(
                          onTap: () {
                            oldPasswordController.clear();

                            newPasswordController.clear();

                            confirmPasswordController.clear();

                            oldPasswordError = null;

                            customBottomSheet(
                              context: context,
                              title: 'Change password'.tr(),
                              formKey: passwordFormKey,
                              fields: [
                                CustomTextFormField(
                                  controller: oldPasswordController,
                                  hintText: 'Old password'.tr(),
                                  prefixIcon: Icons.lock,
                                  obscureText: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Enter old password'.tr();
                                    }

                                    return oldPasswordError;
                                  },
                                ),

                                const SizedBox(height: 10),

                                CustomTextFormField(
                                  controller: newPasswordController,
                                  hintText: 'New password'.tr(),
                                  prefixIcon: Icons.lock_outline,
                                  obscureText: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Enter new password'.tr();
                                    }

                                    if (value.length < 6) {
                                      return 'Min 6 characters'.tr();
                                    }

                                    return null;
                                  },
                                ),

                                const SizedBox(height: 10),

                                CustomTextFormField(
                                  controller: confirmPasswordController,
                                  hintText: 'Confirm password'.tr(),
                                  prefixIcon: Icons.lock_outline,
                                  obscureText: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Confirm password'.tr();
                                    }

                                    if (value != newPasswordController.text) {
                                      return 'Password must be matching'.tr();
                                    }

                                    return null;
                                  },
                                ),
                              ],
                              onSave: (bottomContext) async {
                                try {
                                  oldPasswordError = null;

                                  await context
                                      .read<AuthCubit>()
                                      .changePassword(
                                        oldPassword: oldPasswordController.text
                                            .trim(),
                                        newPassword: newPasswordController.text
                                            .trim(),
                                      );

                                  await context
                                      .read<AuthCubit>()
                                      .getCurrentUser();

                                  Navigator.pop(bottomContext);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Password updated'.tr()),
                                    ),
                                  );
                                } catch (e) {
                                  if (e.toString().contains(
                                    'old-password-wrong',
                                  )) {
                                    setState(() {
                                      oldPasswordError = 'Old password is wrong'
                                          .tr();
                                    });

                                    passwordFormKey.currentState!.validate();

                                    return;
                                  }

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(e.toString())),
                                  );
                                }
                              },
                            );
                          },
                          child: Text('Edit'.tr()),
                        ),
                      ],
                    ),

                    CustomTextFormField(
                      controller: hiddenPasswordController,
                      hintText: '************',
                      prefixIcon: Icons.lock,
                      readyOnly: true,
                      textColor: Colors.black,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
