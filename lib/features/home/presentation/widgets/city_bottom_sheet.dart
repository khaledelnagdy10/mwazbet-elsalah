import 'package:country_state_city_pro/country_state_city_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mwazbet_elsalah/features/home/presentation/controller/prayer_time_cubit/prayer_time_cubit.dart';
import 'package:easy_localization/easy_localization.dart';

void showCityPicker(BuildContext context) {
  final countryController = TextEditingController();
  final cityController = TextEditingController();

  showModalBottomSheet(
    useSafeArea: true,
    barrierColor: Colors.black26, // 👈 يخلي البرّه clickable وواضح

    context: context,
    isScrollControlled: true,
    builder: (bottomSheetContext) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.5,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              CountryStateCityPicker(
                country: countryController,
                state: cityController,
              ),

              const Spacer(),

              ElevatedButton(
                onPressed: () {
                  final selectedCity = cityController.text.trim();

                  if (selectedCity.isEmpty) {
                    ScaffoldMessenger.of(bottomSheetContext).showSnackBar(
                      SnackBar(content: Text('Please select a city'.tr())),
                    );
                    return;
                  }

                  bottomSheetContext.read<PrayerTimeCubit>().getCity(
                    selectedCity,
                  );

                  Navigator.pop(bottomSheetContext);
                },
                child: Text('Confirm'.tr()),
              ),
            ],
          ),
        ),
      );
    },
  );
}
