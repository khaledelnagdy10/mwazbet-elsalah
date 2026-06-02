import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mwazbet_elsalah/core/utils/localize_prayer_time.dart';
import 'package:mwazbet_elsalah/features/home/presentation/controller/prayer_tracking_cubit/prayer_tracking_cubit.dart';

class CheckBoxListTile extends StatelessWidget {
  const CheckBoxListTile({
    super.key,
    required this.prayer,
    required this.prayerTime,
    required this.isPrayed,
    required this.date,
  });

  final String prayer;
  final String prayerTime;
  final bool isPrayed;
  final String date;

  Future<void> _savePrayer(BuildContext context, bool value) async {
    await context.read<PrayerTrackingCubit>().savePrayer(
      prayerName: prayer,
      isPrayed: value,
      date: date,
    );
  }

  @override
  Widget build(BuildContext context) {
    Color getBackgroundColor() {
      return isPrayed ? Colors.green.withOpacity(0.15) : Colors.transparent;
    }

    return SizedBox(
      height: 65,
      width: double.infinity,
      child: Slidable(
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              borderRadius: BorderRadius.circular(5),
              onPressed: (_) async {
                await _savePrayer(context, true);
              },
              backgroundColor: Colors.green.withGreen(100),
              icon: Icons.mosque,
              label: 'Prayed'.tr(),
            ),
            SlidableAction(
              borderRadius: BorderRadius.circular(5),
              onPressed: (_) async {
                await _savePrayer(context, false);
              },
              backgroundColor: Colors.red.withRed(100),
              foregroundColor: Colors.white,
              icon: Icons.mosque,
              label: 'Not Prayed'.tr(),
            ),
          ],
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: getBackgroundColor(),
            borderRadius: BorderRadius.circular(8),
          ),
          child: CheckboxListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  prayer,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) =>
                      ScaleTransition(scale: animation, child: child),
                  child: isPrayed
                      ? Icon(
                          Icons.check_circle,
                          key: ValueKey('prayed'.tr()),
                          color: Colors.green,
                          size: 24,
                        )
                      : Text(
                          localizePrayerTime(context, prayerTime),
                          key: ValueKey('notPrayed'.tr()),
                          style: const TextStyle(fontSize: 15),
                        ),
                ),
              ],
            ),
            value: isPrayed,
            onChanged: (value) async {
              await _savePrayer(context, value ?? false);
            },
            controlAffinity: ListTileControlAffinity.leading,
            side: BorderSide(color: Colors.green.withGreen(150), width: 1.5),
          ),
        ),
      ),
    );
  }
}
