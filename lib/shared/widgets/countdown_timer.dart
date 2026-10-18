import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ecomins/core/theme/app_colors.dart';

/// Live countdown timer that ticks every second.
class CountdownTimer extends StatefulWidget {
  const CountdownTimer({
    super.key,
    required this.endTime,
    this.style,
  });

  final DateTime endTime;
  final TextStyle? style;

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Timer _timer;
  late Duration _remaining;

  @override
  void initState() {
    super.initState();
    _remaining = widget.endTime.difference(DateTime.now());
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final r = widget.endTime.difference(DateTime.now());
      if (mounted) {
        setState(() => _remaining = r.isNegative ? Duration.zero : r);
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _pad(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    final h = _remaining.inHours;
    final m = _remaining.inMinutes.remainder(60);
    final s = _remaining.inSeconds.remainder(60);
    return Text(
      '${_pad(h)}:${_pad(m)}:${_pad(s)}',
      style: widget.style ??
          const TextStyle(
            color: AppColors.primary,
            fontSize: 14,
            fontWeight: FontWeight.w700,
            fontFeatures: [FontFeature.tabularFigures()],
          ),
    );
  }
}
