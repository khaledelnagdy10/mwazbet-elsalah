import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mwazbet_elsalah/features/home/presentation/controller/prayer_time_cubit/prayer_time_cubit.dart';

class AzanNotificationDialog extends StatelessWidget {
  const AzanNotificationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrayerTimeCubit, PrayerTimeState>(
      builder: (context, state) {
        final cubit = context.read<PrayerTimeCubit>();

        return Dialog(
          backgroundColor: Colors.transparent,
          child: TweenAnimationBuilder(
            duration: const Duration(milliseconds: 300),
            tween: Tween(begin: 0.8, end: 1.0),
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Opacity(opacity: value, child: child),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.notifications_active, size: 40),
                  const SizedBox(height: 8),

                  const Text(
                    "Azan Settings",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  ...cubit.azanNotification.keys.map((prayerName) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: cubit.azanNotification[prayerName]!
                            ? Colors.green.withOpacity(0.1)
                            : Colors.grey.withOpacity(0.05),
                      ),
                      child: SwitchListTile(
                        title: Text(prayerName),
                        value: cubit.azanNotification[prayerName]!,
                        onChanged: (value) {
                          context.read<PrayerTimeCubit>().toogleAzan(
                            prayerName,
                            value,
                          );
                        },
                      ),
                    );
                  }).toList(),

                  const SizedBox(height: 10),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Done"),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
