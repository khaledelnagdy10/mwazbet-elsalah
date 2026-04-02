import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CheckBoxListTile extends StatefulWidget {
  const CheckBoxListTile({
    super.key,
    required this.prayer,
    required this.prayerTime,
  });
  final String prayer;
  final String prayerTime;

  @override
  State<CheckBoxListTile> createState() => _CheckBoxListTileState();
}

class _CheckBoxListTileState extends State<CheckBoxListTile> {
  bool isPrayed = false;

  @override
  Widget build(BuildContext context) {
    String prayer = widget.prayer;
    String prayerTime = widget.prayerTime;

    Color getBackgroundColor() {
      return isPrayed ? Colors.green.withOpacity(0.15) : Colors.transparent;
    }

    return SizedBox(
      height: 65,
      width: double.infinity,
      child: Slidable(
        startActionPane: ActionPane(
          motion: ScrollMotion(),
          children: [
            SlidableAction(
              borderRadius: BorderRadius.circular(5),
              onPressed: (context) {
                setState(() {
                  isPrayed = true;
                });
              },
              backgroundColor: Colors.green.withGreen(100),
              icon: Icons.mosque,
              label: 'Prayed',
            ),
            SlidableAction(
              borderRadius: BorderRadius.circular(5),

              onPressed: (context) {
                setState(() {
                  isPrayed = false;
                });
              },
              backgroundColor: Colors.red.withRed(100),
              foregroundColor: Colors.white,
              icon: Icons.mosque,
              label: 'Not Prayed',
            ),
          ],
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
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
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) =>
                      ScaleTransition(scale: animation, child: child),
                  child: isPrayed
                      ? Icon(
                          Icons.check_circle,
                          key: const ValueKey('prayed'),
                          color: Colors.green,
                          size: 24,
                        )
                      : Text(
                          prayerTime,
                          key: const ValueKey('notPrayed'),
                          style: TextStyle(fontSize: 16),
                        ),
                ),
              ],
            ),
            value: isPrayed,
            onChanged: (value) {
              setState(() {
                isPrayed = value!;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
            side: BorderSide(color: Colors.green.withGreen(150), width: 1.5),
          ),
        ),
      ),
    );
  }
}
