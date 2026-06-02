import 'package:country_state_city_pro/country_state_city_pro.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mwazbet_elsalah/features/auth/presentation/controller/auth_cubit.dart';

void showProfileCityPicker(
  BuildContext context,
  TextEditingController countryController,
  TextEditingController cityController,
) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    barrierColor: Colors.black26,
    builder: (bottomSheetContext) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.5,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              /// picker
              CountryStateCityPicker(
                country: countryController,
                state: cityController,
              ),

              const Spacer(),

              /// confirm button
              ElevatedButton(
                onPressed: () async {
                  final city = cityController.text.trim();
                  final country = countryController.text.trim();

                  if (city.isEmpty || country.isEmpty) {
                    ScaffoldMessenger.of(bottomSheetContext).showSnackBar(
                      SnackBar(
                        content: Text('Please select country and city'.tr()),
                      ),
                    );
                    return;
                  }

                  final cubit = bottomSheetContext.read<AuthCubit>();

                  /// 🔥 حفظ في firestore
                  await cubit.saveCity(city: city);

                  /// لو عندك saveCountry ضيفه هنا
                  // await cubit.saveCountry(country: country);

                  /// 🔥 refresh
                  await cubit.getCurrentUser();

                  if (bottomSheetContext.mounted) {
                    Navigator.pop(bottomSheetContext);
                  }
                },
                child: Text('Save'.tr()),
              ),
            ],
          ),
        ),
      );
    },
  );
}
