import 'package:flutter/material.dart';

class PrayerLoadingView extends StatefulWidget {
  const PrayerLoadingView({super.key});

  @override
  State<PrayerLoadingView> createState() => _PrayerLoadingViewState();
}

class _PrayerLoadingViewState extends State<PrayerLoadingView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _fade = Tween<double>(begin: 0.3, end: 0.8).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget box({double height = 20, double width = double.infinity}) {
    return FadeTransition(
      opacity: _fade,
      child: Container(
        height: height,
        width: width,
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: loading,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  late final loading = Theme.of(context).brightness == Brightness.dark
      ? Colors.white.withValues(alpha: 0.08)
      : Colors.grey.withValues(alpha: 0.3);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header skeleton
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [box(width: 120, height: 20), box(width: 40, height: 40)],
          ),

          const SizedBox(height: 20),

          // Date skeleton
          box(width: 180, height: 25),

          const SizedBox(height: 30),

          // Next prayer card skeleton
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: loading,
              borderRadius: BorderRadius.circular(16),
            ),
          ),

          const SizedBox(height: 20),

          // List skeleton
          box(height: 60),
          box(height: 60),
          box(height: 60),
          box(height: 60),
          box(height: 60),
        ],
      ),
    );
  }
}
