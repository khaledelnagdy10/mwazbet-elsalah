import 'package:country_state_city_pro/country_state_city_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mwazbet_elsalah/features/home/presentation/controller/prayer_time_cubit.dart';

void showCityPicker(BuildContext context) {
  final countryController = TextEditingController();
  final stateController = TextEditingController();
  final cityController = TextEditingController();

  showModalBottomSheet(
    isDismissible: true,
    enableDrag: true,
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
                  if (cityController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please select a city')),
                    );
                    return;
                  }

                  context.read<PrayerTimeCubit>().changeCity(
                    cityController.text,
                  );

                  Navigator.pop(bottomSheetContext);
                },
                child: const Text('Confirm'),
              ),
            ],
          ),
        ),
      );
    },
  );
}
